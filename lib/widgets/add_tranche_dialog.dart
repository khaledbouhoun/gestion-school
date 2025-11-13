import 'package:al_moiin/mixins/quran.dart';
import 'package:al_moiin/models/student.dart';
import 'package:al_moiin/view_models/tranche_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class AddTrancheDialog extends StatefulWidget{
  const AddTrancheDialog({super.key});
  @override
  State<StatefulWidget> createState() => AddTrancheDialogPage();

  static showAddDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AddTrancheDialog();
        });
  }
}

class AddTrancheDialogPage extends State<AddTrancheDialog> with Quran{

  TextEditingController observation = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    observation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer2<TrancheViewModel, SystemViewModel>(
          builder: (context, trancheProvider, systemProvider, child){
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                child: Container(
                  width: width * 0.6,
                  child: Column(
                    children: [
                      Center(child: Text('قسط جديد', style: TextStyle(fontSize: width * 0.055, fontWeight: FontWeight.bold),),),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('التلميذ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            height: width * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: trancheProvider.newTranche!.TRCELV,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? student) async {
                                trancheProvider.newTranche!.TRCELV = student!;
                                trancheProvider.notifyListeners();
                              },
                              items: trancheProvider.students?.map<DropdownMenuItem<String>>((Student student) {
                                return DropdownMenuItem<String>(
                                  value: student.elvno,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Container(
                                      width: width * 0.8,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      child: Text('${student.elvnom} ${student.elvprenom}', style: TextStyle(fontSize: width * 0.035, color: Colors.black,),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: width * 0.03,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('من', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                              Container(
                                width: width * 0.3,
                                height: width * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  value: trancheProvider.newTranche?.TRCSOURADE?.round().toString(),
                                  underline: Container(),
                                  isExpanded: true,
                                  onChanged: (String? sura) async {
                                    trancheProvider.newTranche?.TRCAYADE = 1;
                                    trancheProvider.newTranche?.TRCSOURADE = double.parse(sura!);
                                    trancheProvider.notifyListeners();
                                  },
                                  items: surat.map<DropdownMenuItem<String>>((Map sura) {
                                    return DropdownMenuItem<String>(
                                      value: sura[sura.keys.first],
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Container(
                                          width: width * 0.3,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(15))
                                          ),
                                          child: Text(sura['name'], style: TextStyle(fontSize: width * 0.035, color: Colors.black,),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),

                              ),
                              Container(
                                width: width * 0.15,
                                height: width * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: DropdownButton<double>(
                                  value: trancheProvider.newTranche!.TRCAYADE,
                                  underline: Container(),
                                  isExpanded: true,
                                  onChanged: (double? aya) async {
                                    trancheProvider.newTranche?.TRCAYADE = aya;
                                    trancheProvider.notifyListeners();
                                  },
                                  items: ayat?.where((element) => element['AYASOURA'] == trancheProvider.newTranche?.TRCSOURADE).map<DropdownMenuItem<double>>((Map aya) {
                                    return DropdownMenuItem<double>(
                                      value: double.parse(aya['AYANO'].toString()),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Container(
                                          width: width * 0.15,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(15))
                                          ),
                                          child: Text(aya['AYANO'].toString(), style: TextStyle(fontSize: width * 0.035, color: Colors.black,),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),

                              ),
                            ],
                          ),
                          SizedBox(height: width * 0.03,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('إلى', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                              Container(
                                width: width * 0.3,
                                height: width * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  value: trancheProvider.newTranche?.TRCSOURAA?.round().toString(),
                                  underline: Container(),
                                  isExpanded: true,
                                  onChanged: (String? sura) async {
                                    trancheProvider.newTranche?.TRCAYAA = 1;
                                    trancheProvider.newTranche?.TRCSOURAA = double.parse(sura!);
                                    trancheProvider.notifyListeners();
                                  },
                                  items: surat.map<DropdownMenuItem<String>>((Map sura) {
                                    return DropdownMenuItem<String>(
                                      value: sura[sura.keys.first],
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Container(
                                          width: width * 0.3,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(15))
                                          ),
                                          child: Text(sura['name'], style: TextStyle(fontSize: width * 0.035, color: Colors.black,),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),

                              ),
                              Container(
                                width: width * 0.15,
                                height: width * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: DropdownButton<double>(
                                  value: trancheProvider.newTranche!.TRCAYAA,
                                  underline: Container(),
                                  isExpanded: true,
                                  onChanged: (double? aya) async {
                                    trancheProvider.newTranche?.TRCAYAA = aya;
                                    trancheProvider.notifyListeners();
                                  },
                                  items: ayat?.where((element) => element['AYASOURA'] == trancheProvider.newTranche?.TRCSOURAA).map<DropdownMenuItem<double>>((Map aya) {
                                    return DropdownMenuItem<double>(
                                      value: double.parse(aya['AYANO'].toString()),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Container(
                                          width: width * 0.15,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(15))
                                          ),
                                          child: Text(aya['AYANO'].toString(), style: TextStyle(fontSize: width * 0.035, color: Colors.black,),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: width * 0.03,),

                          const Text('الإتجاه', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            height: width * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: DropdownButton<double>(
                              value: trancheProvider.newTranche?.TRCSENS,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (double? sense) async {
                                trancheProvider.newTranche?.TRCSENS = sense!;
                                trancheProvider.notifyListeners();
                              },
                              items: trancheProvider.types?.map<DropdownMenuItem<double>>((Map sense) {
                                return DropdownMenuItem<double>(
                                  value: double.parse(sense.keys.first.toString()),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Container(
                                      width: width * 0.8,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      child: Text(sense[sense.keys.first], style: TextStyle(fontSize: width * 0.035, color: Colors.black,),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                          ),
                          SizedBox(height: width * 0.03,),

                          const Text('الملاحظة', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            width: width,
                            height: width * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color.fromRGBO(10, 107, 77, 1.0)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: observation,
                              maxLines: 3,
                              maxLength: 100,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                            ),
                          ),
                          SizedBox(height: width * 0.03),

                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(Theme.of(context).secondaryHeaderColor),
                                  padding: MaterialStateProperty.all(EdgeInsets.zero)
                              ),
                              onPressed: () async {await addNewTranche(context);},
                              child: trancheProvider.addStatusCode != 0 ? Text("موافق", style: TextStyle(fontSize: width * 0.05, color: Colors.white, fontWeight: FontWeight.bold),) : const CircularProgressIndicator(color: Colors.white,),
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future<void> addNewTranche(BuildContext context) async {
    var trancheProvider = Provider.of<TrancheViewModel>(context, listen: false);
    if(trancheProvider.newTranche?.TRCSENS == 1 && (trancheProvider.newTranche!.TRCSOURADE! < trancheProvider.newTranche!.TRCSOURAA!)){
      Toast(context: context, title: 'الإتجاه صعودا سورة البداية أصغر من سورة النهاية!', style: ToastificationStyle.minimal, type: ToastificationType.warning, duration: 3);
    }else if(trancheProvider.newTranche?.TRCSENS == 2 && (trancheProvider.newTranche!.TRCSOURADE! > trancheProvider.newTranche!.TRCSOURAA!)){
      Toast(context: context, title: 'الإتجاه نزولا سورة البداية أكبر من سورة النهاية!', style: ToastificationStyle.minimal, type: ToastificationType.warning, duration: 3);
    }else if((trancheProvider.newTranche!.TRCSOURADE! == trancheProvider.newTranche!.TRCSOURAA!) && (trancheProvider.newTranche!.TRCAYADE! > trancheProvider.newTranche!.TRCAYAA!)){
      Toast(context: context, title: 'يرجى اختيار رقم صحيح لآية النهاية!', style: ToastificationStyle.minimal, type: ToastificationType.warning, duration: 3);
    }else{
      trancheProvider.newTranche!.TRCOBS = observation.text;
      await trancheProvider.addTranche();
      if(trancheProvider.addStatusCode == 201){
        Toast(context: context, title: 'تمت الإضافة بنجاح', style: ToastificationStyle.minimal, type: ToastificationType.success);
        Navigator.pop(context);
        trancheProvider.getTranches();
      }else{
        Toast(context: context, title: 'تعذر الإتصال بالخادم', style: ToastificationStyle.minimal, type: ToastificationType.error);
      }
    }
  }
}