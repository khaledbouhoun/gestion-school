import 'package:al_moiin/widgets/change_ip_dialog.dart';
import 'package:flutter/material.dart';

import 'load_users.dart';

class AskFirst extends StatelessWidget {
  const AskFirst({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
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
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: height * 0.1,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(width * 0.05),
                    child: Column(
                      children: [
                        Icon(Icons.settings_suggest_rounded, size: width * 0.15, color: Colors.white.withOpacity(0.9)),
                        SizedBox(height: height * 0.04),
                        Container(
                          padding: EdgeInsets.all(width * 0.05),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                          ),
                          child: Text(
                            "هل تريد تغيير عنوان ip و port أو المتابعة؟",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.045, color: Colors.black87, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: height * 0.15,
                  left: width * 0.1,
                  right: width * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => LoadUsers()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).secondaryHeaderColor,
                          padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: width * 0.03),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 5,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_forward, color: Colors.white, size: width * 0.05),
                            SizedBox(width: width * 0.02),
                            Text(
                              "متابعة",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: width * 0.04, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          ChangeIPDialog.showChangeDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: width * 0.03),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 5,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.settings, color: Theme.of(context).secondaryHeaderColor, size: width * 0.05),
                            SizedBox(width: width * 0.02),
                            Text(
                              "تغيير",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
  }
}
