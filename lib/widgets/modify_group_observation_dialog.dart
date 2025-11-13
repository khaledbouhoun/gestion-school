import 'package:al_moiin/models/modules_group.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/view_models/note_view_model.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class ModifyGroupObservationDialog extends StatefulWidget{
  const ModifyGroupObservationDialog({super.key});
  @override
  State<StatefulWidget> createState() => ModifyGroupObservationDialogPage();

  static showModifyDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ModifyGroupObservationDialog();
        });
  }
}

class ModifyGroupObservationDialogPage extends State<ModifyGroupObservationDialog>{

  TextEditingController observation = TextEditingController();

  @override
  void initState() {
    var noteProvider = Provider.of<NoteViewModel>(context, listen: false);
    observation.text = noteProvider.selectedStudentGroupObservation!.SEGOBSERV;
    super.initState();
  }

  @override
  void dispose() {
    observation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer<NoteViewModel>(
          builder: (context, noteProvider, child){
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                child: Container(
                  width: width * 0.6,
                  child: Column(
                    children: [
                      Center(child: Text('تغيير الملاحظة العامة', style: TextStyle(fontSize: width * 0.055, fontWeight: FontWeight.bold),),),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('مجموعة المواد', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            height: width * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: DropdownButton<ModulesGroup>(
                              value: noteProvider.selectedModulesGroup,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (ModulesGroup? modulesGroup) async {
                                noteProvider.selectedModulesGroup = modulesGroup;
                                await noteProvider.getStudentGroupObservation();
                                observation.text = noteProvider.selectedStudentGroupObservation!.SEGOBSERV;
                                noteProvider.notifyListeners();
                              },
                              items: noteProvider.modulesGroups?.map<DropdownMenuItem<ModulesGroup>>((ModulesGroup modulesGroup) {
                                return DropdownMenuItem<ModulesGroup>(
                                  value: modulesGroup,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Container(
                                      width: width * 0.8,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      child: Text(modulesGroup.GRPNOM, style: TextStyle(fontSize: width * 0.035, color: Colors.black,),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                          ),
                          SizedBox(height: width * 0.03,),

                          const Text('ملاحظة المجموعة', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            width: width,
                            height: width * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextField(
                              enabled: (authProvider.selectedYear!.ANECLOSE == 0 && noteProvider.selectedPeriod!.ANPCLOSE == 0),
                              controller: observation,
                              maxLines: 3,
                              maxLength: 100,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                            ),
                          ),
                          SizedBox(height: width * 0.03),

                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(authProvider.selectedYear!.ANECLOSE == 0 && noteProvider.selectedPeriod!.ANPCLOSE == 0 ? Theme.of(context).secondaryHeaderColor : Colors.grey),
                                  padding: MaterialStateProperty.all(EdgeInsets.zero)
                              ),
                              onPressed: () async {await modifyNote(context);},
                              child: noteProvider.modifyNoteStatusCode != 0 ? Text("موافق", style: TextStyle(fontSize: width * 0.05, color: Colors.white, fontWeight: FontWeight.bold),) : const CircularProgressIndicator(color: Colors.white,),
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future<void> modifyNote(BuildContext context) async {
    var noteProvider = Provider.of<NoteViewModel>(context, listen: false);
    noteProvider.selectedStudentGroupObservation!.SEGOBSERV = observation.text;
    await noteProvider.modifyStudentGroupObservation();
    if(noteProvider.modifyStudentGroupObservationStatusCode == 201){
      Toast(context: context, title: 'تم التعديل بنجاح', style: ToastificationStyle.minimal, type: ToastificationType.success);
      Navigator.pop(context);
      noteProvider.getNotes();
    }else{
      Toast(context: context, title: 'تعذر الإتصال بالخادم', style: ToastificationStyle.minimal, type: ToastificationType.error);
    }
  }
}