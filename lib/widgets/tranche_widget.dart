import 'package:al_moiin/mixins/quran.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/view_models/tranche_view_model.dart';
import 'package:al_moiin/views/tranche/tranche_details.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../models/tranche.dart';
import 'delete_warning_dialog.dart';

class TrancheWidget extends StatelessWidget with Quran {
  Tranche tranche;
  TrancheWidget({super.key, required this.tranche});
  Color? statColor;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    var trancheProvider = Provider.of<TrancheViewModel>(context, listen: false);
    var systemProvider = Provider.of<SystemViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    statColor = tranche.TRCSENS == 01
        ? Colors.blue
        : tranche.TRCSENS == 02
        ? Theme.of(context).secondaryHeaderColor
        : const Color.fromRGBO(225, 179, 18, 1.0);
    return TextButton(
      style: ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.zero), overlayColor: WidgetStateProperty.all(Colors.transparent)),
      onPressed: () {
        trancheProvider.selectedTranche = tranche;
        Navigator.push(context, MaterialPageRoute(builder: (builder) => TrancheDetails()));
      },
      child: Container(
        width: width,
        height: height * 0.11,
        padding: EdgeInsets.only(top: width * 0.02, bottom: width * 0.02, left: width * 0.02, right: width * 0.04),
        margin: EdgeInsets.only(top: width * 0.02),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
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
                          '${tranche.ELVNOM} ${tranche.ELVPRENOM}',
                          style: TextStyle(color: Colors.black, fontSize: width * 0.045),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'من: ',
                                style: TextStyle(color: statColor, fontSize: width * 0.045, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    '${surat.firstWhere((element) => element[element.keys.first] == tranche.TRCSOURADE?.round().toString())['name']} - ${tranche.TRCAYADE?.round()}',
                                style: TextStyle(color: Colors.black, fontSize: width * 0.045),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Container(
                      padding: EdgeInsets.only(right: width * 0.008, left: width * 0.008, bottom: width * 0.008),
                      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: statColor),
                      child: Text(
                        trancheProvider.types.firstWhere((element) => element.keys.first == tranche.TRCSENS).entries.first.value,
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
                        text: 'إلى: ',
                        style: TextStyle(color: statColor, fontSize: width * 0.045, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            '${surat.firstWhere((element) => element[element.keys.first] == tranche.TRCSOURAA?.round().toString())['name']} - ${tranche.TRCAYAA?.round()}',
                        style: TextStyle(color: Colors.black, fontSize: width * 0.045),
                      ),
                    ],
                  ),
                ),
                Tooltip(
                  message: 'حذف القسط القرآني',
                  child: GestureDetector(
                    onTap: () {
                      if (authProvider.selectedYear!.ANECLOSE == 0 && trancheProvider.selectedPeriod!.ANPCLOSE == 0) {
                        DeleteWarningDialog.showDeleteWarningDialog(context, () async {
                          await trancheProvider.deleteTranche(tranche);
                          if (trancheProvider.deleteStatusCode == 200) {
                            Toast(
                              context: context,
                              title: 'تمت الحذف بنجاح',
                              style: ToastificationStyle.minimal,
                              type: ToastificationType.success,
                            );
                            Navigator.pop(context);
                            trancheProvider.getTranches();
                          } else {
                            Toast(
                              context: context,
                              title: 'تعذر الإتصال بالخادم',
                              style: ToastificationStyle.minimal,
                              type: ToastificationType.error,
                            );
                          }
                        });
                      }
                    },
                    child: Icon(
                      Icons.delete_rounded,
                      size: 25,
                      color: authProvider.selectedYear!.ANECLOSE == 0 && trancheProvider.selectedPeriod!.ANPCLOSE == 0
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
