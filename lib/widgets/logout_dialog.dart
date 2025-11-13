import 'package:al_moiin/load_users.dart';
import 'package:flutter/material.dart';

class LogOutDialog extends StatelessWidget{
  const LogOutDialog({super.key});

  static showLogOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const LogOutDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('تنبيه', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        content: const Text("هل تريد حقا الخروج من البرنامج ؟", style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          TextButton(
              style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
              onPressed: (){Navigator.pop(context);},
              child: Text('لا', style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold),)
          ),
          ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).secondaryHeaderColor),padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
              onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (builder) => LoadUsers()));},
              child: const Text('نعم', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
          ),
        ],
      ),
    );
  }

}
