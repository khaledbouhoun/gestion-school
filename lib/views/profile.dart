import 'package:al_moiin/home.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/system_view_model.dart';
import '../widgets/detail_card.dart';

class Profile extends StatelessWidget{
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    var authProvider= Provider.of<AuthViewModel>(context, listen: false);
    var systemProvider= Provider.of<SystemViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    List details = [
      {'الاسم' : authProvider.selectedUser!.USRPRENOM},
      {'اللقب' : authProvider.selectedUser!.USRNOM},
      {'اسم المستخدم' : authProvider.selectedUser!.USRLOGIN},
    ];
    return Directionality(
        textDirection: TextDirection.rtl,
        child: WillPopScope(
          onWillPop: () async { Navigator.push(context, MaterialPageRoute(builder: (builder) => const Home())); return false;},
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              title: Center(
                child: Text('الملف الشخصي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.06),),
              ),
            ),
            body: Container(
                width: width,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: width * 0.04),
                      height: height / 4,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: details.length,
                          itemBuilder: (context, index){
                            var key = details[index].keys.first;
                            return DetailCard(title: key, subtitle: details[index][key],);
                          }),
                    ),
                    Container(
                        padding: EdgeInsets.only(right: width * 0.03),
                        child: Text('الأقسام المدرسة', style: TextStyle(fontSize: width * 0.06, fontWeight: FontWeight.bold),)
                    ),
                    Expanded(
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: systemProvider.classes!.length,
                          itemBuilder: (context, index){
                            return Container(
                              decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 0.2, color: Colors.grey))
                              ),
                              child: ListTile(
                                title: Text(systemProvider.classes![index].CLSNOM, style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.05),),
                              ),
                            );
                          }),
                    ),
                  ],
                )
            ),
          ),
        )
    );
  }

}