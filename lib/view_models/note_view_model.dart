import 'dart:convert';
import 'package:al_moiin/models/evaluation.dart';
import 'package:al_moiin/models/group_observation.dart';
import 'package:al_moiin/models/modules_group.dart';
import 'package:al_moiin/models/student.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';
import '../models/class.dart';
import '../models/module.dart';
import '../models/note.dart';
import '../models/period.dart';
import 'package:intl/intl.dart';

class NoteViewModel extends ChangeNotifier {
  AuthViewModel? authViewModel;
  NoteViewModel(this.authViewModel);

  // List<FocusNode> focusNodes = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool statueButtonSave = false;
  Period? selectedPeriod;
  Class? selectedClass;

  int? moduleStatusCode;
  List<Module>? modules;
  Module? selectedModule;

  int? evaluationStatusCode;
  List<Evaluation>? evaluations;
  Evaluation? selectedEvaluation;

  int? noteStatusCode;
  List<Note>? notes;
  List<Note>? oldNotes;

  bool isLoadingbody = false;
  int? bodyStatuesCode = 0;
  int? studentEvaluationStatusCode;
  List<Student>? students = [];

  Note? newNote = Note();
  int? addNoteStatusCode;

  Note? modifiedNote = Note();
  int? modifyNoteStatusCode;

  int? deleteNoteStatusCode;

  int? modulesGroupStatusCode;
  List<ModulesGroup>? modulesGroups = [];
  ModulesGroup? selectedModulesGroup;

  int? studentGroupObservationStatusCode;
  //need just the student id
  String? selectedStudentForObservation;
  GroupObservation? selectedStudentGroupObservation = GroupObservation();
  int? modifyStudentGroupObservationStatusCode;

