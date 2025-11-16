import 'package:al_moiin/home.dart';
import 'package:al_moiin/models/discipline.dart';
import 'package:al_moiin/models/discipline_type.dart';
import 'package:al_moiin/models/period.dart';
import 'package:al_moiin/view_models/discipline_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/widgets/add_discipline_dialog.dart';
import 'package:al_moiin/widgets/discipline_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/class.dart';
import '../../view_models/auth_view_model.dart';

class Disciplines extends StatefulWidget {
  const Disciplines({super.key});

  @override
  State<StatefulWidget> createState() => DisciplinesPage();
}

class DisciplinesPage extends State<Disciplines> {
  @override
  void initState() {
    super.initState();
    var disciplineProvider = Provider.of<DisciplineViewModel>(context, listen: false);
    disciplineProvider.getDisciplineTypes(selectedType: disciplineProvider.selectedType);
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer2<DisciplineViewModel, SystemViewModel>(
        builder: (context, disciplineProvider, systemProvider, child) {
          // Ensure the discipline provider has a selectedPeriod that matches
          // one of the system provider's periods. If not initialized, default
          // to the system selected period (which is an item from the periods list)
          // so the DropdownButton's value matches exactly one DropdownMenuItem.
          if (disciplineProvider.selectedPeriod == null && systemProvider.selectedPeriod != null) {
            disciplineProvider.selectedPeriod = systemProvider.selectedPeriod;
          }
          return WillPopScope(
            onWillPop: () async {
              Navigator.push(context, MaterialPageRoute(builder: (builder) => const Home()));
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                disciplineProvider.getDisciplines();
              },
              child: Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                appBar: AppBar(
                  toolbarHeight: height * 0.055,
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  automaticallyImplyLeading: false,
                  title: Center(
                    child: Text(
                      'السلوكات',
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
                        height: width * 0.47,
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
                                      value: disciplineProvider.selectedPeriod,
                                      underline: Container(),
                                      isExpanded: true,
                                      onChanged: (Period? period) {
                                        disciplineProvider.selectedPeriod = period;
                                        disciplineProvider.notifyListeners();
                                        disciplineProvider.getDisciplines();
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
                                      value: disciplineProvider.selectedClass,
                                      underline: Container(),
                                      isExpanded: true,
                                      onChanged: (Class? selectedClass) {
                                        disciplineProvider.selectedClass = selectedClass;
                                        disciplineProvider.notifyListeners();
                                        disciplineProvider.getDisciplines();
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
                            SizedBox(
                              width: width * 0.65,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'النوع',
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
                                    child: DropdownButton<String>(
                                      value: disciplineProvider.selectedType,
                                      underline: Container(),
                                      isExpanded: true,
                                      onChanged: (String? type) {
                                        disciplineProvider.selectedType = type!;
                                        disciplineProvider.notifyListeners();
                                        disciplineProvider.getDisciplineTypes(selectedType: disciplineProvider.selectedType);
                                      },
                                      items: disciplineProvider.types.map<DropdownMenuItem<String>>((String type) {
                                        return DropdownMenuItem<String>(
                                          value: type,
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
                                                type,
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
                                    'السيرة',
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
                                    child: DropdownButton<DisciplineType>(
                                      value: disciplineProvider.selectedDisciplineType,
                                      underline: Container(),
                                      isExpanded: true,
                                      onChanged: (DisciplineType? disciplinetype) {
                                        disciplineProvider.selectedDisciplineType = disciplinetype!;
                                        disciplineProvider.notifyListeners();
                                        disciplineProvider.getDisciplines();
                                      },
                                      items: disciplineProvider.disciplinesTypes?.map<DropdownMenuItem<DisciplineType>>((
                                        DisciplineType disciplinetype,
                                      ) {
                                        return DropdownMenuItem<DisciplineType>(
                                          value: disciplinetype,
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
                                                disciplinetype.DECNOM,
                                                style: TextStyle(
                                                  fontSize: width * 0.035,
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
                        child: disciplineProvider.statusCode == 200
                            ? Container(
                                padding: EdgeInsets.only(left: width * 0.02, right: width * 0.02, bottom: width * 0.02),
                                child: ListView.builder(
                                  itemCount: disciplineProvider.disciplines?.length,
                                  itemBuilder: (context, index) {
                                    return DisciplineWidget(discipline: disciplineProvider.disciplines![index]);
                                  },
                                ),
                              )
                            : disciplineProvider.statusCode == 404
                            ? Center(
                                child: Text('لا توجد إجازات/مخالفات في هذه المدة', style: TextStyle(fontSize: width * 0.05)),
                              )
                            : disciplineProvider.statusCode == 500
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('تعذر الإتصال بالخادم', style: TextStyle(fontSize: width * 0.05)),
                                  SizedBox(height: height * 0.02),
                                  ElevatedButton(
                                    style: ButtonStyle(padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
                                    onPressed: () {
                                      disciplineProvider.getDisciplines();
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
                              )
                            : disciplineProvider.statusCode == 0
                            ? Center(child: CircularProgressIndicator(color: Theme.of(context).secondaryHeaderColor))
                            : Center(child: CircularProgressIndicator(color: Theme.of(context).secondaryHeaderColor)),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: TextButton(
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  ),
                  onPressed: () {
                    if (authProvider.selectedYear!.ANECLOSE == 0 && disciplineProvider.selectedPeriod!.ANPCLOSE == 0) {
                      var disciplineProvider = Provider.of<DisciplineViewModel>(context, listen: false);
                      var systemProvider = Provider.of<SystemViewModel>(context, listen: false);
                      var authProvider = Provider.of<AuthViewModel>(context, listen: false);
                      disciplineProvider.newDiscipline = Discipline();
                      disciplineProvider.newDiscipline?.DEVANE = authProvider.selectedYear!.ANENO;
                      disciplineProvider.newDiscipline?.DEVPER = systemProvider.selectedPeriod!.ANPPER;
                      disciplineProvider.newDiscipline?.DECTYPE = disciplineProvider.types.first;
                      disciplineProvider.newDiscipline?.DEVDATE = systemProvider.dateOfDay!;
                      AddDisciplineDialog.showAddDialog(context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: authProvider.selectedYear!.ANECLOSE == 0 && disciplineProvider.selectedPeriod!.ANPCLOSE == 0
                          ? Theme.of(context).secondaryHeaderColor
                          : Colors.grey,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: authProvider.selectedYear!.ANECLOSE == 0 && disciplineProvider.selectedPeriod!.ANPCLOSE == 0
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
