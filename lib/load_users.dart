import 'package:al_moiin/login.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mixins/quran.dart';

class LoadUsers extends StatefulWidget {
  const LoadUsers({super.key});

  @override
  State<StatefulWidget> createState() => LoadUsersPage();
}

class LoadUsersPage extends State<LoadUsers> with Quran {
  void getData() async {
    Provider.of<AuthViewModel>(context, listen: false).getUsersAndFolders();
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
          return true;
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
            child: Consumer<AuthViewModel>(
              builder: (context, authProvider, child) {
                if (authProvider.statusCode == 500) {
                  return Center(
                    child: Container(
                      width: width * 0.8,
                      padding: EdgeInsets.all(width * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 5)],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline_rounded, size: width * 0.15, color: Colors.red[400]),
                          SizedBox(height: height * 0.02),
                          Text(
                            'تعذر الإتصال بالخادم',
                            style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          SizedBox(height: height * 0.03),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).secondaryHeaderColor,
                              padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: width * 0.03),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 5,
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
                if (authProvider.statusCode == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Theme.of(context).secondaryHeaderColor, strokeWidth: 3),
                        SizedBox(height: height * 0.02),
                        Text(
                          'جاري التحميل...',
                          style: TextStyle(fontSize: width * 0.04, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }
                return const Login();
              },
            ),
          ),
        ),
      ),
    );
  }
}
