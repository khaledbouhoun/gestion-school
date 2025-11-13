import 'package:al_moiin/home.dart';
import 'package:al_moiin/mixins/quran.dart';
import 'package:al_moiin/models/period.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/view_models/tranche_view_model.dart';
import 'package:al_moiin/widgets/add_tranche_dialog.dart';
import 'package:al_moiin/widgets/tranche_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../models/class.dart';
import '../../models/tranche.dart';
import '../../view_models/auth_view_model.dart';
import '../../widgets/toast.dart';

class Tranches extends StatefulWidget {
  const Tranches({super.key});

  @override
  State<StatefulWidget> createState() => TranchesPage();
}

class TranchesPage extends State<Tranches> with Quran {
  @override
  void initState() {
    super.initState();
    var trancheProvider = Provider.of<TrancheViewModel>(context, listen: false);
    trancheProvider.getTranches();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer2<TrancheViewModel, SystemViewModel>(
        builder: (context, trancheProvider, systemProvider, child) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.push(context, MaterialPageRoute(builder: (builder) => const Home()));
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                trancheProvider.getTranches();
              },
              child: Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                appBar: AppBar(
                  toolbarHeight: height * 0.055,
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  automaticallyImplyLeading: false,
                  title: Center(
                    child: Text(
                      'القسط القرآني',
                      style: TextStyle(color: Colors.white, fontSize: width * 0.07, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                body: SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        height: width * 0.25,
                        padding: EdgeInsets.all(width * 0.02),
                        decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(color: Theme.of(context).secondaryHeaderColor, blurRadius: 30.0, offset: const Offset(0.0, 0.75)),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width * 0.65,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'الفصل',
                                    style: TextStyle(color: Colors.white, fontSize: width * 0.05, fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: width * 0.009),
                                    width: width * 0.45,
                                    height: width * 0.1,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: DropdownButton<Period>(
                                      value: trancheProvider.selectedPeriod,
                                      underline: Container(),
                                      isExpanded: true,
                                      onChanged: (Period? period) {
                                        trancheProvider.selectedPeriod = period;
                                        trancheProvider.notifyListeners();
                                        trancheProvider.getTranches();
                                      },
                                      items: systemProvider.periods!.map<DropdownMenuItem<Period>>((Period period) {
                                        return DropdownMenuItem<Period>(
                                          value: period,
                                          child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Container(
                                              padding: EdgeInsets.only(left: width * 0.02),
                                              width: width * 0.4,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                              ),
                                              child: Text(
                                                period.PERNOM,
                                                style: TextStyle(
                                                  fontSize: width * 0.04,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width * 0.65,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'الفوج',
                                    style: TextStyle(color: Colors.white, fontSize: width * 0.05, fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: width * 0.009),
                                    width: width * 0.45,
                                    height: width * 0.1,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: DropdownButton<Class>(
                                      value: trancheProvider.selectedClass,
                                      underline: Container(),
                                      isExpanded: true,
                                      onChanged: (Class? selectedClass) {
                                        trancheProvider.selectedClass = selectedClass;
                                        trancheProvider.notifyListeners();
                                        trancheProvider.getTranches();
                                      },
                                      items: systemProvider.classes?.map<DropdownMenuItem<Class>>((Class selectedClass) {
                                        return DropdownMenuItem<Class>(
                                          value: selectedClass,
                                          child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Container(
                                              padding: EdgeInsets.only(left: width * 0.02),
                                              width: width * 0.4,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                              ),
                                              child: Text(
                                                selectedClass.CLSNOM,
                                                style: TextStyle(
                                                  fontSize: width * 0.04,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: trancheProvider.statusCode == 200
                            ? Container(
                                padding: EdgeInsets.only(left: width * 0.02, right: width * 0.02, bottom: width * 0.02),
                                child: ListView.builder(
                                  itemCount: trancheProvider.tranches?.length,
                                  itemBuilder: (context, index) {
                                    return TrancheWidget(tranche: trancheProvider.tranches![index]);
                                  },
                                ),
                              )
                            : trancheProvider.statusCode == 404
                            ? Center(
                                child: Text('لا توجد غيابات في هذه المدة', style: TextStyle(fontSize: width * 0.05)),
                              )
                            : trancheProvider.statusCode == 0
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('تعذر الإتصال بالخادم', style: TextStyle(fontSize: width * 0.05)),
                                  SizedBox(height: height * 0.02),
                                  ElevatedButton(
                                    style: ButtonStyle(padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
                                    onPressed: () {
                                      trancheProvider.getTranches();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(width * 0.03),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: const Text(
                                        'حاول مجددا',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: TextButton(
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  ),
                  onPressed: () async {
                    if (authProvider.selectedYear!.ANECLOSE == 0 && trancheProvider.selectedPeriod!.ANPCLOSE == 0) {
                      await trancheProvider.getStudentsWithoutTranche();
                      if (trancheProvider.students!.isEmpty) {
                        Toast(
                          context: context,
                          title: 'جميع التلاميذ لديهم أقساط',
                          style: ToastificationStyle.minimal,
                          type: ToastificationType.info,
                        );
                        return;
                      }
                      trancheProvider.newTranche = Tranche();
                      trancheProvider.newTranche?.TRCELV = trancheProvider.students!.first.elvno;
                      trancheProvider.newTranche?.TRCANE = trancheProvider.selectedClass!.CLSANE;
                      trancheProvider.newTranche?.TRCPER = trancheProvider.selectedPeriod!.PERNO;
                      trancheProvider.newTranche?.TRCCYC = trancheProvider.selectedClass!.CLSCYC;
                      trancheProvider.newTranche?.TRCNIV = trancheProvider.selectedClass!.CLSNIV;
                      trancheProvider.newTranche?.TRCCLS = trancheProvider.selectedClass!.CLSNO;
                      trancheProvider.newTranche?.TRCSPC = trancheProvider.selectedClass!.CLSSPC;
                      trancheProvider.newTranche?.TRCSENS = 1;
                      trancheProvider.newTranche?.TRCSOURADE = 1;
                      trancheProvider.newTranche?.TRCAYADE = 1;
                      trancheProvider.newTranche?.TRCSOURAA = 1;
                      trancheProvider.newTranche?.TRCAYAA = 1;
                      AddTrancheDialog.showAddDialog(context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: authProvider.selectedYear!.ANECLOSE == 0 && trancheProvider.selectedPeriod!.ANPCLOSE == 0
                          ? Theme.of(context).secondaryHeaderColor
                          : Colors.grey,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: authProvider.selectedYear!.ANECLOSE == 0 && trancheProvider.selectedPeriod!.ANPCLOSE == 0
                              ? Theme.of(context).secondaryHeaderColor
                              : Colors.grey,
                          blurRadius: 20.0,
                          offset: const Offset(0.0, 0.75),
                        ),
                      ],
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: width * 0.15),
                  ),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              ),
            ),
          );
        },
      ),
    );
  }
}
