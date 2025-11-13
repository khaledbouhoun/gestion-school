import 'package:al_moiin/models/discipline.dart';
import 'package:al_moiin/models/discipline_type.dart';
import 'package:al_moiin/view_models/discipline_view_model.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/widgets/modify_discipline_dialog.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../view_models/system_view_model.dart';
import 'delete_warning_dialog.dart';

class DisciplineWidget extends StatelessWidget {
  Discipline discipline;
  DisciplineWidget({super.key, required this.discipline});
  Color? statColor;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    var disciplineProvider = Provider.of<DisciplineViewModel>(context, listen: false);
    var systemProvider = Provider.of<SystemViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    statColor = disciplineProvider.types.firstWhere((element) => element == discipline.DECTYPE, orElse: () => 'مخالفة') == 'مخالفة'
        ? Colors.red
        : Theme.of(context).secondaryHeaderColor;
    return TextButton(
      style: ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.zero), overlayColor: WidgetStateProperty.all(Colors.transparent)),
      onPressed: () {
        disciplineProvider.selectedDiscipline = discipline;
        //Navigator.push(context, MaterialPageRoute(builder: (builder) => const disciplineDetails()));
      },
      child: Container(
        width: width,
        //height: height * 0.15,
        padding: EdgeInsets.only(top: width * 0.02, /*bottom: width * 0.02,*/ left: width * 0.02, right: width * 0.04),
        margin: EdgeInsets.only(top: width * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            stops: const [0.03, 0.01],
            colors: [statColor!, Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              //height: height * 0.06,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${discipline.DEVDATE.hour.toString().padLeft(2, '0')}:${discipline.DEVDATE.minute.toString().padLeft(2, '0')} ${DateFormat('yyyy-MM-dd').format(discipline.DEVDATE)}',
                          style: TextStyle(color: Colors.black, fontSize: width * 0.045, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${discipline.ELVNOM} ${discipline.ELVPRENOM}',
                          style: TextStyle(color: Colors.black, fontSize: width * 0.045),
                        ),
                        Text(
                          '${disciplineProvider.disciplinesTypes?.firstWhere(
                            (element) => element.DECNO == discipline.DEVDEC,
                            orElse: () => DisciplineType(DECNO: '', DECNOM: 'غير معروف'),
                          ).DECNOM}',
                          style: TextStyle(color: Colors.black, fontSize: width * 0.045),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'الملاحظة: ',
                                style: TextStyle(color: statColor, fontWeight: FontWeight.bold, fontSize: width * 0.04),
                              ),
                              TextSpan(
                                text: discipline.DEVOBSERV == '' ? 'لا توجد ملاحظة' : discipline.DEVOBSERV,
                                style: TextStyle(color: Colors.black, fontSize: width * 0.04),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Container(
                      padding: EdgeInsets.only(right: width * 0.008, left: width * 0.008, bottom: width * 0.008),
                      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: statColor),
                      child: Text(
                        disciplineProvider.types.firstWhere((element) => element == discipline.DECTYPE, orElse: () => discipline.DECTYPE),
                        style: TextStyle(color: Colors.white, fontSize: width * 0.045),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Tooltip(
                  message: 'تغيير معلومات السلوك',
                  child: TextButton(
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.zero),
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    ),
                    onPressed: () {
                      if (authProvider.selectedYear!.ANECLOSE == 0 && disciplineProvider.selectedPeriod!.ANPCLOSE == 0) {
                        disciplineProvider.modifiedDiscipline = Discipline.modified(discipline.toJson());
                        ModifyDisciplineDialog.showModifyDialog(context, discipline.DEVDEC!);
                      }
                    },
                    child: Icon(
                      Icons.edit,
                      color: authProvider.selectedYear!.ANECLOSE == 0 && disciplineProvider.selectedPeriod!.ANPCLOSE == 0
                          ? const Color.fromRGBO(225, 179, 18, 1.0)
                          : Colors.grey,
                    ),
                  ),
                ),
                Tooltip(
                  message: 'حذف السلوك',
                  child: TextButton(
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.zero),
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    ),
                    onPressed: () {
                      if (authProvider.selectedYear!.ANECLOSE == 0 && disciplineProvider.selectedPeriod!.ANPCLOSE == 0) {
                        if ((DateTime(
                              systemProvider.dateOfDay!.year,
                              systemProvider.dateOfDay!.month,
                              systemProvider.dateOfDay!.day,
                            ).compareTo(DateTime(discipline.DEVDATE.year, discipline.DEVDATE.month, discipline.DEVDATE.day))) ==
                            0) {
                          DeleteWarningDialog.showDeleteWarningDialog(context, () async {
                            await disciplineProvider.deleteDiscipline(discipline);
                            if (disciplineProvider.deleteStatusCode == 200) {
                              Toast(
                                context: context,
                                title: 'تمت الحذف بنجاح',
                                style: ToastificationStyle.minimal,
                                type: ToastificationType.success,
                              );
                              Navigator.pop(context);
                              disciplineProvider.getDisciplines();
                            } else {
                              Toast(
                                context: context,
                                title: 'تعذر الإتصال بالخادم',
                                style: ToastificationStyle.minimal,
                                type: ToastificationType.error,
                              );
                            }
                          });
                        } else {
                          Toast(
                            context: context,
                            title: 'لا يمكنك حذف هذا السلوك',
                            style: ToastificationStyle.minimal,
                            type: ToastificationType.error,
                          );
                        }
                      }
                    },
                    child: Icon(
                      Icons.delete_rounded,
                      color: authProvider.selectedYear!.ANECLOSE == 0 && disciplineProvider.selectedPeriod!.ANPCLOSE == 0
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
