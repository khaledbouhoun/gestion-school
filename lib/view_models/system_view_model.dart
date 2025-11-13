import 'dart:convert';
import 'package:al_moiin/models/Etablissement.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/class.dart';
import '../models/period.dart';

class SystemViewModel extends ChangeNotifier {
  AuthViewModel? authViewModel;
  SystemViewModel(this.authViewModel);

  int? periodStatusCode;
  Period? selectedPeriod;
  List<Period>? periods;

  int? classStatusCode;
  Class? selectedClass;
  List<Class>? classes;

  int? etablissementStatusCode;
  Etablissement? selectedEtablissement;
  DateTime? dateOfDay;

  Future<void> getEtablissement() async {
    try {
      etablissementStatusCode = 0;
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Etablissement'),
        body: jsonEncode({'path': authViewModel?.selectedFolder?.DOSBDD}),
      );
      print("bdd: ${authViewModel?.selectedFolder?.DOSBDD}");
      etablissementStatusCode = response.statusCode;
      if (etablissementStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        selectedEtablissement = Etablissement.fromJson(data['etablissement'][0]);
        dateOfDay = DateTime.tryParse(data['day']);
      }
      notifyListeners();
    } catch (err) {
      print("Error getEtablissement: $err");
      etablissementStatusCode = 500;
      notifyListeners();
    }
  }

  Future<void> getPeriods() async {
    try {
      periodStatusCode = 0;
      print("body: {'path': ${authViewModel?.selectedFolder?.DOSBDD}, 'year': ${authViewModel?.selectedYear?.ANENO}}");
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Periods'),
        body: jsonEncode({'path': authViewModel?.selectedFolder?.DOSBDD, 'year': authViewModel?.selectedYear?.ANENO}),
      );
      periodStatusCode = response.statusCode;
      if (periodStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        periods = Period.listFromJson(data['periods']);
        selectedPeriod = periods?.firstWhere((element) => element.ANPCLOSE == 0);
      }
      notifyListeners();
    } catch (err) {
      print(err);
      periodStatusCode = 500;
      notifyListeners();
    }
  }

  Future<void> getClasses() async {
    try {
      List<Map<String, dynamic>> selectedClasses = [];
      authViewModel?.rubriques?.forEach((element) {
        if (element.USBTRB == '02' && element.USBANE == authViewModel!.selectedYear!.ANENO) {
          selectedClasses.add(element.toJson());
        }
      });

      Map<String, String> headers = {'Content-type': 'application/json', 'Accept': 'application/json'};
      Map<String, dynamic> body = {'path': authViewModel?.selectedFolder?.DOSBDD, 'classes': selectedClasses};
      // body  exemple: {'path': 'C:\\DATA\\SCHOOL1', 'classes': [{'USBUSR': 'admin', 'USBDOS': 'SCHOOL1', 'USBANE': '2023', 'USBCYC': '01', 'USBNIV': '01', 'USBSPC': '', 'USBCLS': '01A', 'USBTRB': '01', 'USBRUB': '001', 'USBETAT': 1.0}, {'USBUSR': 'admin', 'USBDOS': 'SCHOOL1', 'USBANE': '2023', 'USBCYC': '01', 'USBNIV': '01', 'USBSPC': '', 'USBCLS': '01B', 'USBTRB': '01', 'USBRUB': '001', 'USBETAT': 1.0}]}
      // body exemple on formate json : {'path': 'C:\\DATA\\SCHOOL1', 'classes': '[{"USBUSR":"admin","USBDOS":"SCHOOL1","USBANE":"2023","USBCYC":"01","USBNIV":"01","USBSPC":"","USBCLS":"01A","USBTRB":"01","USBRUB":"001","USBETAT":1.0},{"USBUSR":"admin","USBDOS":"SCHOOL1","USBANE":"2023","USBCYC":"01","USBNIV":"01","USBSPC":"","USBCLS":"01B","USBTRB":"01","USBRUB":"001","USBETAT":1.0}]'}
      classStatusCode = 0;
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Classes'),
        headers: headers,
        body: jsonEncode(body),
      );
      classStatusCode = response.statusCode;
      if (classStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        classes = Class.listFromJson(data['classes']);
        selectedClass = classes?.first;
      }
      notifyListeners();
    } catch (err) {
      print(err);
      classStatusCode = 500;
      notifyListeners();
    }
  }
}
