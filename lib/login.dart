import 'dart:convert';
import 'package:al_moiin/models/school_year.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/widgets/change_ip_dialog.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'load_data.dart';
import 'models/folder.dart';
import 'models/user.dart';
import 'package:toastification/toastification.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    TextEditingController password = TextEditingController();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Ensures layout resizes when keyboard appears
        backgroundColor: Theme.of(context).primaryColor,
        body: Consumer<AuthViewModel>(
          builder: (context, provider, child) {
            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Positioned(
                  top: 0,
                  child: Image.asset('assets/login_background.jpg', height: height, width: width, fit: BoxFit.fill),
                ),
                Container(
                  width: width,
                  height: height,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width * 0.75,
                        height: height * 0.5,
                        padding: EdgeInsets.all(width * 0.05),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'اسم المستخدم',
                                  style: TextStyle(fontSize: width * 0.045, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: width * 0.6,
                                  height: width * 0.12,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Theme.of(context).secondaryHeaderColor),
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: DropdownButton<User>(
                                    value: provider.selectedUser,
                                    hint: provider.users!.isEmpty ? Text("لا يوجد أساتذة") : Text(provider.selectedUser!.USRLOGIN),
                                    underline: Container(),
                                    isExpanded: true,
                                    onChanged: (User? user) async {
                                      if (user != null) {
                                        provider.selectedUser = user;
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString('user', provider.selectedUser!.USRNO);
                                        provider.notifyListeners();
                                      }
                                    },
                                    items: provider.users?.map<DropdownMenuItem<User>>((user) {
                                      return DropdownMenuItem<User>(
                                        value: user,
                                        child: Container(
                                          padding: EdgeInsets.only(left: width * 0.02),
                                          width: width * 0.5,
                                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
                                          child: Text(
                                            user.USRLOGIN,
                                            style: TextStyle(fontSize: width * 0.04, color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'كلمة السر',
                                  style: TextStyle(fontSize: width * 0.045, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: width * 0.6,
                                  height: width * 0.12,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Theme.of(context).secondaryHeaderColor),
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: TextFormField(
                                    controller: password,
                                    keyboardType: TextInputType.text,
                                    obscureText: provider.hide,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: "أدخل كلمة السر",
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          provider.hide = !provider.hide;
                                          provider.notifyListeners();
                                        },
                                        icon: Icon(provider.hide ? Icons.visibility : Icons.visibility_off),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الملف',
                                  style: TextStyle(fontSize: width * 0.045, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: width * 0.6,
                                  height: width * 0.12,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Theme.of(context).secondaryHeaderColor),
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: DropdownButton<Folder>(
                                    value: provider.selectedFolder,
                                    underline: Container(),
                                    isExpanded: true,
                                    onChanged: (Folder? folder) {
                                      if (folder != null) {
                                        provider.selectedFolder = folder;
                                        provider.getSchoolYears();
                                        provider.notifyListeners();
                                      }
                                    },
                                    items: provider.folders?.map<DropdownMenuItem<Folder>>((folder) {
                                      return DropdownMenuItem<Folder>(
                                        value: folder,
                                        child: Container(
                                          padding: EdgeInsets.only(left: width * 0.02),
                                          width: width * 0.5,
                                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
                                          child: Text(
                                            folder.DOSNOM,
                                            style: TextStyle(fontSize: width * 0.04, color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'السنة الدراسية',
                                  style: TextStyle(fontSize: width * 0.045, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: width * 0.6,
                                  height: width * 0.12,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Theme.of(context).secondaryHeaderColor),
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: DropdownButton<SchoolYear>(
                                    value: provider.selectedYear,
                                    underline: Container(),
                                    isExpanded: true,
                                    onChanged: (SchoolYear? year) {
                                      provider.selectedYear = year;
                                      provider.notifyListeners();
                                    },
                                    items: provider.schoolYears?.map<DropdownMenuItem<SchoolYear>>((SchoolYear year) {
                                      return DropdownMenuItem<SchoolYear>(
                                        value: year,
                                        child: Container(
                                          padding: EdgeInsets.only(left: width * 0.02),
                                          width: width * 0.5,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                          ),
                                          child: Text(
                                            '${year.ANEFIN.round()} - ${year.ANEDEB.round()}',
                                            style: TextStyle(fontSize: width * 0.04, color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              style: ButtonStyle(padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
                              onPressed: () async {
                                if (password.text == '') {
                                  Toast(
                                    context: context,
                                    title: 'أدخل كلمة السر',
                                    style: ToastificationStyle.minimal,
                                    type: ToastificationType.warning,
                                  );
                                } else {
                                  List<int> bytes = utf8.encode(password.text);
                                  Digest convertedBytes = md5.convert(bytes);
                                  String hashed = convertedBytes.toString().toUpperCase();
                                  if (hashed == provider.selectedUser!.USRPASSW) {
                                    if (provider.selectedUser!.USRETAT == 1) {
                                      await provider.verifyStandard();
                                      if (provider.loginStatusCode == 200) {
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(context, MaterialPageRoute(builder: (builder) => const LoadData()));
                                      }
                                      if (provider.loginStatusCode == 404) {
                                        Toast(
                                          context: context,
                                          title: 'لا توجد صلاحيات لملف ${provider.selectedFolder!.DOSNOM}',
                                          style: ToastificationStyle.minimal,
                                          type: ToastificationType.warning,
                                        );
                                      }
                                      if (provider.loginStatusCode == 500) {
                                        Toast(
                                          context: context,
                                          title: 'تعذر الإتصال بالخادم',
                                          style: ToastificationStyle.minimal,
                                          type: ToastificationType.error,
                                        );
                                      }
                                    } else {
                                      Toast(
                                        context: context,
                                        title: 'حسابك معطل حاليا',
                                        style: ToastificationStyle.minimal,
                                        type: ToastificationType.error,
                                      );
                                    }
                                  } else {
                                    Toast(
                                      context: context,
                                      title: 'كلمة السر خاطئة',
                                      style: ToastificationStyle.minimal,
                                      type: ToastificationType.error,
                                    );
                                  }
                                }
                              },
                              child: Container(
                                width: width * 0.6,
                                height: width * 0.12,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: provider.loginStatusCode != 0
                                    ? Text(
                                        "تسجيل الدخول",
                                        style: TextStyle(fontSize: width * 0.05, color: Colors.white, fontWeight: FontWeight.bold),
                                      )
                                    : const CircularProgressIndicator(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: TextButton(
                          onPressed: () {
                            ChangeIPDialog.showChangeDialog(context);
                          },
                          child: Text(
                            " تغيير عنوان ip و port",
                            style: TextStyle(fontSize: width * 0.04, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
