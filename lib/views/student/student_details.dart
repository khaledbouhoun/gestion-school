import 'package:al_moiin/view_models/student_view_model.dart';
import 'package:al_moiin/views/student/students.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import '../../widgets/detail_card.dart';

class StudentDetails extends StatelessWidget {
  const StudentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var studentProvider = Provider.of<StudentViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    List details = [
      {
        'الاسم الكامل':
            '${studentProvider.selectedStudent!.elvnom} ${studentProvider.selectedStudent!.elvprenom} ${studentProvider.selectedStudent!.elvsexe == "0" ? 'بن' : 'بنت'} ${studentProvider.selectedStudent!.elvprenpere}',
      },
      {'اسم الجد': studentProvider.selectedStudent!.elvprengrpere},
      {'تاريخ الازدياد': intl.DateFormat('yyyy-MM-dd').format(studentProvider.selectedStudent!.elvdatensc!)},
      {'مكان الازدياد': studentProvider.selectedStudent!.elvlieunsc},
      {'الجنس': studentProvider.selectedStudent!.sexe},
      {'العنوان': studentProvider.selectedStudent!.elvadr1 == '' ? 'لا يوجد' : studentProvider.selectedStudent!.elvadr1},
      {'خط النقل': studentProvider.selectedStudent!.ltrnom != '' ? studentProvider.selectedStudent!.ltrnom : 'غير معني'},
    ];
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (builder) => const Students()));
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: Center(
            child: Text(
              'تفاصيل التلميذ',
              style: TextStyle(color: Colors.white, fontSize: width * 0.06, fontWeight: FontWeight.bold),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: width,
            height: height,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: details.length,
                    itemBuilder: (context, index) {
                      var key = details[index].keys.first;
                      return DetailCard(title: key, subtitle: details[index][key]);
                    },
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
