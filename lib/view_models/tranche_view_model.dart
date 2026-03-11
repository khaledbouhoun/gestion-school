import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../models/class.dart';
import '../models/period.dart';
import '../models/student.dart';
import '../models/tranche.dart';
import 'auth_view_model.dart';
import 'package:al_moiin/mixins/quran.dart';

import 'package:http/http.dart' as http;

class TrancheViewModel extends ChangeNotifier {
  AuthViewModel? authViewModel;
  TrancheViewModel(this.authViewModel);

  Period? selectedPeriod;
  Class? selectedClass;

  List<Map> types = [
    {1: 'صعودا'},
    {2: 'نزولا'},
    {3: 'صعودا/نزولا'},
  ];

  int? statusCode;
  List<Tranche>? tranches;
  Tranche? selectedTranche;
  Tranche? tranchesbystudent;

  int? studentTrancheStatusCode;
  List<Student>? students = [];

  int? addStatusCode;
  Tranche? newTranche;

  int? modifyStatusCode;
  Tranche? modifiedTranche;

  int? deleteStatusCode;

  Future<void> getTranches() async {
    try {
      statusCode = 0;
      http.Response response = await http.post(
        Uri.parse(
          'http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Tranche',
        ),
        body: jsonEncode({
          'path': authViewModel!.selectedFolder?.DOSBDD,
          'cycle': selectedClass?.CLSCYC,
          'level': selectedClass?.CLSNIV,
          'class': selectedClass?.CLSNO,
          'speciality': selectedClass?.CLSSPC,
          'year': authViewModel!.selectedYear?.ANENO,
          'period': selectedPeriod?.PERNO,
        }),
      );
      statusCode = response.statusCode;
      print(
        'Get_Tranche: ${jsonEncode({'path': authViewModel!.selectedFolder?.DOSBDD, 'cycle': selectedClass?.CLSCYC, 'level': selectedClass?.CLSNIV, 'class': selectedClass?.CLSNO, 'speciality': selectedClass?.CLSSPC, 'year': authViewModel!.selectedYear?.ANENO, 'period': selectedPeriod?.PERNO})}',
      );
      print('Get_Tranche: ${response.statusCode}');
      print('Get_Tranche: ${response.body}');
      if (statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        tranches = Tranche.listFromJson(data['tranches']);
      }
      notifyListeners();
    } catch (err) {
      print(err);
      statusCode = 500;
      notifyListeners();
    }
  }

  Future<void> getTranchesbYStudent(String elv) async {
    try {
      statusCode = 0;
      http.Response response = await http.post(
        Uri.parse(
          'http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_TrancheByStudent',
        ),
        body: jsonEncode({
          'path': authViewModel!.selectedFolder?.DOSBDD,
          'cycle': selectedClass?.CLSCYC,
          'level': selectedClass?.CLSNIV,
          'class': selectedClass?.CLSNO,
          'speciality': selectedClass?.CLSSPC,
          'year': authViewModel!.selectedYear?.ANENO,
          'period': '01',
          'elv': elv,
        }),
      );

      statusCode = response.statusCode;

      print('Get_Tranche: ${response.statusCode}');
      print('Get_Tranche: ${response.body}');
      if (statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        tranchesbystudent = Tranche.listFromJson(data['tranches']).first;

        var nav = SurraAyyat();

        var result = nav.calcullate(
          tranchesbystudent!.TRCSOURAA!,
          tranchesbystudent!.TRCAYAA!,
          tranchesbystudent!.TRCSENS!,
        );
        newTranche?.TRCSENS = tranchesbystudent!.TRCSENS!;
        newTranche?.TRCSOURADE = result.surraa;
        newTranche?.TRCAYADE = result.aya;
        newTranche?.TRCSOURAA = result.surraa;
        newTranche?.TRCAYAA = result.aya;
      }
      notifyListeners();
    } catch (err) {
      print(err);
      statusCode = 500;
      notifyListeners();
    }
  }

  Future<void> getStudentsWithoutTranche() async {
    try {
      students = [];
      studentTrancheStatusCode = 0;
      http.Response response = await http.post(
        Uri.parse(
          'http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Student_Without_Tranche',
        ),
        body: jsonEncode({
          'path': authViewModel!.selectedFolder?.DOSBDD,
          'cycle': selectedClass?.CLSCYC,
          'level': selectedClass?.CLSNIV,
          'class': selectedClass?.CLSNO,
          'speciality': selectedClass?.CLSSPC,
          'year': authViewModel!.selectedYear?.ANENO,
          'period': selectedPeriod?.PERNO,
        }),
      );
      studentTrancheStatusCode = response.statusCode;
      print('Get_Student_Without_Tranche: ${response.statusCode}');
      print('Get_Student_Without_Tranche: ${response.body}');
      if (studentTrancheStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        students = Student.listFromJson(data['students']);
      }
      notifyListeners();
    } catch (err) {
      print(err);
      studentTrancheStatusCode = 500;
      notifyListeners();
    }
  }

  Future<void> addTranche() async {
    try {
      addStatusCode = 0;
      Map<String, dynamic> body = {
        'path': authViewModel!.selectedFolder?.DOSBDD,
        'year': newTranche?.TRCANE,
        'period': newTranche?.TRCPER,
        'cycle': newTranche?.TRCCYC,
        'level': newTranche?.TRCNIV,
        'class': newTranche?.TRCCLS,
        'speciality': newTranche?.TRCSPC,
        'student': newTranche?.TRCELV,
        'souraFrom': newTranche?.TRCSOURADE,
        'ayaFrom': newTranche?.TRCAYADE,
        'souraTo': newTranche?.TRCSOURAA,
        'ayaTo': newTranche?.TRCAYAA,
        'observation': newTranche?.TRCOBS,
        'sens': newTranche?.TRCSENS,
      };
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      http.Response response = await http.post(
        Uri.parse(
          'http://${authViewModel!.ip_address}:${authViewModel!.port}/New_Tranche',
        ),
        headers: headers,
        body: jsonEncode(body),
      );
      addStatusCode = response.statusCode;
      notifyListeners();
    } catch (err) {
      print(err);
      addStatusCode = 500;
      notifyListeners();
    }
  }

