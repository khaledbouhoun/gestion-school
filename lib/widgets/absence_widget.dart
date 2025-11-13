import 'package:al_moiin/models/absence.dart';
import 'package:al_moiin/models/absence_type.dart';
import 'package:al_moiin/view_models/absence_view_model.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/views/absence/absence_details.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'delete_warning_dialog.dart';

class AbsenceWidget extends StatelessWidget {
  final Absence absence;
  const AbsenceWidget({super.key, required this.absence});

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    var absenceProvider = Provider.of<AbsenceViewModel>(context, listen: false);
    var systemProvider = Provider.of<SystemViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final absenceType = absenceProvider.absenceTypes.firstWhere(
      (element) => element.TABNO == absence.EABTYPE,
      orElse: () => AbsenceType(TABNO: '00', TABNOM: 'غير معروف'),
    );
    final Color statColor = absenceType.TABNO == '01'
        ? Colors.red
        : absenceType.TABNO == '02'
        ? Theme.of(context).secondaryHeaderColor
        : absenceType.TABNO == '03'
        ? const Color.fromRGBO(225, 179, 18, 1.0)
        : Colors.blue;
    return TextButton(
      style: ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.zero), overlayColor: WidgetStateProperty.all(Colors.transparent)),
      onPressed: () {
        absenceProvider.selectedAbsence = absence;
        Navigator.push(context, MaterialPageRoute(builder: (builder) => const AbsenceDetails()));
      },
      child: Container(
        width: width,
        height: height * 0.11,
        padding: EdgeInsets.only(top: width * 0.02, bottom: width * 0.02, left: width * 0.02, right: width * 0.04),
        margin: EdgeInsets.only(top: width * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            stops: const [0.03, 0.01],
            colors: [statColor, Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              height: height * 0.06,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd').format(absence.EABDATE!),
                          // '${absence.EABDATE?.hour.toString().padLeft(2, '0')}:${absence.EABDATE?.minute.toString().padLeft(2, '0')} ${DateFormat('yyyy-MM-dd').format(absence.EABDATE!)}',
                          style: TextStyle(color: Colors.black, fontSize: width * 0.045, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${absence.ELVNOM} ${absence.ELVPRENOM}',
                          style: TextStyle(color: Colors.black, fontSize: width * 0.045),
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Container(
                      padding: EdgeInsets.only(right: width * 0.008, left: width * 0.008, bottom: width * 0.008),
                      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: statColor),
                      child: Text(
                        absenceType.TABNOM,
                        style: TextStyle(color: Colors.white, fontSize: width * 0.045),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'المدة: ',
                        style: TextStyle(color: statColor, fontSize: width * 0.045, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '${absence.EABDUREE.round()}',
                        style: TextStyle(color: Colors.black, fontSize: width * 0.045),
                      ),
                    ],
                  ),
                ),
                Tooltip(
                  message: 'حذف النقطة و العلامة',
                  child: GestureDetector(
                    onTap: () {
                      if (authProvider.selectedYear!.ANECLOSE == 0 && absenceProvider.selectedPeriod!.ANPCLOSE == 0) {
                        print("systemProvider.dateOfDay: ${systemProvider.dateOfDay}");
                        print("absence.EABDATE: ${absence.EABDATE}");
                        if ((DateTime(
                              systemProvider.dateOfDay!.year,
                              systemProvider.dateOfDay!.month,
                              systemProvider.dateOfDay!.day,
                            ).compareTo(DateTime(absence.EABDATE!.year, absence.EABDATE!.month, absence.EABDATE!.day))) ==
                            0) {
                          DeleteWarningDialog.showDeleteWarningDialog(context, () async {
                            await absenceProvider.deleteAbsence(absence);
                            if (absenceProvider.deleteStatusCode == 200) {
                              Toast(
                                context: context,
                                title: 'تمت الحذف بنجاح',
                                style: ToastificationStyle.minimal,
                                type: ToastificationType.success,
                              );
                              Navigator.pop(context);
                              absenceProvider.getAbsences();
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
                            title: 'لا يمكنك حذف هدا الغياب',
                            style: ToastificationStyle.minimal,
                            type: ToastificationType.error,
                          );
                        }
                      }
                    },
                    child: Icon(
                      size: 20.0,
                      Icons.delete_rounded,
                      color: authProvider.selectedYear!.ANECLOSE == 0 && absenceProvider.selectedPeriod!.ANPCLOSE == 0
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
