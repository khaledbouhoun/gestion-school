import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/view_models/discipline_view_model.dart';
import 'package:al_moiin/view_models/note_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/view_models/tranche_view_model.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../view_models/absence_view_model.dart';

class HomeButton extends StatelessWidget {
  String title;
  Widget direction;
  String imagePath;
  HomeButton({super.key, required this.title, required this.direction, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return TextButton(
      style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero), overlayColor: WidgetStatePropertyAll(Colors.transparent)),
      onPressed: () {
        if (title == 'الغيابات') {
          var systemProvider = Provider.of<SystemViewModel>(context, listen: false);
          var absenceProvider = Provider.of<AbsenceViewModel>(context, listen: false);
          absenceProvider.selectedClass = systemProvider.classes?.firstWhere((element) => element == systemProvider.selectedClass);
          absenceProvider.selectedPeriod = systemProvider.periods?.firstWhere((element) => element == systemProvider.selectedPeriod);
          absenceProvider.start = DateTime.now();
          absenceProvider.end = DateTime.now();
        }
        if (title == 'العلامات') {
          var systemProvider = Provider.of<SystemViewModel>(context, listen: false);
          var noteProvider = Provider.of<NoteViewModel>(context, listen: false);
          noteProvider.selectedClass = systemProvider.classes?.firstWhere((element) => element == systemProvider.selectedClass);
          noteProvider.selectedPeriod = systemProvider.periods?.firstWhere((element) => element == systemProvider.selectedPeriod);
        }
        if (title == 'السلوكات') {
          var systemProvider = Provider.of<SystemViewModel>(context, listen: false);
          var disciplineProvider = Provider.of<DisciplineViewModel>(context, listen: false);
          disciplineProvider.selectedType = disciplineProvider.types.first;
          disciplineProvider.selectedClass = systemProvider.classes?.firstWhere((element) => element == systemProvider.selectedClass);
          disciplineProvider.selectedPeriod = systemProvider.periods?.firstWhere((element) => element == systemProvider.selectedPeriod);
        }
        if (title == 'التحصيل القرآني') {
          var authProvider = Provider.of<AuthViewModel>(context, listen: false);
          if (authProvider.rubriques!
              .where((element) => element.USBANE == authProvider.selectedYear!.ANENO && element.USBTRB == '02' && element.USBRUB == '01')
              .isNotEmpty) {
            var systemProvider = Provider.of<SystemViewModel>(context, listen: false);
            var trancheProvider = Provider.of<TrancheViewModel>(context, listen: false);
            trancheProvider.selectedClass = systemProvider.classes?.firstWhere((element) => element == systemProvider.selectedClass);
            trancheProvider.selectedPeriod = systemProvider.periods?.firstWhere((element) => element == systemProvider.selectedPeriod);
          } else {
            Toast(
              context: context,
              title: 'لا يمكنك الدخول إلى هذا القسم',
              style: ToastificationStyle.minimal,
              type: ToastificationType.warning,
            );
            return;
          }
        }
        Navigator.push(context, MaterialPageRoute(builder: (builder) => direction));
      },
      child: Container(
        width: width * 0.41,
        height: width * 0.41,
        margin: EdgeInsets.only(bottom: width * 0.06),
        padding: EdgeInsets.all(width * 0.045),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.grey[500]!, blurRadius: 5.0, spreadRadius: 0, offset: const Offset(0, 1))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(imagePath, width: width * 0.18, height: width * 0.18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: width * 0.04, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