  Future<void> modifyTranche() async {
    try {
      modifyStatusCode = 0;
      Map<String, dynamic> body = {
        'path': authViewModel!.selectedFolder?.DOSBDD,
        'year': modifiedTranche?.TRCANE,
        'period': modifiedTranche?.TRCPER,
        'cycle': modifiedTranche?.TRCCYC,
        'level': modifiedTranche?.TRCNIV,
        'class': modifiedTranche?.TRCCLS,
        'speciality': modifiedTranche?.TRCSPC,
        'student': modifiedTranche?.TRCELV,
        'souraFrom': modifiedTranche?.TRCSOURADE,
        'ayaFrom': modifiedTranche?.TRCAYADE,
        'souraTo': modifiedTranche?.TRCSOURAA,
        'ayaTo': modifiedTranche?.TRCAYAA,
        'observation': modifiedTranche?.TRCOBS,
        'sens': modifiedTranche?.TRCSENS,
      };
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      http.Response response = await http.post(
        Uri.parse(
          'http://${authViewModel!.ip_address}:${authViewModel!.port}/Modify_Tranche',
        ),
        headers: headers,
        body: jsonEncode(body),
      );
      modifyStatusCode = response.statusCode;
      print('Modify_Tranche: ${response.statusCode}');
      print('Modify_Tranche: ${response.body}');
      if (modifyStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        print(data['message']);
        int hizeb = int.parse(data['hizeb'].toString());
        int thomon = int.parse(data['thomon'].toString());
        selectedTranche?.TRCSOURADE = modifiedTranche?.TRCSOURADE;
        selectedTranche?.TRCAYADE = modifiedTranche?.TRCAYADE;
        selectedTranche?.TRCSOURAA = modifiedTranche?.TRCSOURAA;
        selectedTranche?.TRCAYAA = modifiedTranche?.TRCAYAA;
        selectedTranche?.TRCSENS = modifiedTranche?.TRCSENS;
        selectedTranche?.TRCNBHIZEB = hizeb;
        selectedTranche?.TRCNBTHOMON = thomon;
        selectedTranche?.TRCOBS = modifiedTranche!.TRCOBS;
      }
      notifyListeners();
    } catch (err) {
      print(err);
      modifyStatusCode = 500;
      notifyListeners();
    }
  }

  Future<void> deleteTranche(Tranche deletedTranche) async {
    try {
      deleteStatusCode = 0;
      Map<String, dynamic> body = {
        'path': authViewModel!.selectedFolder?.DOSBDD,
        'year': deletedTranche.TRCANE,
        'period': deletedTranche.TRCPER,
        'cycle': deletedTranche.TRCCYC,
        'level': deletedTranche.TRCNIV,
        'class': deletedTranche.TRCCLS,
        'speciality': deletedTranche.TRCSPC,
        'student': deletedTranche.TRCELV,
      };
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      http.Response response = await http.post(
        Uri.parse(
          'http://${authViewModel!.ip_address}:${authViewModel!.port}/Delete_Tranche',
        ),
        headers: headers,
        body: jsonEncode(body),
      );
      print('Delete_Tranche: ${response.statusCode}');
      print('Delete_Tranche: ${response.body}');
      deleteStatusCode = response.statusCode;
      notifyListeners();
    } catch (err) {
      print(err);
      deleteStatusCode = 500;
      notifyListeners();
    }
  }
}

class SurraAyyat with Quran {
  int? surraa;
  String? surraNom;
  int? aya;
  String? ayaNom;

  SurraAyyat();

  List<Map<dynamic, dynamic>> get ayatOfSurra =>
      ayat.where((a) => a['AYASOURA'] == surraa).toList();

  SurraAyyat calcullate(int surra, int aya, int sens) {
    surraa = surra;
    int newSurra = surra;
    int newAya = aya;

    // find max surah number
    int firstSurra = 1; // assuming surat list has all 114 surahs
    int lastSurra = 114; // assuming surat list has all 114 surahs

    switch (sens) {
      // صعودا (next)
      case 1:
        var nextAya = ayatOfSurra.firstWhere(
          (a) => a['AYANO'] == aya + 1,
          orElse: () => {},
        );

        if (nextAya.isEmpty) {
          if (surra != firstSurra) {
            newSurra = surra - 1;
            newAya = 1;
          } else {
            // last ayah of last surah → stay there
            newSurra = surra;
            newAya = aya;
          }
        } else {
          newAya = nextAya['AYANO'];
        }
        break;

      // نزولا (previous)
      case 2:
      case 3:
        var nextAya = ayatOfSurra.firstWhere(
          (a) => a['AYANO'] == aya + 1,
          orElse: () => {},
        );

        if (nextAya.isEmpty) {
          if (surra != lastSurra) {
            newSurra = surra + 1;
            newAya = 1;
          } else {
            newSurra = surra;
            newAya = aya;
          }
        } else {
          newAya = nextAya['AYANO'];
        }
        break;
    }

    return SurraAyyat()
      ..surraa = newSurra
      ..aya = newAya;
  }
}