  Future<void> getModules() async {
    try {
      modules = [];
      List<String> selectedModules = [];

      ///get selected modules based on the selected class

      authViewModel?.rubriques?.forEach((element) {
        if (element.USBANE == selectedClass!.CLSANE &&
            element.USBCYC == selectedClass!.CLSCYC &&
            element.USBNIV == selectedClass!.CLSNIV &&
            element.USBCLS == selectedClass!.CLSNO &&
            element.USBSPC == selectedClass!.CLSSPC &&
            element.USBTRB == '02') {
          selectedModules.add(element.USBRUB);
        }
      });
      Map<String, String> headers = {'Content-type': 'application/json', 'Accept': 'application/json'};

      Map<String, dynamic> body = {'path': authViewModel?.selectedFolder?.DOSBDD, 'modules': selectedModules};
      moduleStatusCode = 0;
      noteStatusCode = 0;

      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Modules'),
        headers: headers,
        body: jsonEncode(body),
      );
      moduleStatusCode = response.statusCode;
      print('Get_Modules: ${response.statusCode}');
      print('Get_Modules: ${response.body}');

      if (moduleStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        modules = Module.listFromJson(data['modules']);
        selectedModule = modules?.first;
        getEvaluations();
      }
      if (moduleStatusCode == 404) {
        evaluations = [];
        notes = [];
        oldNotes = [];
        selectedModule = null;
        bodyStatuesCode = 404;
      } else {
        evaluationStatusCode = moduleStatusCode;
        noteStatusCode = moduleStatusCode;
      }
      notifyListeners();
    } catch (err) {
      print(err);
      moduleStatusCode = 500;
      evaluationStatusCode = 500;
      // noteStatusCode = 500;
      notifyListeners();
    }
  }

  Future<void> getEvaluations() async {
    try {
      evaluationStatusCode = 0;
      noteStatusCode = 0;

      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Evaluations'),
        body: jsonEncode({
          'path': authViewModel!.selectedFolder?.DOSBDD,
          'cycle': selectedClass?.CLSCYC,
          'level': selectedClass?.CLSNIV,
          'speciality': selectedClass?.CLSSPC,
          'year': authViewModel!.selectedYear?.ANENO,
          'module': selectedModule?.MATNO,
        }),
      );
      evaluationStatusCode = response.statusCode;

      if (evaluationStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        evaluations = Evaluation.listFromJson(data['evaluations']);
        selectedEvaluation = evaluations?.first;
        await getNotes();
      } else {
        noteStatusCode = evaluationStatusCode;
      }
      notifyListeners();
    } catch (err) {
      print(err);
      evaluationStatusCode = 500;
      noteStatusCode = 500;
      notifyListeners();
    }
  }

  Future<void> getNotes() async {
    try {
      bodyStatuesCode = 0;
      isLoadingbody = true;
      notifyListeners();
      notes = [];
      oldNotes = [];
      noteStatusCode = 0;
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Note'),
        body: jsonEncode({
          'path': authViewModel!.selectedFolder?.DOSBDD,
          'cycle': selectedClass?.CLSCYC,
          'level': selectedClass?.CLSNIV,
          'class': selectedClass?.CLSNO,
          'speciality': selectedClass?.CLSSPC,
          'year': authViewModel!.selectedYear?.ANENO,
          'period': selectedPeriod?.PERNO,
          'module': selectedModule?.MATNO,
          'evaluation': selectedEvaluation?.EVANO,
        }),
      );
      print(
        "data sent: ${jsonEncode({'path': authViewModel!.selectedFolder?.DOSBDD, 'cycle': selectedClass?.CLSCYC, 'level': selectedClass?.CLSNIV, 'class': selectedClass?.CLSNO, 'speciality': selectedClass?.CLSSPC, 'year': authViewModel!.selectedYear?.ANENO, 'period': selectedPeriod?.PERNO, 'module': selectedModule?.MATNO, 'evaluation': selectedEvaluation?.EVANO})}",
      );
      noteStatusCode = response.statusCode;
      print('Get_Notes: ${response.statusCode}');
      print('Get_Notes: ${response.body}');
      if (noteStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        notes = Note.listFromJson(data['notes']);
        oldNotes = Note.listFromJson(data['notes']);
        await getStudentsWithoutEvaluation();
        bodyStatuesCode = response.statusCode;
      } else {
        await getStudentsWithoutEvaluation();
      }
      notifyListeners();
    } catch (err) {
      print(err);
      noteStatusCode = 500;
      notifyListeners();
    }
  }

  Future<void> resetNotes() async {
    notes = [];
    oldNotes = [];
    notifyListeners();
  }

  Future<void> getStudentsWithoutEvaluation() async {
    try {
      students = [];
      studentEvaluationStatusCode = 0;
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Student_Without_Evaluation'),
        body: jsonEncode({
          'path': authViewModel!.selectedFolder?.DOSBDD,
          'cycle': selectedClass?.CLSCYC,
          'level': selectedClass?.CLSNIV,
          'class': selectedClass?.CLSNO,
          'speciality': selectedClass?.CLSSPC,
          'year': authViewModel!.selectedYear?.ANENO,
          'period': selectedPeriod?.PERNO,
          'module': selectedModule?.MATNO,
          'evaluation': selectedEvaluation?.EVANO,
        }),
      );
      print("url sent: http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Student_Without_Evaluation");
      print(
        "ata sent: ${jsonEncode({'path': authViewModel!.selectedFolder?.DOSBDD, 'cycle': selectedClass?.CLSCYC, 'level': selectedClass?.CLSNIV, 'class': selectedClass?.CLSNO, 'speciality': selectedClass?.CLSSPC, 'year': authViewModel!.selectedYear?.ANENO, 'period': selectedPeriod?.PERNO, 'module': selectedModule?.MATNO, 'evaluation': selectedEvaluation?.EVANO})}",
      );
      print('Get_Student_Without_Evaluation: ${response.statusCode}');
      print('Get_Student_Without_Evaluation: ${response.body}');
      studentEvaluationStatusCode = response.statusCode;
      if (studentEvaluationStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        students = Student.listFromJson(data['students']);
        print('Students without evaluation: ${students?.length}');
        print('notes before adding new: ${notes?.length}');
        if (students != null && students!.isNotEmpty) {
          for (var student in students!) {
            notes!.add(
              Note(
                NOTVALEUR: null,
                NOTELV: student.elvno,
                ELVNOM: student.elvnom!,
                ELVPRENOM: student.elvprenom!,
                NOTANE: selectedClass!.CLSANE,
                NOTPER: selectedPeriod!.PERNO,
                NOTCYC: selectedClass!.CLSCYC,
                NOTNIV: selectedClass!.CLSNIV,
                NOTCLS: selectedClass!.CLSNO,
                NOTSPC: selectedClass!.CLSSPC,
                NOTMAT: selectedModule!.MATNO,
                NOTEVA: selectedEvaluation!.EVANO,
                SEMOBSERV: '',
              ),
            );
            print('--: ${student.elvnom} ${student.elvprenom}');
          }
          

          print('notes after adding new: ${notes?.length}');
        }
      }
      bodyStatuesCode = response.statusCode;
      notifyListeners();
    } catch (err) {
      print(err);
      studentEvaluationStatusCode = 500;
      notifyListeners();
    }
  }

  List<Note> newnotelist() {
    final maxValue = selectedClass?.ANVMOYSUR ?? 0;

    List<Note> newnotes = [];
    if (notes != null && oldNotes != null) {
      for (var note in notes!.where((n) => !oldNotes!.contains(n) && n.NOTVALEUR != null && n.NOTVALEUR! <= maxValue)) {
        newnotes.add(note);
      }
    }
    return newnotes;
  }

  List<Note> updateNotelist() {
    final maxValue = selectedClass?.ANVMOYSUR ?? 0;

    List<Note> updatenotes = [];
    if (notes != null && oldNotes != null) {
      for (var note in notes!.where(
        (n) =>
            oldNotes!.contains(n) &&
            (n.NOTVALEUR != oldNotes!.firstWhere((old) => old == n).NOTVALEUR ||
                n.SEMOBSERV != oldNotes!.firstWhere((old) => old == n).SEMOBSERV) &&
            n.NOTVALEUR != null &&
            n.NOTVALEUR! <= maxValue,
      )) {
        updatenotes.add(note);
      }
    }
    return updatenotes;
  }

  void statueButtonSaveFunction() {
    print('new notes count: ${newnotelist().length}');
    print('updated notes count: ${updateNotelist().length}');

    if ((newnotelist().isNotEmpty || updateNotelist().isNotEmpty)) {
      statueButtonSave = true;
      notifyListeners();
    } else {
      statueButtonSave = false;
      notifyListeners();
    }
  }

  bool isLoadingStatusButton = false;
  Future<void> saveAllChanges(BuildContext context) async {
    isLoadingStatusButton = true;
    notifyListeners();

    List<Note> newnotes = newnotelist();
    List<Note> updatenotes = updateNotelist();
    print('new notes count: ${newnotes.length}');
    print('updated notes count: ${updatenotes.length}');
    int addNoteCount = 0;
    int updateNoteCount = 0;
    for (var note in newnotes) {
      var addNoteStatusCode = await addNotes(note);
      if (addNoteStatusCode == 201) {
        addNoteCount++;
      }
    }

    for (var note in updatenotes) {
      var modifyNoteStatusCode = await modifyNote(note);
      if (modifyNoteStatusCode == 200) {
        updateNoteCount++;
      }
    }
    // Show a toast message with the add
    if (addNoteCount > 0) {
      Toast(
        context: context,
        title: 'تمت إضافة $addNoteCount ملاحظة',
        duration: 5,
        style: ToastificationStyle.flatColored,
        type: ToastificationType.success,
      );
    }
    // Show a toast message with the update
    if (updateNoteCount > 0) {
      Toast(
        context: context,
        title: 'تم تعديل $updateNoteCount ملاحظة',
        duration: 4,
        style: ToastificationStyle.flatColored,
        type: ToastificationType.info,
      );
    }

    if (newnotes.isNotEmpty || updatenotes.isNotEmpty) {
      isLoadingStatusButton = false;
      statueButtonSave = false;
      notes = [];
      oldNotes = [];
      await getNotes();
      notifyListeners();
    }
  }

  Future<int> addNotes(Note note) async {
    try {
      addNoteStatusCode = 0;
      notifyListeners();

      Map<String, dynamic> body = {
        'path': authViewModel!.selectedFolder?.DOSBDD,
        'student': note.NOTELV,
        'year': note.NOTANE,
        'period': note.NOTPER,
        'cycle': note.NOTCYC,
        'level': note.NOTNIV,
        'class': note.NOTCLS,
        'speciality': note.NOTSPC,
        'module': note.NOTMAT,
        'evaluation': note.NOTEVA,
        'value': note.NOTVALEUR.toString(),
        'observation': note.SEMOBSERV,
      };
      Map<String, String> headers = {'Content-type': 'application/json', 'Accept': 'application/json'};
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/New_Note'),
        headers: headers,
        body: jsonEncode(body),
      );
      print('New_Note ${note.NOTELV}: ${response.statusCode}');
      print('New_Note ${note.NOTELV}: ${response.body}');
      addNoteStatusCode = response.statusCode;
      notifyListeners();
      return response.statusCode;
    } catch (err) {
      print(err);
      addNoteStatusCode = 500;
      notifyListeners();
      return 500;
    }
  }
  // Future<void> addNote() async {
  //   try {
  //     addNoteStatusCode = 0;
  //     notifyListeners();
  //     Map<String, dynamic> body = {
  //       'path': authViewModel!.selectedFolder?.DOSBDD,
  //       'student': newNote?.NOTELV,
  //       'year': newNote?.NOTANE,
  //       'period': newNote?.NOTPER,
  //       'cycle': newNote?.NOTCYC,
  //       'level': newNote?.NOTNIV,
  //       'class': newNote?.NOTCLS,
  //       'speciality': newNote?.NOTSPC,
  //       'module': newNote?.NOTMAT,
  //       'evaluation': newNote?.NOTEVA,
  //       'value': newNote?.NOTVALEUR,
  //       'observation': newNote?.SEMOBSERV,
  //     };
  //     Map<String, String> headers = {'Content-type': 'application/json', 'Accept': 'application/json'};
  //     http.Response response = await http.post(
  //       Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/New_Note'),
  //       headers: headers,
  //       body: jsonEncode(body),
  //     );

  //     addNoteStatusCode = response.statusCode;
  //     notifyListeners();
  //   } catch (err) {
  //     print(err);
  //     addNoteStatusCode = 500;
  //     notifyListeners();
  //   }
  // }

  Future<int> modifyNote(Note note) async {
    try {
      modifyNoteStatusCode = 0;
      notifyListeners();
      Map<String, dynamic> body = {
        'path': authViewModel!.selectedFolder?.DOSBDD,
        'student': note.NOTELV,
        'year': note.NOTANE,
        'period': note.NOTPER,
        'cycle': note.NOTCYC,
        'level': note.NOTNIV,
        'class': note.NOTCLS,
        'speciality': note.NOTSPC,
        'module': note.NOTMAT,
        'evaluation': note.NOTEVA,
        'value': note.NOTVALEUR,
        'observation': note.SEMOBSERV,
      };
      Map<String, String> headers = {'Content-type': 'application/json', 'Accept': 'application/json'};
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Modify_Note'),
        headers: headers,
        body: jsonEncode(body),
      );
      print('Modify_Note ${note.NOTELV}: ${response.statusCode}');
      print('Modify_Note ${note.NOTELV}: ${response.body}');
      modifyNoteStatusCode = response.statusCode;
      notifyListeners();
      return response.statusCode;
    } catch (err) {
      print(err);
      modifyNoteStatusCode = 500;
      notifyListeners();
      return 500;
    }
  }
  // Future<void> modifyNote() async {
  //   try {
  //     modifyNoteStatusCode = 0;
  //     notifyListeners();
  //     Map<String, dynamic> body = {
  //       'path': authViewModel!.selectedFolder?.DOSBDD,
  //       'student': modifiedNote?.NOTELV,
  //       'year': modifiedNote?.NOTANE,
  //       'period': modifiedNote?.NOTPER,
  //       'cycle': modifiedNote?.NOTCYC,
  //       'level': modifiedNote?.NOTNIV,
  //       'class': modifiedNote?.NOTCLS,
  //       'speciality': modifiedNote?.NOTSPC,
  //       'module': modifiedNote?.NOTMAT,
  //       'evaluation': modifiedNote?.NOTEVA,
  //       'value': modifiedNote?.NOTVALEUR,
  //       'observation': modifiedNote?.SEMOBSERV,
  //     };
  //     Map<String, String> headers = {'Content-type': 'application/json', 'Accept': 'application/json'};
  //     http.Response response = await http.post(
  //       Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Modify_Note'),
  //       headers: headers,
  //       body: jsonEncode(body),
  //     );
  //     modifyNoteStatusCode = response.statusCode;
  //     notifyListeners();
  //   } catch (err) {
  //     print(err);
  //     modifyNoteStatusCode = 500;
  //     notifyListeners();
  //   }
  // }

  Future<void> deleteNote(Note deletedNote) async {
    try {
      deleteNoteStatusCode = 0;
      notifyListeners();
      Map<String, dynamic> body = {
        'path': authViewModel!.selectedFolder?.DOSBDD,
        'student': deletedNote.NOTELV,
        'year': deletedNote.NOTANE,
        'period': deletedNote.NOTPER,
        'cycle': deletedNote.NOTCYC,
        'level': deletedNote.NOTNIV,
        'class': deletedNote.NOTCLS,
        'speciality': deletedNote.NOTSPC,
        'module': deletedNote.NOTMAT,
        'evaluation': deletedNote.NOTEVA,
        'value': deletedNote.NOTVALEUR,
        'observation': deletedNote.SEMOBSERV,
      };
      Map<String, String> headers = {'Content-type': 'application/json', 'Accept': 'application/json'};
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Delete_Note'),
        headers: headers,
        body: jsonEncode(body),
      );

      deleteNoteStatusCode = response.statusCode;
      notifyListeners();
    } catch (err) {
      print(err);
      deleteNoteStatusCode = 500;
      notifyListeners();
    }
  }

  Future<void> initFunction() async {
    isLoadingbody = false;
    isLoadingStatusButton = false;
    statueButtonSave = false;

    /// مبدئياً نفضي البيانات
    modules = [];
    modulesGroups = [];
    evaluations = [];
    notes = [];
    oldNotes = [];

    await getModulesGroups().then((value) async => await getModules());
    // await getModules();
  }

  Future<void> getModulesGroups() async {
    try {
      modulesGroupStatusCode = 0;
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Modules_Group'),
        body: jsonEncode({
          'path': authViewModel!.selectedFolder?.DOSBDD,
          'cycle': selectedClass?.CLSCYC,
          'level': selectedClass?.CLSNIV,
          'speciality': selectedClass?.CLSSPC,
          'year': authViewModel!.selectedYear?.ANENO,
        }),
      );
      modulesGroupStatusCode = response.statusCode;
      print('Get_Modules_Group: ${response.statusCode}');
      print('Get_Modules_Group: ${response.body}');

      if (modulesGroupStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        modulesGroups = ModulesGroup.listFromJson(data['groups']);
        selectedModulesGroup = modulesGroups?.first;
      }
      notifyListeners();
    } catch (err) {
      print(err);
      modulesGroupStatusCode = 500;
      notifyListeners();
    }
  }

  Future<void> getStudentGroupObservation() async {
    try {
      studentGroupObservationStatusCode = 0;
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Get_Student_Group_Observation'),
        body: jsonEncode({
          'path': authViewModel!.selectedFolder?.DOSBDD,
          'student': selectedStudentForObservation,
          'cycle': selectedClass?.CLSCYC,
          'level': selectedClass?.CLSNIV,
          'class': selectedClass?.CLSNO,
          'speciality': selectedClass?.CLSSPC,
          'year': authViewModel!.selectedYear?.ANENO,
          'period': selectedPeriod?.PERNO,
          'group': selectedModulesGroup?.GRPNO,
        }),
      );
      studentGroupObservationStatusCode = response.statusCode;

      if (studentGroupObservationStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        selectedStudentGroupObservation = GroupObservation.fromJson(data['observation'][0]);
      }
      if (studentGroupObservationStatusCode == 404) {
        selectedStudentGroupObservation = GroupObservation(
          SEGELV: selectedStudentForObservation!,
          SEGANE: selectedClass!.CLSANE,
          SEGPER: selectedPeriod!.PERNO,
          SEGCYC: selectedClass!.CLSCYC,
          SEGNIV: selectedClass!.CLSNIV,
          SEGCLS: selectedClass!.CLSNO,
          SEGSPC: selectedClass!.CLSSPC,
          SEGGRP: selectedModulesGroup!.GRPNO,
        );
      }
      notifyListeners();
    } catch (err) {
      print(err);
      studentGroupObservationStatusCode = 500;
      notifyListeners();
    }
  }

  Future<void> modifyStudentGroupObservation() async {
    try {
      modifyStudentGroupObservationStatusCode = 0;
      notifyListeners();
      Map<String, dynamic> body = {
        'path': authViewModel!.selectedFolder?.DOSBDD,
        'student': selectedStudentGroupObservation?.SEGELV,
        'year': selectedStudentGroupObservation?.SEGANE,
        'period': selectedStudentGroupObservation?.SEGPER,
        'cycle': selectedStudentGroupObservation?.SEGCYC,
        'level': selectedStudentGroupObservation?.SEGNIV,
        'class': selectedStudentGroupObservation?.SEGCLS,
        'speciality': selectedStudentGroupObservation?.SEGSPC,
        'group': selectedStudentGroupObservation?.SEGGRP,
        'observation': selectedStudentGroupObservation?.SEGOBSERV,
      };
      Map<String, String> headers = {'Content-type': 'application/json', 'Accept': 'application/json'};
      http.Response response = await http.post(
        Uri.parse('http://${authViewModel!.ip_address}:${authViewModel!.port}/Modify_Student_Group_Observation'),
        headers: headers,
        body: jsonEncode(body),
      );
      print('Modify_Student_Group_Observation: ${response.statusCode}');
      print('Modify_Student_Group_Observation: ${response.body}');

      modifyStudentGroupObservationStatusCode = response.statusCode;
      notifyListeners();
    } catch (err) {
      print(err);
      modifyStudentGroupObservationStatusCode = 500;
      notifyListeners();
    }
  }
}
