import 'package:al_moiin/view_models/student_view_model.dart';
import 'package:al_moiin/views/student/student_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';

class StudentWidget extends StatelessWidget {
  Student student;
  StudentWidget({super.key, required this.student});
  @override
  Widget build(BuildContext context) {
    var studentProvider = Provider.of<StudentViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return TextButton(
      style: ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.zero), overlayColor: WidgetStateProperty.all(Colors.transparent)),
      onPressed: () {
        studentProvider.selectedStudent = student;
        Navigator.push(context, MaterialPageRoute(builder: (builder) => const StudentDetails()));
      },
      child: Container(
        width: width,
        height: height * 0.07,
        padding: EdgeInsets.all(width * 0.02),
        margin: EdgeInsets.only(top: width * 0.02),
        alignment: Alignment.centerRight,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          '${student.elvnom} ${student.elvprenom}',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: width * 0.045),
        ),
      ),
    );
  }
}
