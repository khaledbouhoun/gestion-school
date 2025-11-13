import 'package:al_moiin/mixins/quran.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/view_models/tranche_view_model.dart';
import 'package:al_moiin/views/tranche/tranches.dart';
import 'package:al_moiin/widgets/modify_tranche_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/tranche.dart';
import '../../widgets/detail_card.dart';

class TrancheDetails extends StatelessWidget with Quran{
  TrancheDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var authProvider= Provider.of<AuthViewModel>(context, listen: false);
    var trancheProvider= Provider.of<TrancheViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    List details = [
      {'سورة البداية' : '${surat.firstWhere((element) => element[element.keys.first] == trancheProvider.selectedTranche?.TRCSOURADE?.round().toString())['name']}'},
      {'آية البداية' : '${trancheProvider.selectedTranche!.TRCAYADE!.round()}'},
      {'سورة النهاية' : '${surat.firstWhere((element) => element[element.keys.first] == trancheProvider.selectedTranche?.TRCSOURAA?.round().toString())['name']}'},
      {'آية النهاية' : '${trancheProvider.selectedTranche!.TRCAYAA!.round()}'},
      {'الإتجاه' : trancheProvider!.types.firstWhere((element) => element.keys.first == trancheProvider.selectedTranche?.TRCSENS).entries.first.value},
      {'عدد الأحزاب' : '${trancheProvider.selectedTranche!.TRCNBHIZEB!.round()}'},
      {'عدد الأثمان' : '${trancheProvider.selectedTranche!.TRCNBTHOMON!.round()}'},
      {'نوعية الحفظ' : trancheProvider!.selectedTranche?.TRCOBS}
    ];
    return WillPopScope(
      onWillPop: () async {Navigator.push(context, MaterialPageRoute(builder: (builder) => const Tranches())); return false;},
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: Center(child: Text('تفاصيل القسط', style: TextStyle(color: Colors.white, fontSize: width * 0.06, fontWeight: FontWeight.bold),)),
        ),
        body: Consumer<TrancheViewModel>(
          builder: (context, trancheProvider, child){
            return Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  width: width,
                  height: height,
                  child: ListView.builder(
                      itemCount: details.length,
                      itemBuilder: (context, index){
                        var key = details[index].keys.first;
                        return DetailCard(title: key, subtitle: details[index][key],);
                      }),
                )
            );
          },
        ),
        floatingActionButton: TextButton(
          style: const ButtonStyle(
              padding: MaterialStatePropertyAll(EdgeInsets.zero),
              overlayColor: MaterialStatePropertyAll(Colors.transparent)
          ),
          onPressed: () {
            if(authProvider.selectedYear!.ANECLOSE == 0 && trancheProvider.selectedPeriod!.ANPCLOSE == 0){
              trancheProvider.modifiedTranche = Tranche.modified(trancheProvider.selectedTranche!.toJson());
              ModifyTrancheDialog.showModifyDialog(context);
            }
          },
          child: Container(
            padding: EdgeInsets.all(width * 0.01),
            decoration: BoxDecoration(
              color: authProvider.selectedYear!.ANECLOSE == 0 && trancheProvider.selectedPeriod!.ANPCLOSE == 0 ? const Color.fromRGBO(225, 179, 18, 1.0) : Colors.grey,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: authProvider.selectedYear!.ANECLOSE == 0 && trancheProvider.selectedPeriod!.ANPCLOSE == 0 ? const Color.fromRGBO(225, 179, 18, 1.0) : Colors.grey,
                  blurRadius: 20.0,
                  offset: const Offset(0.0, 0.75),
                ),
              ],
            ),
            child: Icon(Icons.edit_rounded, color: Colors.white, size: width * 0.13,),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

}