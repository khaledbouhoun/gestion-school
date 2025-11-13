import 'dart:convert';
import 'package:al_moiin/models/discipline.dart';
import 'package:al_moiin/models/period.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/class.dart';
import '../models/discipline_type.dart';

class DisciplineViewModel extends ChangeNotifier {
  AuthViewModel? authViewModel;
  DisciplineViewModel(this.authViewModel);

  Period? selectedPeriod;
  Class? selectedClass;

  List<String> types = ['كل الأنواع', 'إجازة', 'مخالفة'];
  String selectedType = 'كل الأنواع';
  String selectedAddType = 'كل الأنواع';
  String selectedModifyType = 'كل الأنواع';

  int? disciplineTypesStatusCode;
  List<DisciplineType>? disciplinesTypes;
  DisciplineType? selectedDisciplineType;

  List<DisciplineType>? addDisciplinesTypes;
  DisciplineType? selectedAddDisciplineType;

  List<DisciplineType>? modifyDisciplinesTypes;
  DisciplineType? selectedModifyDisciplineType;

  int? statusCode;
  List<Discipline>? disciplines;
  Discipline? selectedDiscipline;

  int? addStatusCode;
  Discipline? newDiscipline;
  Class? selectedAddClass;

  int? modifyStatusCode;
  Discipline? modifiedDiscipline;

  int? deleteStatusCode;

  //['كل الأنواع','إجازة', 'مخالفة'] selectedType, selectedAddType, selectedModifyType: for select the section of disciplines types
  //'كل الأنواع، اجازة ..'  selectedDisciplineType that belong to selectedType section and we add for each section of type a general one like
  //finally the type in parameter of getDisciplineTypes() is specify which one of these 'display, add or modify disciplines' its selectedType and selectedDisciplineType will be changed

  Future<void> getDisciplineTypes({int type = 0, required String selectedType}) async {
    try {
      disciplineTypesStatusCode = 0;
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Type_Disciplines'),
        body: jsonEncode({'path': authViewModel!.selectedFolder?.DOSBDD, 'type': selectedType}),
      );
      disciplineTypesStatusCode = response.statusCode;
      if (disciplineTypesStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        if (type == 0) {
          disciplinesTypes = DisciplineType.listFromJson(data['discipline_types']);
          switch (selectedType) {
            case 'كل الأنواع':
              disciplinesTypes?.insert(0, DisciplineType(DECNO: '-1', DECNOM: 'كل الإجازات/المخالفات'));
              break;
            case 'إجازة':
              disciplinesTypes?.insert(0, DisciplineType(DECNO: '-2', DECNOM: 'كل السلوكات'));
              break;
            case 'مخالفة':
              disciplinesTypes?.insert(0, DisciplineType(DECNO: '-3', DECNOM: 'كل السلوكات'));
              break;
          }
          selectedDisciplineType = disciplinesTypes?.first;
          getDisciplines();
        } else if (type == 1) {
          addDisciplinesTypes = DisciplineType.listFromJson(data['discipline_types']);
          newDiscipline?.DEVDEC = addDisciplinesTypes?.first.DECNO;
        } else {
          modifyDisciplinesTypes = DisciplineType.listFromJson(data['discipline_types']);
          modifiedDiscipline?.DEVDEC = modifyDisciplinesTypes?.first.DECNO;
        }
      } else {
        statusCode = disciplineTypesStatusCode;
      }
      notifyListeners();
    } catch (err) {
      print(err);
      disciplineTypesStatusCode = 500;
      statusCode = 500;
      notifyListeners();
    }
  }

  Future<void> getDisciplines() async {
    try {
      statusCode = 0;
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Disciplines'),
        body: jsonEncode({
          'path': authViewModel!.selectedFolder?.DOSBDD,
          'cycle': selectedClass?.CLSCYC,
          'level': selectedClass?.CLSNIV,
          'class': selectedClass?.CLSNO,
          'speciality': selectedClass?.CLSSPC,
          'year': authViewModel!.selectedYear?.ANENO,
          'period': selectedPeriod?.PERNO,
          'discipline': selectedDisciplineType?.DECNO,
        }),
      );
      statusCode = response.statusCode;
      if (statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        disciplines = Discipline.listFromJson(data['disciplines']);
        print(data['disciplines']);
        print(disciplines![0].toJson());
      }
      notifyListeners();
    } catch (err) {
      print(err);
      statusCode = 500;
      notifyListeners();
    }
  }

  Future<void> addDiscipline() async {
    try {
      addStatusCode = 0;
      notifyListeners();
      Map<String, dynamic> body = {
        'path': authViewModel!.selectedFolder?.DOSBDD,
        'student': newDiscipline?.DEVELV,
        'year': newDiscipline?.DEVANE,
        'period': newDiscipline?.DEVPER,
        'date':
            '${DateFormat('yyyy-MM-dd').format(newDiscipline!.DEVDATE)} ${newDiscipline?.DEVDATE.hour.toString().padLeft(2, '0')}:${newDiscipline?.DEVDATE.minute.toString().padLeft(2, '0')}',
        'discipline': newDiscipline?.DEVDEC,
        'observation': newDiscipline?.DEVOBSERV,
      };
      Map<String, String> headers = {'Content-type': 'application/json', 'Accept': 'application/json'};
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_New_Disciplines'),
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

  Future<void> modifyDiscipline(String oldDiscipiline) async {
    try {
      modifyStatusCode = 0;
      notifyListeners();
      Map<String, dynamic> body = {
        'path': authViewModel!.selectedFolder?.DOSBDD,
        'student': modifiedDiscipline?.DEVELV,
        'year': modifiedDiscipline?.DEVANE,
        'period': modifiedDiscipline?.DEVPER,
        'date':
            '${DateFormat('yyyy-MM-dd').format(modifiedDiscipline!.DEVDATE)} ${modifiedDiscipline?.DEVDATE.hour.toString().padLeft(2, '0')}:${modifiedDiscipline?.DEVDATE.minute.toString().padLeft(2, '0')}',
        'discipline': modifiedDiscipline?.DEVDEC,
        'observation': modifiedDiscipline?.DEVOBSERV,
        'old_discipline': oldDiscipiline,
      };
      Map<String, String> headers = {'Content-type': 'application/json', 'Accept': 'application/json'};
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Modify_Disciplines'),
        headers: headers,
        body: jsonEncode(body),
      );
      modifyStatusCode = response.statusCode;
      notifyListeners();
    } catch (err) {
      print(err);
      modifyStatusCode = 500;
      notifyListeners();
    }
  }

  Future<void> deleteDiscipline(Discipline deletedDiscipline) async {
    try {
      deleteStatusCode = 0;
      Map<String, dynamic> body = {
        'path': authViewModel!.selectedFolder?.DOSBDD,
        'student': deletedDiscipline.DEVELV,
        'year': deletedDiscipline.DEVANE,
        'period': deletedDiscipline.DEVPER,
        'date':
            '${DateFormat('yyyy-MM-dd').format(deletedDiscipline.DEVDATE)} ${deletedDiscipline.DEVDATE.hour.toString().padLeft(2, '0')}:${deletedDiscipline.DEVDATE.minute.toString().padLeft(2, '0')}',
        'discipline': deletedDiscipline.DEVDEC,
      };
      Map<String, String> headers = {'Content-type': 'application/json', 'Accept': 'application/json'};
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Delete_Disciplines'),
        headers: headers,
        body: jsonEncode(body),
      );
      print(response.body);
      deleteStatusCode = response.statusCode;
      notifyListeners();
    } catch (err) {
      print(err);
      deleteStatusCode = 500;
      notifyListeners();
    }
  }
}
