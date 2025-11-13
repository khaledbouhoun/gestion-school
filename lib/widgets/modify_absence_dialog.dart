import 'package:al_moiin/models/absence_type.dart';
import 'package:al_moiin/view_models/absence_view_model.dart';
import 'package:al_moiin/view_models/student_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class ModifyAbsenceDialog extends StatefulWidget {
  const ModifyAbsenceDialog({super.key});
  @override
  State<StatefulWidget> createState() => ModifyAbsenceDialogPage();

  static showModifyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ModifyAbsenceDialog();
      },
    );
  }
}

class ModifyAbsenceDialogPage extends State<ModifyAbsenceDialog> {
  TextEditingController duration = TextEditingController();
  TextEditingController justification = TextEditingController();

  @override
  void initState() {
    var absenceProvider = Provider.of<AbsenceViewModel>(context, listen: false);
    duration.text = absenceProvider.modifiedAbsence!.EABDUREE.round().toString();
    justification.text = absenceProvider.modifiedAbsence!.EABJUSTIF;
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
                        'تغيير معلومات الغياب',
                        style: TextStyle(fontSize: width * 0.055, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            value: absenceProvider.modifiedAbsence?.EABTYPE,
                            underline: Container(),
                            isExpanded: true,
                            onChanged: (String? type) async {
                              absenceProvider.modifiedAbsence?.EABTYPE = type!;
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
                              await modifyAbsence(context);
                            },
                            child: absenceProvider.modifStatusCode != 0
                                ? Text(
                                    "تعديل",
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

  Future<void> modifyAbsence(BuildContext context) async {
    var absenceProvider = Provider.of<AbsenceViewModel>(context, listen: false);
    if (duration.text == '') {
      Toast(context: context, title: 'يرجى ادخال مدة الغياب', style: ToastificationStyle.minimal, type: ToastificationType.error);
    } else {
      absenceProvider.modifiedAbsence!.EABDUREE = double.parse(duration.text);
      absenceProvider.modifiedAbsence!.EABJUSTIF = justification.text;
      await absenceProvider.modifyAbsence();
      if (absenceProvider.modifStatusCode == 200) {
        Toast(context: context, title: 'تم التغيير بنجاح', style: ToastificationStyle.minimal, type: ToastificationType.success);
        Navigator.pop(context);
      } else {
        Toast(context: context, title: 'تعذر الإتصال بالخادم', style: ToastificationStyle.minimal, type: ToastificationType.error);
      }
    }
  }
}
