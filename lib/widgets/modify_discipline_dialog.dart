import 'package:al_moiin/models/discipline_type.dart';
import 'package:al_moiin/view_models/discipline_view_model.dart';
import 'package:al_moiin/view_models/student_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class ModifyDisciplineDialog extends StatefulWidget{
  ModifyDisciplineDialog({super.key, required this.oldDiscipline});
  @override
  State<StatefulWidget> createState() => ModifyDisciplineDialogPage();
  String oldDiscipline;

  static showModifyDialog(BuildContext context, String oldDiscipline) async {
    var disciplineProvider = Provider.of<DisciplineViewModel>(context, listen: false);
    await disciplineProvider.getDisciplineTypes(type: 2, selectedType: disciplineProvider.modifiedDiscipline!.DECTYPE);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ModifyDisciplineDialog(oldDiscipline: oldDiscipline);
        });
  }
}

class ModifyDisciplineDialogPage extends State<ModifyDisciplineDialog>{

  TextEditingController observation = TextEditingController();

  @override
  void initState() {
    var disciplineProvider = Provider.of<DisciplineViewModel>(context, listen: false);
    observation.text = disciplineProvider.modifiedDiscipline!.DEVOBSERV;
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer3<DisciplineViewModel, SystemViewModel, StudentViewModel>(
          builder: (context, disciplineProvider, systemProvider, studentProvider, child){
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                child: Container(
                  width: width * 0.6,
                  child: Column(
                    children: [
                      Center(child: Text('تغيير معلومات السلوك', style: TextStyle(fontSize: width * 0.055, fontWeight: FontWeight.bold),),),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('النوع', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            height: width * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: disciplineProvider.modifiedDiscipline?.DECTYPE,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? type) async {
                                disciplineProvider.modifiedDiscipline?.DEVDEC = null;
                                disciplineProvider.modifiedDiscipline?.DECTYPE = type!;
                                disciplineProvider.getDisciplineTypes(type: 2, selectedType: disciplineProvider.modifiedDiscipline!.DECTYPE);
                                disciplineProvider.notifyListeners();
                              },
                              items: disciplineProvider.types?.map<DropdownMenuItem<String>>((String type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Container(
                                      width: width * 0.8,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      child: Text(type, style: TextStyle(fontSize: width * 0.035, color: Colors.black,),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                          ),
                          SizedBox(height: width * 0.03,),

                          const Text('السلوك', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            height: width * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: disciplineProvider.modifiedDiscipline?.DEVDEC,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? disciplineType) async {
                                disciplineProvider.modifiedDiscipline?.DEVDEC = disciplineType!;
                                disciplineProvider.notifyListeners();
                              },
                              items: disciplineProvider.modifyDisciplinesTypes?.map<DropdownMenuItem<String>>((DisciplineType disciplineType) {
                                return DropdownMenuItem<String>(
                                  value: disciplineType.DECNO,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Container(
                                      width: width * 0.8,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      child: Text(disciplineType.DECNOM, style: TextStyle(fontSize: width * 0.035, color: Colors.black,),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                          ),
                          SizedBox(height: width * 0.03,),

                          const Text('الملاحظة', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            width: width,
                            height: width * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color.fromRGBO(10, 107, 77, 1.0)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextField(
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
                                  backgroundColor: MaterialStatePropertyAll(Theme.of(context).secondaryHeaderColor),
                                  padding: MaterialStateProperty.all(EdgeInsets.zero)
                              ),
                              onPressed: () async {await modifyDiscipline(context);},
                              child: disciplineProvider.modifyStatusCode != 0 ? Text("موافق", style: TextStyle(fontSize: width * 0.05, color: Colors.white, fontWeight: FontWeight.bold),) : const CircularProgressIndicator(color: Colors.white,),
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

  Future<void> modifyDiscipline(BuildContext context) async {
    var disciplineProvider = Provider.of<DisciplineViewModel>(context, listen: false);
    disciplineProvider.modifiedDiscipline!.DEVOBSERV = observation.text;
    await disciplineProvider.modifyDiscipline(widget.oldDiscipline);
    if(disciplineProvider.modifyStatusCode == 200){
      Toast(context: context, title: 'تمت الإضافة بنجاح', style: ToastificationStyle.minimal, type: ToastificationType.success);
      Navigator.pop(context);
      disciplineProvider.getDisciplines();
    }else{
      Toast(context: context, title: 'تعذر الإتصال بالخادم', style: ToastificationStyle.minimal, type: ToastificationType.error);
    }
  }
}