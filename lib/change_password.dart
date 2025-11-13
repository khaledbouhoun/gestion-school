import 'dart:convert';

import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class ChangePassword extends StatelessWidget{
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmedPassword = TextEditingController();

  ChangePassword({super.key});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var authProvider = Provider.of<AuthViewModel>(context);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            title: Center(
              child: Text('تغيير كلمة السر', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.07),),
            ),
          ),
          body: Container(
            width: width,
            height: height,
            padding: EdgeInsets.all(width * 0.02),
            child: Column(
              children: [
                buildTextField(context, 'كلمة السر الحالية', currentPassword, TextInputType.text, 1),
                SizedBox(height: width * 0.03),

                buildTextField(context, 'كلمة السر الجديدة', newPassword, TextInputType.text, 2),
                SizedBox(height: width * 0.03),

                buildTextField(context, 'تأكيد كلمة السر', confirmedPassword, TextInputType.text, 3),
                SizedBox(height: width * 0.03),
                TextButton(
                    onPressed: () async {await changePassword(context);},
                    child:  Container(
                      width: width * 0.6,
                      height: width * 0.12,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: authProvider.changePasswordStatusCode != 0 ? Text("تأكيد", style: TextStyle(fontSize: width * 0.05,color: Colors.white, fontWeight: FontWeight.bold),) : const CircularProgressIndicator(color: Colors.white,),
                    ))
              ],
            ),
          ),
        )
    );
  }

  Widget buildTextField(BuildContext context, String label, TextEditingController controller, TextInputType inputType, int hiding) {
    final width = MediaQuery.of(context).size.width;
    var authProvider = Provider.of<AuthViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: width * 0.045,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        Container(
          width: width,
          height: width * 0.15,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: inputType,
            obscureText: hiding == 1 ? authProvider.currentPasswordHiding : hiding == 2 ? authProvider.newPasswordHiding : authProvider.conformPasswordHiding,
            decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                fillColor: Colors.white,
                filled: true,
                hintText: "أدخل $label",
                suffixIcon: hiding == 1 ? IconButton(
                    onPressed: () {
                      authProvider.currentPasswordHiding = !authProvider.currentPasswordHiding;
                      authProvider.notifyListeners();
                    }, icon: Icon(authProvider.currentPasswordHiding ? Icons.visibility : Icons.visibility_off)
                ) : hiding == 2 ? IconButton(
                    onPressed: () {
                      authProvider.newPasswordHiding = !authProvider.newPasswordHiding;
                      authProvider.notifyListeners();
                    }, icon: Icon(authProvider.newPasswordHiding ? Icons.visibility : Icons.visibility_off)
                ) : IconButton(
                    onPressed: () {
                      authProvider.conformPasswordHiding = !authProvider.conformPasswordHiding;
                      authProvider.notifyListeners();
                    }, icon: Icon(authProvider.conformPasswordHiding ? Icons.visibility : Icons.visibility_off)
                )
            ),
          ),
        ),
      ],
    );
  }

  Future<void> changePassword(BuildContext context) async {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    if(currentPassword.text == ''){
      Toast(context: context, title: 'أدخل كلمة السر الحالية', style: ToastificationStyle.minimal, type: ToastificationType.warning);
    }else{
      if(newPassword.text == ''){
        Toast(context: context, title: 'أدخل كلمة السر الجديدة', style: ToastificationStyle.minimal, type: ToastificationType.warning);
      }else{
        if(confirmedPassword.text == ''){
          Toast(context: context, title: 'أدخل كلمة السر المأكدة', style: ToastificationStyle.minimal, type: ToastificationType.warning);
        }else{
          List<int> bytes = utf8.encode(currentPassword.text);
          Digest convertedBytes = md5.convert(bytes);
          String current = convertedBytes.toString().toUpperCase();
          if(current != authProvider.selectedUser!.USRPASSW){
            Toast(context: context, title: 'كلمة السر الحالية غير صحيحة', style: ToastificationStyle.minimal, type: ToastificationType.warning);
          }else{
            if(newPassword.text != confirmedPassword.text){
              Toast(context: context, title: 'كلمة المرور المأكدة غير متطابقة', style: ToastificationStyle.minimal, type: ToastificationType.warning);
            }else{
              FocusScope.of(context).unfocus();
              List<int> bytes = utf8.encode(newPassword.text);
              Digest convertedBytes = md5.convert(bytes);
              String hashedNewPassword = convertedBytes.toString().toUpperCase();
              await authProvider.changePassword(hashedNewPassword);
              if(authProvider.changePasswordStatusCode == 200){
                Toast(context: context, title: 'تم التعديل بنجاح', style: ToastificationStyle.minimal, type: ToastificationType.success);
              }else{
                Toast(context: context, title: 'تعذر الإتصال بالخادم', style: ToastificationStyle.minimal, type: ToastificationType.error);
              }
            }
          }
        }
      }
    }
  }
}