import 'package:al_moiin/models/absence.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/view_models/student_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/views/absence/absences.dart';
import 'package:al_moiin/widgets/modify_absence_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../../view_models/absence_view_model.dart';
import '../../widgets/detail_card.dart';

class AbsenceDetails extends StatelessWidget {
  const AbsenceDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    var absenceProvider = Provider.of<AbsenceViewModel>(context, listen: false);
    var systemProvider = Provider.of<SystemViewModel>(context, listen: false);
    var studentProvider = Provider.of<StudentViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    List details = [
      {'التاريخ': intl.DateFormat('yyyy-MM-dd').format(absenceProvider.selectedAbsence!.EABDATE!)},
      {
        'الساعة':
            '${absenceProvider.selectedAbsence?.EABDATE?.hour.toString().padLeft(2, '0')}:${absenceProvider.selectedAbsence?.EABDATE?.minute.toString().padLeft(2, '0')}',
      },
      {'القسم': '${systemProvider.classes?.firstWhere((element) => element.CLSNO == absenceProvider.selectedAbsence?.AFFCLS).CLSNOM}'},
      {
        absenceProvider.selectedAbsence?.ELVSEXE == 0 ? 'التلميذ' : 'التلميذة':
            '${absenceProvider.selectedAbsence?.ELVNOM} ${absenceProvider.selectedAbsence?.ELVPRENOM}',
      },
      {'النوع': absenceProvider.absenceTypes.firstWhere((element) => element.TABNO == absenceProvider.selectedAbsence!.EABTYPE).TABNOM},
      {'المدة': '${absenceProvider.selectedAbsence!.EABDUREE.round()}'},
      {'التبرير': absenceProvider.selectedAbsence!.EABJUSTIF},
      {'رقم هاتف الولي 1': absenceProvider.selectedAbsence!.ELVtel1 ?? 'لا يوجد'},
      {'رقم هاتف الولي 2': absenceProvider.selectedAbsence!.ELVtel2 ?? 'لا يوجد'},
    ];
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (builder) => const Absences()));
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: Center(
            child: Text(
              'تفاصيل الغياب',
              style: TextStyle(color: Colors.white, fontSize: width * 0.06, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Consumer<AbsenceViewModel>(
          builder: (context, absenceprovider, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                width: width,
                height: height,
                child: ListView.builder(
                  itemCount: details.length,
                  itemBuilder: (context, index) {
                    var key = details[index].keys.first;
                    return DetailCard(
                      title: key,
                      subtitle: details[index][key],
                      numberphone: key == 'رقم هاتف الولي 1' || key == 'رقم هاتف الولي 2' ? true : false,
                    );
                  },
                ),
              ),
            );
          },
        ),
        floatingActionButton: TextButton(
          style: const ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
            overlayColor: WidgetStatePropertyAll(Colors.transparent),   
          ),
          onPressed: () {
            if (authProvider.selectedYear!.ANECLOSE == 0 && absenceProvider.selectedPeriod!.ANPCLOSE == 0) {
              absenceProvider.modifiedAbsence = Absence.modified(absenceProvider.selectedAbsence!.toJson());
              ModifyAbsenceDialog.showModifyDialog(context);
            }
          },
          child: Container(
            padding: EdgeInsets.all(width * 0.01),
            decoration: BoxDecoration(
              color: authProvider.selectedYear!.ANECLOSE == 0 && absenceProvider.selectedPeriod!.ANPCLOSE == 0
                  ? const Color.fromRGBO(225, 179, 18, 1.0)
                  : Colors.grey,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: authProvider.selectedYear!.ANECLOSE == 0 && absenceProvider.selectedPeriod!.ANPCLOSE == 0
                      ? const Color.fromRGBO(225, 179, 18, 1.0)
                      : Colors.grey,
                  blurRadius: 20.0,
                  offset: const Offset(0.0, 0.75),
                ),
              ],
            ),
            child: Icon(Icons.edit_rounded, color: Colors.white, size: width * 0.13),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
