import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:al_moiin/flutter_scure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// استيراد ملفات مشروعك
import 'package:al_moiin/ask_first.dart';
import 'auth_view_model.dart';

// تعريف حالات الفحص خارج الكلاس ليسهل الوصول إليها
enum CheckResult { success, noInternet, serverError, invalidLicense }

class LicenseViewModel extends ChangeNotifier {
  final AuthViewModel authViewModel;

  LicenseViewModel(this.authViewModel);

  String? _licenseKey;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isActivated = false;
  bool _isDialogOpen = false; // لمنع تكرار فتح الـ Dialog

  String? get licenseKey => _licenseKey;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isActivated => _isActivated;

  CheckResult checkResult = CheckResult.success;

  // 1. فحص اتصال الإنترنت العام
  Future<CheckResult> checkInternet() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5)); // إضافة مهلة
      if (response.statusCode == 200) {
        return CheckResult.success;
      }
      return CheckResult.noInternet;
    } catch (_) {
      return CheckResult.noInternet;
    }
  }

  // 2. فحص حالة التفعيل (الأساسية)
  Future<CheckResult> checkActivationStatus() async {
    final prefs = await SharedPreferences.getInstance();

    _isActivated = prefs.getBool('is_activated') ?? false;
    _licenseKey = await SecureStorageService.getUserKey();

    // fake date for test
    prefs.setString(
      'last_sync_date',
      DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
    );
    String? lastCheckStr = prefs.getString('last_sync_date');

    if (!_isActivated || _licenseKey == null) {
      return CheckResult.invalidLicense;
    }

    // التحقق من مرور 24 ساعة
    if (lastCheckStr != null) {
      DateTime lastCheck = DateTime.parse(lastCheckStr);
      DateTime localDateTime = lastCheck.toLocal(); // التوقيت المحلي (الجزائر)
      DateTime now = DateTime.now();

      if (now.difference(localDateTime).inHours >= 24) {
        debugPrint("More than 24h passed. Needs online check.");
        return await performOnlineCheck(_licenseKey!);
      }
    }

    return CheckResult.success;
  }

  // 3. التحقق عبر الإنترنت من السيرفر (Laravel)
  Future<CheckResult> performOnlineCheck(String key) async {
    try {
      // نتأكد من الإنترنت أولاً
      checkResult = await checkInternet();
      if (checkResult != CheckResult.success) return checkResult;

      final response = await http
          .post(
            Uri.parse('${authViewModel.licenseUrl}/check'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'license_key': key,
              'device_id': authViewModel.deviceInfo?.deviceId,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        // تحديث تاريخ المزامنة القادم من السيرفر
        await prefs.setString(
          'last_sync_date',
          data['license']['last_sync_date'],
        );
        return CheckResult.success;
      } else if (response.statusCode >= 500) {
        return CheckResult.serverError;
      } else {
        return CheckResult.invalidLicense; // 401 أو 403
      }
    } on SocketException {
      return CheckResult.serverError;
    } on TimeoutException {
      return CheckResult.serverError;
    } catch (e) {
      debugPrint("Online check failed: $e");
      return CheckResult.serverError;
    }
  }

  // 4. التحقق من صيغة المفتاح (محلية)
  bool isLicenseKeyValid(String key) {
    if (key.isEmpty) return false;
    String cleanedKey = key.replaceAll('-', '');
    if (cleanedKey.length < 16) return false;
    final regex = RegExp(r'^[A-Z0-9]{4}(-[A-Z0-9]{4}){3}$');
    return regex.hasMatch(key);
  }

  // 5. تفعيل الترخيص لأول مرة
  Future<bool> activateLicense(String key) async {
    if (!isLicenseKeyValid(key)) {
      _errorMessage = 'يرجى إدخال مفتاح ترخيص صالح.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      checkResult = await checkInternet();
      if (checkResult != CheckResult.success) {
        _errorMessage = 'لا يوجد اتصال بالإنترنت.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final url = Uri.parse('${authViewModel.licenseUrl}/activate');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'license_key': key,
              'device_id': authViewModel.deviceInfo?.deviceId,
              'device_model': authViewModel.deviceInfo?.deviceName,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          if (data['success'] == true) {
            _isActivated = true;
            _licenseKey = key;

            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('is_activated', true);
            await SecureStorageService.saveUserKey(key);

            // تحقق من وجود 'license' قبل القراءة لتجنب أخطاء Null
            if (data['license'] != null &&
                data['license']['last_sync_date'] != null) {
              await prefs.setString(
                'last_sync_date',
                data['license']['last_sync_date'],
              );
            }

            _isLoading = false;
            notifyListeners();
            return true;
          }
          break;
        case 401:
          _errorMessage = 'مفتاح الترخيص هذا غير صالح';
          break;
        case 403:
          _errorMessage =
              data['error'] ?? 'هذا الترخيص منتهي أو غير متاح حالياً.';
          break;
        case 422:
          _errorMessage = 'البيانات المرسلة غير صالحة. تأكد من إعدادات الجهاز.';
          break;
        case 500:
          _errorMessage = 'خطأ داخلي في الخادم. يرجى مراسلة الدعم الفني.';
          break;
        default:
          _errorMessage = 'حدث خطأ غير متوقع (${response.statusCode}).';
      }
    } on SocketException {
      _errorMessage = 'لا يمكن الوصول للسيرفر. تأكد من الـ IP والـ Firewall.';
    } on TimeoutException {
      _errorMessage = 'انتهت مهلة الاتصال. السيرفر بطيء جداً.';
    } catch (e) {
      _errorMessage = 'حدث خطأ غير معروف: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // 6. التحقق الأمني عند دخول الشاشة
  void checkSecurityOnEntry(BuildContext context) async {
    CheckResult status = await checkActivationStatus();
    if (status != CheckResult.success) {
      showSessionExpiredDialog(context, initialError: status);
    }
  }

  // 7. عرض الـ Dialog الاحترافي
  void showSessionExpiredDialog(
    BuildContext context, {
    CheckResult? initialError,
  }) {
    if (_isDialogOpen) return;

    _isDialogOpen = true;

    // تحديد الرسالة المبدئية بناءً على نوع الخطأ
    String dialogMessage = '';
    if (initialError == CheckResult.noInternet) {
      dialogMessage = 'لا يوجد اتصال بالإنترنت. تأكد من إعدادات الشبكة.';
    }
    if (initialError == CheckResult.serverError) {
      dialogMessage = 'لا يمكن الوصول للسيرفر. يرجى المحاولة لاحقاً.';
    }
    if (initialError == CheckResult.invalidLicense) {
      dialogMessage = 'الترخيص الخاص بك غير صالح أو منتهي.';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // تحديد الأيقونة واللون بناءً على نوع الخطأ
            bool isServerError = initialError == CheckResult.serverError;
            IconData headerIcon = isServerError
                ? Icons.dns_rounded
                : Icons.security_rounded;
            Color themeColor = isServerError
                ? Colors.orange.shade700
                : Colors.red.shade700;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              titlePadding: EdgeInsets.zero,
              title: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(headerIcon, color: Colors.white, size: 40),
                    const SizedBox(height: 10),
                    Text(
                      isServerError ? 'خطأ في الاتصال' : 'تنبيه أمني',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  dialogMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('حاول مرة أخرى'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          // منطق التحقق الخاص بك هنا...
                          CheckResult result = await checkActivationStatus();
                          if (result == CheckResult.success) {
                            Navigator.of(context).pop();
                          } else {
                            setDialogState(() {
                              // if (result == CheckResult.noInternet) {
                              //   dialogMessage =
                              //       'لا يوجد اتصال بالإنترنت. تأكد من الـ Wifi.';
                              // } else if (result == CheckResult.serverError) {
                              //   dialogMessage =
                              //       'السيرفر لا يستجيب، تحقق من الخادم.';
                              // } else {
                              //   dialogMessage = 'الرخصة منتهية، يرجى التجديد.';
                              // }
                            });
                          }
                        },
                      ),
                      TextButton(
                        child: const Text(
                          'خروج من التطبيق',
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: () async {
                          // مسح البيانات الأمنية عند الخروج الإجباري
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('last_sync_date');

                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (builder) => const AskFirst(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) => _isDialogOpen = false);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
