import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Toast{
  String? title;
  ToastificationStyle? style;
  ToastificationType? type;
  int? duration;
  BuildContext? context;
  Toast({required this.title, required this.style, required this.type, this.context, this.duration = 2}){
    toastification.show(
        autoCloseDuration: Duration(seconds: duration!),
        context: context,
        title: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(title!, style: const TextStyle(fontWeight: FontWeight.bold),)
        ),
        style: style,
        type: type,
        showProgressBar: false
    );
  }
}