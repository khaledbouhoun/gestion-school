import 'package:al_moiin/models/absence_type.dart';
import 'package:al_moiin/models/period.dart';
import 'package:al_moiin/models/student.dart';
import 'package:al_moiin/view_models/absence_view_model.dart';
import 'package:al_moiin/view_models/student_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:toastification/toastification.dart';
import '../models/class.dart';

class AddAbsenceDialog extends StatefulWidget {
  const AddAbsenceDialog({super.key});
  @override
  State<StatefulWidget> createState() => AddAbsenceDialogPage();

  static showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddAbsenceDialog();
      },
    );
  }
}

class AddAbsenceDialogPage extends State<AddAbsenceDialog> {
  TextEditingController duration = TextEditingController();
  TextEditingController justification = TextEditingController();

  @override
  void initState() {
    duration.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    duration.dispose();
    justification.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer3<AbsenceViewModel, SystemViewModel, StudentViewModel>(
        builder: (context, absenceProvider, systemProvider, studentProvider, child) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
              child: SizedBox(
                width: width * 0.6,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'غياب جديد',
                        style: TextStyle(fontSize: width * 0.055, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'الفصل',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: width * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: DropdownButton<String>(
                            value: absenceProvider.newAbsence?.EABPER,
                            underline: Container(),
                            isExpanded: true,
                            onChanged: (String? period) async {
                              absenceProvider.newAbsence?.EABPER = period!;
                              absenceProvider.notifyListeners();
                            },
                            items: systemProvider.periods?.where((element) => element.ANPCLOSE == 0).map<DropdownMenuItem<String>>((
                              Period period,
                            ) {
                              return DropdownMenuItem<String>(
                                value: period.PERNO,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Container(
                                    //padding: EdgeInsets.only(left: width * 0.02),
                                    width: width * 0.8,
                                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
                                    child: Text(
                                      period.PERNOM,
                                      style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: width * 0.03),

                        const Text(
                          'القسم',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: width * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: DropdownButton<Class>(
                            value: systemProvider.selectedClass,
                            underline: Container(),
                            isExpanded: true,
                            onChanged: (Class? selectedClass) async {
                              absenceProvider.newAbsence?.EABELV = null;
                              systemProvider.selectedClass = selectedClass;
                              await studentProvider.getStudents(systemProvider.selectedClass!, systemProvider.selectedPeriod!);
                              absenceProvider.notifyListeners();
                              studentProvider.notifyListeners();
                            },
                            items: systemProvider.classes?.map<DropdownMenuItem<Class>>((Class selectedClass) {
                              return DropdownMenuItem<Class>(
                                value: selectedClass,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Container(
                                    width: width * 0.8,
                                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
                                    child: Text(
                                      selectedClass.CLSNOM,
                                      style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: width * 0.03),

                        const Text(
                          'التلميذ',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: width * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: DropdownButton<String>(
                            value: absenceProvider.newAbsence?.EABELV,
                            underline: Container(),
                            isExpanded: true,
                            onChanged: (String? student) async {
                              absenceProvider.newAbsence?.EABELV = student!;
                              absenceProvider.notifyListeners();
                            },
                            items: studentProvider.filtredStudent?.map<DropdownMenuItem<String>>((Student student) {
                              return DropdownMenuItem<String>(
                                value: student.elvno,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Container(
                                    width: width * 0.8,
                                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
                                    child: Text(
                                      '${student.elvnom} ${student.elvprenom}',
                                      style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: width * 0.03),

                        const Text(
                          'النوع',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: width * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: DropdownButton<String>(
                            value: absenceProvider.newAbsence?.EABTYPE,
                            underline: Container(),
                            isExpanded: true,
                            onChanged: (String? type) async {
                              absenceProvider.newAbsence?.EABTYPE = type!;
                              absenceProvider.notifyListeners();
                            },
                            items: absenceProvider.absenceTypes.map<DropdownMenuItem<String>>((AbsenceType type) {
                              return DropdownMenuItem<String>(
                                value: type.TABNO,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Container(
                                    width: width * 0.8,
                                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
                                    child: Text(
                                      type.TABNOM,
                                      style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: width * 0.03),

                        const Text(
                          'التاريخ',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: width,
                          height: width * 0.1,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: InkWell(
                            onTap: () {
                              _selectDate(context, absenceProvider.newAbsence!.EABDATE!);
                            },
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: TextStyle(fontSize: width * 0.045, color: Colors.black),
                                labelText: intl.DateFormat('yyyy-MM-dd').format(absenceProvider.newAbsence!.EABDATE!),
                                border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: width * 0.03),

                        const Text(
                          'المدة',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: width,
                          height: width * 0.1,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: TextField(
                            controller: duration,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        SizedBox(height: width * 0.03),

                        const Text(
                          'التبرير',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: width,
                          height: width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: TextField(
                            controller: justification,
                            maxLines: 3,
                            maxLength: 100,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        SizedBox(height: width * 0.03),

                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Theme.of(context).secondaryHeaderColor),
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                            ),
                            onPressed: () async {
                              await addNewAbsence(context);
                            },
                            child: absenceProvider.addStatusCode != 0
                                ? Text(
                                    "موافق",
                                    style: TextStyle(fontSize: width * 0.05, color: Colors.white, fontWeight: FontWeight.bold),
                                  )
                                : const CircularProgressIndicator(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> addNewAbsence(BuildContext context) async {
    var absenceProvider = Provider.of<AbsenceViewModel>(context, listen: false);
    var systemProvider = Provider.of<SystemViewModel>(context, listen: false);

    if (absenceProvider.newAbsence?.EABELV == null) {
      Toast(context: context, title: 'يرجى اختيار التلميذ', style: ToastificationStyle.minimal, type: ToastificationType.error);
    } else if (duration.text == '') {
      Toast(context: context, title: 'يرجى ادخال مدة الغياب', style: ToastificationStyle.minimal, type: ToastificationType.error);
    } else if (systemProvider.selectedPeriod?.ANPDEB.compareTo(absenceProvider.newAbsence!.EABDATE!) == -1 &&
        systemProvider.selectedPeriod?.ANPFIN.compareTo(absenceProvider.newAbsence!.EABDATE!) == 1) {
      absenceProvider.newAbsence!.EABDUREE = double.parse(duration.text);
      absenceProvider.newAbsence!.EABJUSTIF = justification.text;
      await absenceProvider.addNewAbsence();
      print('Add absence response status: ${absenceProvider.addStatusCode}');
      if (absenceProvider.addStatusCode == 201) {
        Toast(context: context, title: 'تمت الإضافة بنجاح', style: ToastificationStyle.minimal, type: ToastificationType.success);
        Navigator.pop(context);
        absenceProvider.getAbsences();
      } else {
        Toast(context: context, title: 'تعذر الإتصال بالخادم', style: ToastificationStyle.minimal, type: ToastificationType.error);
      }
    } else {
      Toast(
        context: context,
        title: 'يوجد خطأ في تاريخ الغياب أو في الفصل المختار',
        style: ToastificationStyle.minimal,
        type: ToastificationType.error,
      );
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime changedDate) async {
    var provider = Provider.of<AbsenceViewModel>(context, listen: false);
    var system = Provider.of<SystemViewModel>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: changedDate,
      firstDate: DateTime(0),
      lastDate: system.dateOfDay!,
    );
    if (picked != null) {
      provider.newAbsence?.EABDATE = picked;
    }
    provider.notifyListeners();
  }
}
