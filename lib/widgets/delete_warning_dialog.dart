import 'package:flutter/material.dart';

class DeleteWarningDialog extends StatelessWidget{
  DeleteWarningDialog({super.key, required this.function});

  VoidCallback function;
  static showDeleteWarningDialog(BuildContext context, VoidCallback function) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteWarningDialog(function: function,);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('تنبيه', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        content: const Text("هل تريد الحذف ؟", style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          TextButton(
              style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
              onPressed: (){Navigator.pop(context);},
              child: Text('لا', style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold),)
          ),
          ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red),padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
              onPressed: (){
                function();
              },
              child: const Text('نعم', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
          ),
        ],
      ),
    );
  }

}
