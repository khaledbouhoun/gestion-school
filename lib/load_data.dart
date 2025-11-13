import 'package:al_moiin/home.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/view_models/discipline_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadData extends StatefulWidget {
  const LoadData({super.key});

  @override
  State<StatefulWidget> createState() => LoadDataPage();
}

class LoadDataPage extends State<LoadData> {
  void getData() async {
    Provider.of<AuthViewModel>(context, listen: false).getRubriques().then((value) async {
      await Provider.of<SystemViewModel>(context, listen: false).getEtablissement();
      await Provider.of<SystemViewModel>(context, listen: false).getPeriods();
      await Provider.of<SystemViewModel>(context, listen: false).getClasses();

      //Provider.of<DisciplineViewModel>(context, listen: false).getDisciplineTypes();
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
              ),
            ),
            child: Consumer3<AuthViewModel, SystemViewModel, DisciplineViewModel>(
              builder: (context, authProvider, systemProvider, disciplineProvider, child) {
                if (authProvider.statusCode == 500 ||
                    systemProvider.etablissementStatusCode == 500 ||
                    systemProvider.periodStatusCode == 500 ||
                    systemProvider.classStatusCode == 500 ||
                    disciplineProvider.disciplineTypesStatusCode == 500) {
                  return Center(
                    child: Container(
                      width: width * 0.85,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, spreadRadius: 5)],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(width * 0.04),
                            decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
                            child: Icon(Icons.wifi_off_rounded, size: width * 0.12, color: Colors.red[400]),
                          ),
                          SizedBox(height: height * 0.03),
                          Text(
                            'تعذر الإتصال بالخادم',
                            style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          SizedBox(height: height * 0.02),
                          Text(
                            'يرجى التحقق من اتصال الإنترنت الخاص بك والمحاولة مرة أخرى',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: width * 0.035, color: Colors.black54, height: 1.5),
                          ),
                          SizedBox(height: height * 0.03),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).secondaryHeaderColor,
                              padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: width * 0.035),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 3,
                            ),
                            onPressed: () {
                              getData();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.refresh_rounded, color: Colors.white),
                                SizedBox(width: width * 0.02),
                                const Text(
                                  'حاول مجددا',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (authProvider.statusCode == 0 ||
                    systemProvider.etablissementStatusCode == 0 ||
                    systemProvider.periodStatusCode == 0 ||
                    systemProvider.classStatusCode == 0 ||
                    disciplineProvider.disciplineTypesStatusCode == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(width * 0.05),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                          ),
                          child: Column(
                            children: [
                              CircularProgressIndicator(color: Theme.of(context).secondaryHeaderColor, strokeWidth: 3),
                              SizedBox(height: height * 0.03),
                              Text(
                                'الرجاء الانتظار ...',
                                style: TextStyle(fontSize: width * 0.045, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                'جاري تحميل البيانات',
                                style: TextStyle(fontSize: width * 0.035, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const Home();
              },
            ),
          ),
        ),
      ),
    );
  }
}
