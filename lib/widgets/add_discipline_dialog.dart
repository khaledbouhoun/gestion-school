import 'package:al_moiin/models/discipline_type.dart';
import 'package:al_moiin/models/period.dart';
import 'package:al_moiin/models/student.dart';
import 'package:al_moiin/view_models/discipline_view_model.dart';
import 'package:al_moiin/view_models/student_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:toastification/toastification.dart';
import '../models/class.dart';

class AddDisciplineDialog extends StatefulWidget{
  const AddDisciplineDialog({super.key});
  @override
  State<StatefulWidget> createState() => AddDisciplineDialogPage();

  static showAddDialog(BuildContext context){
    var disciplineProvider = Provider.of<DisciplineViewModel>(context, listen: false);
    var studentProvider = Provider.of<StudentViewModel>(context, listen: false);
    disciplineProvider.getDisciplineTypes(type: 1, selectedType: disciplineProvider.newDiscipline!.DECTYPE);
    studentProvider.getStudents(disciplineProvider.selectedClass!, disciplineProvider.selectedPeriod!);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AddDisciplineDialog();
        });
  }
}

class AddDisciplineDialogPage extends State<AddDisciplineDialog>{

  TextEditingController observation = TextEditingController();

  @override
  void initState() {
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
                      Center(child: Text('سلوك جديد', style: TextStyle(fontSize: width * 0.055, fontWeight: FontWeight.bold),),),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('الفصل', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
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
                              value: disciplineProvider.newDiscipline?.DEVPER,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? period) async {
                                disciplineProvider.newDiscipline?.DEVPER = period!;
                                disciplineProvider.notifyListeners();
                              },
                              items: systemProvider.periods?.where((element) => element.ANPCLOSE == 0)?.map<DropdownMenuItem<String>>((Period period) {
                                return DropdownMenuItem<String>(
                                  value: period.PERNO,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Container(
                                      //padding: EdgeInsets.only(left: width * 0.02),
                                      width: width * 0.8,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      child: Text(period.PERNOM, style: TextStyle(fontSize: width * 0.035, color: Colors.black,),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                          ),
                          SizedBox(height: width * 0.03,),

                          const Text('القسم', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            height: width * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: DropdownButton<Class>(
                              value: systemProvider.selectedClass,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (Class? selectedClass) async {
                                disciplineProvider.newDiscipline?.DEVELV = null;
                                systemProvider.selectedClass = selectedClass;
                                await studentProvider.getStudents(systemProvider.selectedClass!, systemProvider.selectedPeriod!);
                                disciplineProvider.notifyListeners();
                                studentProvider.notifyListeners();
                              },
                              items: systemProvider.classes?.map<DropdownMenuItem<Class>>((Class selectedClass) {
                                return DropdownMenuItem<Class>(
                                  value: selectedClass,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Container(
                                      width: width * 0.8,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      child: Text(selectedClass.CLSNOM, style: TextStyle(fontSize: width * 0.035, color: Colors.black,),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                          ),
                          SizedBox(height: width * 0.03,),

                          const Text('التلميذ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
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
                              value: disciplineProvider.newDiscipline?.DEVELV,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? student) async {
                                disciplineProvider.newDiscipline?.DEVELV = student!;
                                disciplineProvider.notifyListeners();
                              },
                              items: studentProvider.filtredStudent?.map<DropdownMenuItem<String>>((Student student) {
                                return DropdownMenuItem<String>(
                                  value: student.elvno,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Container(
                                      width: width * 0.8,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      child: Text('${student.elvnom} ${student.elvprenom}', style: TextStyle(fontSize: width * 0.035, color: Colors.black,),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                          ),
                          SizedBox(height: width * 0.03,),

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
                              value: disciplineProvider.newDiscipline?.DECTYPE,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? type) async {
                                disciplineProvider.newDiscipline?.DEVDEC = null;
                                disciplineProvider.newDiscipline?.DECTYPE = type!;
                                disciplineProvider.getDisciplineTypes(type: 1, selectedType: disciplineProvider.newDiscipline!.DECTYPE);
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
                              value: disciplineProvider.newDiscipline?.DEVDEC,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? disciplineType) async {
                                disciplineProvider.newDiscipline?.DEVDEC = disciplineType!;
                                disciplineProvider.notifyListeners();
                              },
                              items: disciplineProvider.addDisciplinesTypes?.map<DropdownMenuItem<String>>((DisciplineType disciplineType) {
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

                          const Text('التاريخ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            width: width,
                            height: width * 0.1,
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: InkWell(
                              onTap: (){_selectDate(context, disciplineProvider.newDiscipline!.DEVDATE!);},
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(fontSize: width * 0.045, color: Colors.black),
                                    labelText: intl.DateFormat('yyyy-MM-dd').format(disciplineProvider.newDiscipline!.DEVDATE!),
                                    border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                              ),
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
                              onPressed: () async {await addNewDiscipline(context);},
                              child: disciplineProvider.addStatusCode != 0 ? Text("موافق", style: TextStyle(fontSize: width * 0.05, color: Colors.white, fontWeight: FontWeight.bold),) : const CircularProgressIndicator(color: Colors.white,),
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

  Future<void> addNewDiscipline(BuildContext context) async {
    var disciplineProvider = Provider.of<DisciplineViewModel>(context, listen: false);
    var systemProvider = Provider.of<SystemViewModel>(context, listen: false);
    if(disciplineProvider.newDiscipline?.DEVELV == null){
      Toast(context: context, title: 'يرجى اختيار التلميذ', style: ToastificationStyle.minimal, type: ToastificationType.error);
    }else if(systemProvider.selectedPeriod?.ANPDEB.compareTo(disciplineProvider.newDiscipline!.DEVDATE!) == -1 && systemProvider.selectedPeriod?.ANPFIN.compareTo(disciplineProvider.newDiscipline!.DEVDATE!) == 1){
      disciplineProvider.newDiscipline!.DEVOBSERV = observation.text;
      await disciplineProvider.addDiscipline();
      if(disciplineProvider.addStatusCode == 201){
        Toast(context: context, title: 'تمت الإضافة بنجاح', style: ToastificationStyle.minimal, type: ToastificationType.success);
        Navigator.pop(context);
        disciplineProvider.getDisciplines();
      }else{
        Toast(context: context, title: 'تعذر الإتصال بالخادم', style: ToastificationStyle.minimal, type: ToastificationType.error);
      }
    }else{
      Toast(context: context, title: 'يوجد خطأ في التاريخ أو في الفصل المختار', style: ToastificationStyle.minimal, type: ToastificationType.error);
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime changedDate) async {
    var provider = Provider.of<DisciplineViewModel>(context, listen: false);
    var system = Provider.of<SystemViewModel>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: changedDate,
      firstDate: DateTime(0),
      lastDate: system.dateOfDay!,
    );
    if(picked != null){
      provider.newDiscipline?.DEVDATE = picked;
    }
    provider.notifyListeners();
  }
}