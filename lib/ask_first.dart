import 'package:al_moiin/main.dart';
import 'package:al_moiin/view_models/license_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'load_users.dart';
import 'package:al_moiin/widgets/change_ip_dialog.dart';

class AskFirst extends StatelessWidget {
  const AskFirst({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام الـ Size مرة واحدة لتوفير الأداء
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;

    return PopScope(
      canPop: false, // يمنع الرجوع للخلف تماماً كما فعلت سابقاً
      child: Scaffold(
        body: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHeader(width, height),
                _buildActionButtons(context, width, height),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // فصل الهيدر في دالة منفصلة لجعل الكود أنظف
  Widget _buildHeader(double width, double height) {
    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: Column(
        children: [
          Icon(
            Icons.settings_suggest_rounded,
            size: width * 0.15,
            color: Colors.white.withValues(alpha: 0.9),
          ),
          SizedBox(height: height * 0.04),
          Container(
            padding: EdgeInsets.all(width * 0.05),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Text(
              "هل تريد تغيير عنوان IP و Port أو المتابعة؟",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // أزرار التحكم
  Widget _buildActionButtons(
    BuildContext context,
    double width,
    double height,
  ) {
    return Column(
      spacing: 20,
      children: [
        _customButton(
          context: context,
          label: "متابعة",
          icon: Icons.arrow_forward,
          isPrimary: true,
          // داخل زر المتابعة في كود الـ ElevatedButton
          onPressed: () async {
            // 1. إظهار رسالة بسيطة أو مؤشر تحميل إذا أردت
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('جاري التحقق من الإعدادات...'),
                duration: Duration(seconds: 1),
              ),
            );

            // 2. استدعاء دالة الفحص (check) التي برمجناها سابقاً في الـ Provider
            // نفترض أن authProvider هو الـ ViewModel الخاص بك
            CheckResult isLicenseValid = await Provider.of<LicenseViewModel>(
              context,
              listen: false,
            ).checkActivationStatus();

            if (isLicenseValid == CheckResult.success) {
              // 3. إذا كان كل شيء تمام، ننتقل للشاشة التالية
              Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => const LoadUsers()),
              );
            } else {
              // 4. إذا فشل الفحص (مثلاً لا يوجد إنترنت أو الترخيص منتهي)
              // نفتح الـ Dialog الذي صممناه سابقاً
              Provider.of<LicenseViewModel>(
                context,
                listen: false,
              ).showSessionExpiredDialog(context, initialError: isLicenseValid);
            }
          },
          width: width,
        ),
        _customButton(
          context: context,
          label: "تغيير",
          icon: Icons.settings,
          isPrimary: false,
          onPressed: () => ChangeIPDialog.showChangeDialog(context),
          width: width,
        ),
        _customButton(
          context: context,
          label: "تسجيل الخروج",
          icon: Icons.logout,
          isPrimary: false,
          onPressed: () {
            var licenseViewModel = Provider.of<LicenseViewModel>(
              context,
              listen: false,
            );
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.all(20),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        size: 50,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'هل تريد حقاً فصل هذا الجهاز؟',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        // زر الإلغاء
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'إلغاء',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // زر التأكيد
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              // نستخدم الـ ViewModel هنا
                              bool isDeleted = await licenseViewModel
                                  .deleteLicense();
                              if (isDeleted) {
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          const MyHomePage(),
                                      transitionsBuilder:
                                          (_, anim, __, child) =>
                                              FadeTransition(
                                                opacity: anim,
                                                child: child,
                                              ),
                                    ),
                                  );
                                  // عرض التوست (Toastification)
                                  // تأكد من استدعاء التوست بعد غلق الـ Dialog
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Consumer<LicenseViewModel>(
                              builder: (context, vm, _) {
                                return vm.isLoadingDelete
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'تأكيد',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          width: width,
          isDelet: true,
        ),
      ],
    );
  }

  // زرك المخصص (Reusable Button)
  Widget _customButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isPrimary,
    bool isDelet = false,
    required VoidCallback onPressed,
    required double width,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? Theme.of(context).secondaryHeaderColor
            : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      child: SizedBox(
        width: 200,
        height: 30,
        child: Row(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDelet
                    ? Colors.red
                    : isPrimary
                    ? Colors.white
                    : Theme.of(context).secondaryHeaderColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Icon(
              icon,
              color: isDelet
                  ? Colors.red
                  : isPrimary
                  ? Colors.white
                  : Theme.of(context).secondaryHeaderColor,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
