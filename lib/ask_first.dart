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
            child: Stack(
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
    return Positioned(
      top: height * 0.1,
      left: 0,
      right: 0,
      child: Padding(
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
      ),
    );
  }

  // أزرار التحكم
  Widget _buildActionButtons(
    BuildContext context,
    double width,
    double height,
  ) {
    return Positioned(
      bottom: height * 0.15,
      left: width * 0.1,
      right: width * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                ).showSessionExpiredDialog(
                  context,
                  initialError: isLicenseValid,
                );
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
        ],
      ),
    );
  }

  // زرك المخصص (Reusable Button)
  Widget _customButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isPrimary,
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
      child: Row(
        children: [
          Icon(
            icon,
            color: isPrimary
                ? Colors.white
                : Theme.of(context).secondaryHeaderColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isPrimary
                  ? Colors.white
                  : Theme.of(context).secondaryHeaderColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
