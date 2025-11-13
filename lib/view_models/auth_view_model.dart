import 'dart:convert';
import 'package:al_moiin/models/folder.dart';
import 'package:al_moiin/models/rubrique.dart';
import 'package:al_moiin/models/school_year.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/access.dart';
import '../models/user.dart';

class AuthViewModel extends ChangeNotifier {
  String ip_address = '192.168.1.65';
  String port = '5050';
  bool hide = true;

  User? selectedUser;
  List<User>? users;

  Folder? selectedFolder;
  List<Folder>? folders;

  SchoolYear? selectedYear;
  List<SchoolYear>? schoolYears;

  List<Access>? accessList;
  List<Rubrique>? rubriques;

  int? statusCode;
  int? yearStatusCode;
  int? loginStatusCode;

  bool currentPasswordHiding = false;
  bool newPasswordHiding = true;
  bool conformPasswordHiding = true;
  int? changePasswordStatusCode;

  Future<void> getUsersAndFolders() async {
    final url = Uri.parse('http://$ip_address:$port/getuserandfolder');
    print("Fetching users and folders from: $url");

    try {
      statusCode = 0;
      final response = await http.post(url);
      statusCode = response.statusCode;

      print("Response status: $statusCode");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        users = data['users'] != null ? User.listFromJson(data['users']) : [];
        folders = data['folders'] != null ? Folder.listFromJson(data['folders']) : [];

        await _restoreOrSetDefaultUser();
        _selectDefaultFolder();

        // Continue to load other data
        await getSchoolYears();
      } else {
        print("Failed to fetch users or folders: ${response.body}");
        users = [];
        folders = [];
      }
    } catch (error, stackTrace) {
      print("Error while fetching users/folders: $error");
      print(stackTrace);
      users = [];
      folders = [];
      statusCode = 500;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _restoreOrSetDefaultUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserNo = prefs.getString('user');

    if (users == null || users!.isEmpty) {
      selectedUser = null;
      return;
    }

    if (savedUserNo != null) {
      selectedUser = users!.firstWhere((u) => u.USRNO == savedUserNo, orElse: () => users!.first);
    } else {
      selectedUser = users!.first;
    }

    await prefs.setString('user', selectedUser!.USRNO);
  }

  void _selectDefaultFolder() {
    if (folders != null && folders!.isNotEmpty) {
      selectedFolder = folders!.first;
    } else {
      selectedFolder = null;
    }
  }

  Future<void> getSchoolYears() async {
    try {
      yearStatusCode = 0;
      // print("body: {'path': ${selectedFolder?.DOSBDD.replaceAll(r'\', r'\\')}}");
      http.Response response = await http.post(
        Uri.parse('http://$ip_address:$port/Get_School_Years'),
        body: jsonEncode({'path': selectedFolder?.DOSBDD}),
      );
      print("url: http://$ip_address:$port/Get_School_Years");
      print('body : ${jsonEncode({'System': selectedFolder?.DOSNOM})}');
      print('body : ${jsonEncode({'path': selectedFolder?.DOSBDD})}');
      print(response.body);
      print(response.statusCode);

      yearStatusCode = response.statusCode;

      print(response.body);
      print(response.statusCode);
      if (yearStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        schoolYears = SchoolYear.listFromJson(data['school years']);
        selectedYear = schoolYears?.first;
      }
      notifyListeners();
    } catch (err) {
      print(err);
      yearStatusCode = 500;
      notifyListeners();
    }
  }

  //verify standard user access to folder
  Future verifyStandard() async {
    try {
      loginStatusCode = 0;
      notifyListeners();
      http.Response response = await http.post(
        Uri.parse('http://$ip_address:$port/verify_standard?user=${selectedUser!.USRNO}&folder=${selectedFolder!.DOSNO}'),
      );

      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        accessList = Access.listFromJson(data['access']);
      } 
      loginStatusCode = response.statusCode;
      notifyListeners();
    } catch (err) {
      loginStatusCode = 500;
      notifyListeners();
    }
  }

  //verify standard user access to folder
  Future getRubriques() async {
    try {
      statusCode = 0;
      print('http://$ip_address:$port/get_rubriques?user=${selectedUser!.USRNO}&folder=${selectedFolder!.DOSNO}');
      http.Response response = await http.post(
        Uri.parse('http://$ip_address:$port/get_rubriques?user=${selectedUser!.USRNO}&folder=${selectedFolder!.DOSNO}'),
      );
      print("url: http://$ip_address:$port/get_rubriques?user=${selectedUser!.USRNO}&folder=${selectedFolder!.DOSNO}");
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        rubriques = Rubrique.listFromJson(data['rubriques']);
        print('Rubriques: ${rubriques?.length}');
      }
      statusCode = 200;
      notifyListeners();
    } catch (err) {
      statusCode = 500;
      notifyListeners();
    }
  }

  Future changePassword(String newPassword) async {
    try {
      changePasswordStatusCode = 0;
      notifyListeners();
      Map<String, dynamic> body = {'password': newPassword, 'user': selectedUser!.USRNO};
      http.Response response = await http.post(Uri.parse('http://$ip_address:$port/change_password'), body: body);
      changePasswordStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        selectedUser!.USRPASSW = newPassword;
      }
      notifyListeners();
    } catch (err) {
      changePasswordStatusCode = 500;
      notifyListeners();
    }
  }
}
