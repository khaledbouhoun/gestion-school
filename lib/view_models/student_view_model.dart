import 'dart:convert';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/class.dart';
import '../models/period.dart';
import '../models/student.dart';

class StudentViewModel extends ChangeNotifier {
  AuthViewModel? authViewModel;
  StudentViewModel(this.authViewModel);

  int statusCode = 0;
  List<Student>? filtredStudent;

  Student? selectedStudent;

  Future<void> getStudents(Class selectedClass, Period selectedPeriod) async {
    try {
      filtredStudent = [];
      statusCode = 0;
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Student'),
        body: jsonEncode({
          'path': authViewModel?.selectedFolder?.DOSBDD,
          'year': authViewModel?.selectedYear?.ANENO,
          'cycle': selectedClass.CLSCYC,
          'level': selectedClass.CLSNIV,
          'class': selectedClass.CLSNO,
          'speciality': selectedClass.CLSSPC,
          'period': selectedPeriod.PERNO,
        }),
      );
      statusCode = response.statusCode;
      if (statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        print('data students: $data');
        filtredStudent = Student.listFromJson(data['students']);
      }
      notifyListeners();
    } catch (err) {
      print(err);
      statusCode = 500;
      notifyListeners();
    }
  }
}
