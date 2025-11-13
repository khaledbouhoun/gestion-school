import 'package:al_moiin/change_password.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/views/absence/absences.dart';
import 'package:al_moiin/views/discipline/disciplines.dart';
import 'package:al_moiin/views/note/notes.dart';
import 'package:al_moiin/views/profile.dart';
import 'package:al_moiin/views/student/students.dart';
import 'package:al_moiin/views/tranche/tranches.dart';
import 'package:al_moiin/widgets/home_button.dart';
import 'package:al_moiin/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    var systemProvider = Provider.of<SystemViewModel>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            elevation: 0,
            title: Text(
              'متابعة التلاميذ',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.05),
            ),
            actions: [
              PopupMenuButton(
                icon: Icon(Icons.settings, color: Colors.white, size: width * 0.07),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(Icons.lock, color: Theme.of(context).secondaryHeaderColor),
                        SizedBox(width: 8),
                        Text('تغيير كلمة المرور', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'تسجيل الخروج',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      authProvider.currentPasswordHiding = true;
                      authProvider.newPasswordHiding = true;
                      authProvider.conformPasswordHiding = true;
                      Navigator.push(context, MaterialPageRoute(builder: (builder) => ChangePassword()));
                    case 1:
                      LogOutDialog.showLogOutDialog(context);
                  }
                },
              ),
              SizedBox(width: 8),
            ],
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: width,
                    height: height * 0.2,
                    padding: EdgeInsets.all(width * 0.03),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: width * 0.06,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.school, color: Theme.of(context).secondaryHeaderColor, size: width * 0.06),
                            ),
                            SizedBox(width: width * 0.03),
                            Expanded(
                              child: Text(
                                '${systemProvider.selectedEtablissement?.ETBNOM}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: width * 0.05),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.white70, size: width * 0.045),
                            SizedBox(width: width * 0.02),
                            Text(
                              'السنة الدراسية: ${authProvider.selectedYear!.ANEDEB.round()} - ${authProvider.selectedYear!.ANEFIN.round()}',
                              style: TextStyle(color: Colors.white70, fontSize: width * 0.04),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.white70, size: width * 0.045),
                            SizedBox(width: width * 0.02),
                            Text(
                              'الأستاذ: ${authProvider.selectedUser?.USRPRENOM} ${authProvider.selectedUser?.USRNOM}',
                              style: TextStyle(color: Colors.white70, fontSize: width * 0.04),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: width * 0.06),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                    ),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: height * 0.02),
                            child: Text(
                              'خدمات المدرسة',
                              style: TextStyle(
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                          ),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            mainAxisSpacing: width * 0.04,
                            crossAxisSpacing: width * 0.04,
                            children: [
                              HomeButton(title: 'التلاميذ', direction: const Students(), imagePath: 'assets/icons/students.png'),
                              HomeButton(title: 'ملف الأستاذ', direction: const Profile(), imagePath: 'assets/icons/profile.png'),
                              HomeButton(title: 'الغيابات', direction: const Absences(), imagePath: 'assets/icons/absences.png'),
                              HomeButton(title: 'السلوكات', direction: const Disciplines(), imagePath: 'assets/icons/discipline.png'),
                              HomeButton(title: 'التحصيل القرآني', direction: const Tranches(), imagePath: 'assets/icons/quran.png'),
                              HomeButton(title: 'العلامات', direction: const Notes(), imagePath: 'assets/icons/notes.png'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
