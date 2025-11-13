import 'dart:convert';

import 'package:al_moiin/models/period.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/absence.dart';
import '../models/absence_type.dart';
import '../models/class.dart';

class AbsenceViewModel extends ChangeNotifier {
  AuthViewModel? authViewModel;
  SystemViewModel? systemViewModel;
  AbsenceViewModel(this.authViewModel, this.systemViewModel);

  List<AbsenceType> absenceTypes = [
    AbsenceType(TABNO: '01', TABNOM: 'غياب غير مبرر'),
    AbsenceType(TABNO: '02', TABNOM: 'غياب مبرر'),
    AbsenceType(TABNO: '03', TABNOM: 'تأخر'),
    AbsenceType(TABNO: '04', TABNOM: 'خروج'),
  ];

  DateTime start = DateTime.now();
  DateTime end = DateTime.now();

  int? statusCode;
  List<Absence>? absences;

  //for displaying
  Class? selectedClass;
  Period? selectedPeriod;

  int? addStatusCode;
  Absence? newAbsence = Absence();

  Absence? selectedAbsence = Absence();

  int? modifStatusCode;
  Absence? modifiedAbsence = Absence();

  int? deleteStatusCode;

  Future<void> getAbsences() async {
    try {
      statusCode = 0;
      http.Response response = await http.post(
        Uri.parse(
          // 'http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Absences?cycle=${selectedClass?.CLSCYC}&level=${selectedClass?.CLSNIV}&class=${selectedClass?.CLSNO}&speciality=${selectedClass?.CLSSPC}&year=${authViewModel!.selectedYear?.ANENO}&period=${selectedPeriod?.PERNO}&start=${DateFormat('yyyy-MM-dd').format(start)} 00:00&end=${DateFormat('yyyy-MM-dd').format(end)} 23:59',
          'http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Absences',
        ),
        body: jsonEncode({
          'path': authViewModel!.selectedFolder?.DOSBDD,
          'cycle': selectedClass?.CLSCYC,
          'level': selectedClass?.CLSNIV,
          'class': selectedClass?.CLSNO,
          'speciality': selectedClass?.CLSSPC,
          'year': authViewModel!.selectedYear?.ANENO,
          'period': selectedPeriod?.PERNO,
          'start': '${DateFormat('yyyy-MM-dd').format(start)} 00:00',
          'end': '${DateFormat('yyyy-MM-dd').format(end)} 23:59',
        }),
      );
  
      statusCode = response.statusCode;
      if (statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        absences = Absence.listFromJson(data['absences']);
      
      }
      notifyListeners();
    } catch (err) {
      print(err);
      statusCode = 500;
      notifyListeners();
    }
  }

  Future<void> addNewAbsence() async {
    try {
      addStatusCode = 0;
      notifyListeners();

      DateTime date = DateTime(
        newAbsence!.EABDATE!.year,
        newAbsence!.EABDATE!.month,
        newAbsence!.EABDATE!.day,
        DateTime.now().hour,
        DateTime.now().minute,
      );

      Map<String, dynamic> body = {
        'path': authViewModel!.selectedFolder?.DOSBDD,
        'eabelv': newAbsence?.EABELV,
        'eabane': newAbsence?.EABANE,
        'eabper': newAbsence?.EABPER,
        'eabdate': date.toIso8601String(),
        'eabtype': newAbsence?.EABTYPE,
        'eabduree': newAbsence?.EABDUREE,
        'eabjustif': newAbsence?.EABJUSTIF,
      };
      Map<String, String> headers = {'Content-type': 'application/json', 'Accept': 'application/json'};
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_New_Absences'),
        headers: headers,
        body: jsonEncode(body),
      );
      print(response.body);
      addStatusCode = response.statusCode;
      notifyListeners();
    } catch (err) {
      print(err);
      addStatusCode = 500;
      notifyListeners();
    }
  }

  Future<void> modifyAbsence() async {
    try {
      modifStatusCode = 0;
      notifyListeners();
      Map<String, dynamic> body = {
        'path': authViewModel!.selectedFolder?.DOSBDD,
        'eabelv': modifiedAbsence?.EABELV,
        'eabane': modifiedAbsence?.EABANE,
        'eabper': modifiedAbsence?.EABPER,
        'eabdate': modifiedAbsence?.EABDATE?.toIso8601String(),
        'eabtype': modifiedAbsence?.EABTYPE,
        'eabduree': modifiedAbsence?.EABDUREE,
        'eabjustif': modifiedAbsence?.EABJUSTIF,
      };
      Map<String, String> headers = {'Content-type': 'application/json', 'Accept': 'application/json'};
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Modify_Absences'),
        headers: headers,
        body: jsonEncode(body),
      );
      modifStatusCode = response.statusCode;
      if (modifStatusCode == 201) {
        selectedAbsence?.EABTYPE = modifiedAbsence!.EABTYPE;
        selectedAbsence?.EABDUREE = modifiedAbsence!.EABDUREE;
        selectedAbsence?.EABJUSTIF = modifiedAbsence!.EABJUSTIF;
      }
      notifyListeners();
    } catch (err) {
      print(err);
      modifStatusCode = 500;
      notifyListeners();
    }
  }

  Future<void> deleteAbsence(Absence deletedAbsence) async {
    try {
      deleteStatusCode = 0;
      notifyListeners();
      Map<String, dynamic> body = {
        'path': authViewModel!.selectedFolder?.DOSBDD,
        'eabelv': deletedAbsence.EABELV,
        'eabane': deletedAbsence.EABANE,
        'eabper': deletedAbsence.EABPER,
        'eabdate': deletedAbsence.EABDATE?.toIso8601String(),
      };
      Map<String, String> headers = {'Content-type': 'application/json', 'Accept': 'application/json'};
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Delete_Absences'),
        headers: headers,
        body: jsonEncode(body),
      );
      deleteStatusCode = response.statusCode;
      notifyListeners();
    } catch (err) {
      print(err);
      deleteStatusCode = 500;
      notifyListeners();
    }
  }
}
