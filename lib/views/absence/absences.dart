import 'package:al_moiin/home.dart';
import 'package:al_moiin/models/absence.dart';
import 'package:al_moiin/models/period.dart';
import 'package:al_moiin/view_models/absence_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/widgets/absence_widget.dart';
import 'package:al_moiin/widgets/add_absence_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import '../../models/class.dart';
import '../../view_models/auth_view_model.dart';

class Absences extends StatefulWidget{
  const Absences({super.key});

  @override
  State<StatefulWidget> createState() => AbsencesPage();

}

class AbsencesPage extends State<Absences>{

  @override
  void initState() {
    super.initState();
    var absenceProvider = Provider.of<AbsenceViewModel>(context, listen: false);
    absenceProvider.getAbsences();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer2<AbsenceViewModel, SystemViewModel>(
        builder: (context, absenceProvider, systemProvider, child){
          return WillPopScope(
            onWillPop: () async{Navigator.push(context, MaterialPageRoute(builder: (builder) => const Home())); return false;},
            child: RefreshIndicator(
              onRefresh: () async {
                absenceProvider.getAbsences();
                },
              child: Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                appBar: AppBar(
                  toolbarHeight: height * 0.055,
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  automaticallyImplyLeading: false,
                  title: Center(child: Text('الغيابات', style: TextStyle(color: Colors.white, fontSize: width * 0.07, fontWeight: FontWeight.bold),),),
                ),
                body: Container(
                  width: width,
                  height: height,
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        height: width * 0.38,
                        padding: EdgeInsets.all(width * 0.02),
                        decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).secondaryHeaderColor,
                              blurRadius: 30.0,
                              offset: const Offset(0.0, 0.75),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width : width * 0.65,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('الفصل', style: TextStyle(color: Colors.white, fontSize: width * 0.05, fontWeight: FontWeight.bold),),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: width * 0.009),
                                    width: width * 0.45,
                                    height: width * 0.1,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                    child: DropdownButton<Period>(
                                      value: absenceProvider.selectedPeriod,
                                      underline: Container(),
                                      isExpanded: true,
                                      onChanged: (Period? period) {
                                        absenceProvider.selectedPeriod = period;
                                        absenceProvider.start = absenceProvider!.selectedPeriod!.ANPDEB;
                                        absenceProvider.end = absenceProvider!.selectedPeriod!.ANPFIN;
                                        absenceProvider.notifyListeners();
                                        absenceProvider.getAbsences();
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
                                                  borderRadius: BorderRadius.all(Radius.circular(15))
                                              ),
                                              child: Text(period.PERNOM, style: TextStyle(fontSize: width * 0.04, color: Colors.black, fontWeight: FontWeight.normal,),
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
                            Container(
                              width : width * 0.65,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('الفوج', style: TextStyle(color: Colors.white, fontSize: width * 0.05, fontWeight: FontWeight.bold),),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: width * 0.009),
                                    width: width * 0.45,
                                    height: width * 0.1,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                    child: DropdownButton<Class>(
                                      value: absenceProvider.selectedClass,
                                      underline: Container(),
                                      isExpanded: true,
                                      onChanged: (Class? selectedClass) {
                                        absenceProvider.selectedClass = selectedClass;
                                        absenceProvider.notifyListeners();
                                        absenceProvider.getAbsences();
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
                                                  borderRadius: BorderRadius.all(Radius.circular(15))
                                              ),
                                              child: Text(selectedClass.CLSNOM, style: TextStyle(fontSize: width * 0.04, color: Colors.black, fontWeight: FontWeight.normal,),
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

                            //date selector
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('من', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: width * 0.05),),
                                      Container(
                                        width: width / 3,
                                        height: width * 0.1,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: (){_selectDate(context, absenceProvider.start!, 0);},
                                          child: TextField(
                                            enabled: false,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                labelStyle: TextStyle(fontSize: width * 0.045, color: Colors.black),
                                                labelText: intl.DateFormat('yyyy-MM-dd').format(absenceProvider.start!),
                                                border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('إلى', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: width * 0.05),),
                                      Container(
                                        width: width / 3,
                                        height: width * 0.1,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: (){_selectDate(context, absenceProvider.end!, 1);},
                                          child: TextField(
                                            enabled: false,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                labelStyle: TextStyle(fontSize: width * 0.045, color: Colors.black),
                                                labelText: intl.DateFormat('yyyy-MM-dd').format(absenceProvider.end!),
                                                border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: absenceProvider.statusCode == 200 ? Container(
                          padding: EdgeInsets.only(left: width * 0.02, right: width * 0.02, bottom: width * 0.02, ),
                          child: ListView.builder(
                              itemCount: absenceProvider.absences?.length,
                              itemBuilder: (context, index){
                                return AbsenceWidget(absence: absenceProvider!.absences![index],);
                              }
                          ),)
                            : absenceProvider.statusCode == 404 ? Center(child: Text('لا توجد غيابات في هذه المدة', style: TextStyle(fontSize: width * 0.05),),)
                            : absenceProvider.statusCode == 0 ? const Center(child: CircularProgressIndicator())
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('تعذر الإتصال بالخادم', style: TextStyle(fontSize: width * 0.05),),
                            SizedBox(height: height * 0.02,),
                            ElevatedButton(
                              style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
                              onPressed: (){
                                absenceProvider.getAbsences();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(width * 0.03),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).secondaryHeaderColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: const Text('حاول مجددا', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
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
                      padding: MaterialStatePropertyAll(EdgeInsets.zero),
                      overlayColor: MaterialStatePropertyAll(Colors.transparent)
                  ),
                  onPressed: (){
                    if(authProvider.selectedYear!.ANECLOSE == 0 && absenceProvider.selectedPeriod!.ANPCLOSE == 0){
                      var absenceProvider = Provider.of<AbsenceViewModel>(context, listen: false);
                      var systemProvider = Provider.of<SystemViewModel>(context, listen: false);
                      var authProvider = Provider.of<AuthViewModel>(context, listen: false);
                      absenceProvider.newAbsence = Absence();
                      absenceProvider.newAbsence?.EABANE = authProvider.selectedYear!.ANENO;
                      absenceProvider.newAbsence?.EABPER = systemProvider.selectedPeriod!.ANPPER;
                      absenceProvider.newAbsence?.EABTYPE = absenceProvider.absenceTypes.first.TABNO;
                      absenceProvider.newAbsence?.EABDATE = systemProvider.dateOfDay;
                      AddAbsenceDialog.showAddDialog(context);
                    }
                    },
                  child: Container(
                    decoration: BoxDecoration(
                      color: authProvider.selectedYear!.ANECLOSE == 0 && absenceProvider.selectedPeriod!.ANPCLOSE == 0 ? Theme.of(context).secondaryHeaderColor : Colors.grey,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: authProvider.selectedYear!.ANECLOSE == 0 && absenceProvider.selectedPeriod!.ANPCLOSE == 0 ? Theme.of(context).secondaryHeaderColor : Colors.grey,
                          blurRadius: 20.0,
                          offset: const Offset(0.0, 0.75),
                        ),
                      ],
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: width * 0.15,),
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

  Future<void> _selectDate(BuildContext context, DateTime changedDate, int type) async {
    var absenceProvider = Provider.of<AbsenceViewModel>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: changedDate,
      firstDate: DateTime(0),
      lastDate: DateTime(3000),
    );
    if(picked != null){
      if(type == 0){
        absenceProvider.start = picked;
      }else{
        absenceProvider.end = picked;
      }
      absenceProvider.getAbsences();
      absenceProvider.notifyListeners();
    }
  }
}