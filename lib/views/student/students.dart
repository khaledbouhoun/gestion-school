import 'package:al_moiin/home.dart';
import 'package:al_moiin/models/period.dart';
import 'package:al_moiin/view_models/student_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/widgets/student_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/class.dart';

class Students extends StatefulWidget{
  const Students({super.key});

  @override
  State<StatefulWidget> createState() => StudentsPage();

}

class StudentsPage extends State<Students>{

  @override
  void initState() {
    super.initState();
    var studentProvider = Provider.of<StudentViewModel>(context, listen: false);
    var systemProvider = Provider.of<SystemViewModel>(context, listen: false);
    studentProvider.getStudents(systemProvider.selectedClass!, systemProvider.selectedPeriod!);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
        child: Consumer2<StudentViewModel, SystemViewModel>(
          builder: (context, studentProvider, systemProvider, child){
              return WillPopScope(
                onWillPop: () async {Navigator.push(context, MaterialPageRoute(builder: (builder) => const Home())); return false;},
                child: RefreshIndicator(
                  onRefresh: () async {
                    studentProvider.getStudents(systemProvider.selectedClass!, systemProvider.selectedPeriod!);
                    },
                  child: Scaffold(
                    backgroundColor: Theme.of(context).primaryColor,
                    appBar: AppBar(
                      toolbarHeight: height * 0.055,
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                      automaticallyImplyLeading: false,
                      title: Center(child: Text('قائمة التلاميذ', style: TextStyle(color: Colors.white, fontSize: width * 0.07, fontWeight: FontWeight.bold),),),
                    ),
                    body: Container(
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
                                        width: width * 0.5,
                                        height: width * 0.1,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: DropdownButton<Period>(
                                          value: systemProvider.selectedPeriod,
                                          underline: Container(),
                                          isExpanded: true,
                                          onChanged: (Period? period) {
                                            systemProvider.selectedPeriod = period;
                                            systemProvider.notifyListeners();
                                            studentProvider.getStudents(systemProvider.selectedClass!, systemProvider.selectedPeriod!);
                                          },
                                          items: systemProvider.periods!.map<DropdownMenuItem<Period>>((Period period) {
                                            return DropdownMenuItem<Period>(
                                              value: period,
                                              child: Directionality(
                                                textDirection: TextDirection.rtl,
                                                child: Container(
                                                  padding: EdgeInsets.only(left: width * 0.02),
                                                  width: width * 0.37,
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
                                Row(
                                  children: [
                                    Container(
                                      width : width * 0.65,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('الفوج', style: TextStyle(color: Colors.white, fontSize: width * 0.05, fontWeight: FontWeight.bold),),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: width * 0.009),
                                            width: width * 0.5,
                                            height: width * 0.1,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),
                                            child: DropdownButton<Class>(
                                              value: systemProvider.selectedClass,
                                              underline: Container(),
                                              isExpanded: true,
                                              onChanged: (Class? selectedClass) {
                                                systemProvider.selectedClass = selectedClass;
                                                systemProvider.notifyListeners();
                                                studentProvider.getStudents(systemProvider.selectedClass!, systemProvider.selectedPeriod!);
                                              },
                                              items: systemProvider.classes?.map<DropdownMenuItem<Class>>((Class selectedClass) {
                                                return DropdownMenuItem<Class>(
                                                  value: selectedClass,
                                                  child: Directionality(
                                                    textDirection: TextDirection.rtl,
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: width * 0.02),
                                                      width: width * 0.37,
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
                                    Expanded(
                                        child: Text('${studentProvider.filtredStudent?.length}', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: width * 0.07, fontWeight: FontWeight.bold),)
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: studentProvider.statusCode == 200 ? Container(
                              padding: EdgeInsets.only(bottom: width * 0.02, right: width * 0.02, left: width * 0.02,),
                              child: ListView.builder(
                                  itemCount: studentProvider.filtredStudent?.length,
                                  itemBuilder: (context, index){
                                    return StudentWidget(student: studentProvider.filtredStudent![index]);
                                  }
                              ),)
                            : studentProvider.statusCode == 404 ? Center(child: Text('لا يوجد تلاميذ متاحون', style: TextStyle(fontSize: width * 0.05),),)
                                : studentProvider.statusCode == 0 ? const Center(child: CircularProgressIndicator())
                                : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('تعذر الإتصال بالخادم', style: TextStyle(fontSize: width * 0.05),),
                                SizedBox(height: height * 0.02,),
                                ElevatedButton(
                                  style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
                                  onPressed: (){
                                    studentProvider.getStudents(systemProvider.selectedClass!, systemProvider.selectedPeriod!);
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
                  ),
                ),
              );
          },
        ),
    );
  }
}