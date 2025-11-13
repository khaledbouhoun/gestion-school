import 'package:al_moiin/models/student.dart';
import 'package:al_moiin/view_models/note_view_model.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class AddNoteDialog extends StatefulWidget{
  const AddNoteDialog({super.key});
  @override
  State<StatefulWidget> createState() => AddNoteDialogPage();

  static showAddDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AddNoteDialog();
        });
  }
}

class AddNoteDialogPage extends State<AddNoteDialog>{

  TextEditingController note = TextEditingController();
  TextEditingController observation = TextEditingController();


  @override
  void dispose() {
    note.dispose();
    observation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer<NoteViewModel>(
          builder: (context, noteProvider, child){
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                child: Container(
                  width: width * 0.6,
                  child: Column(
                    children: [
                      Center(child: Text('علامة جديدة', style: TextStyle(fontSize: width * 0.055, fontWeight: FontWeight.bold),),),
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
                              value: noteProvider.newNote?.NOTELV,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? student) async {
                                noteProvider.newNote!.NOTELV = student!;
                                noteProvider.notifyListeners();
                              },
                              items: noteProvider.students?.map<DropdownMenuItem<String>>((Student student) {
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

                          const Text('العلامة', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            width: width,
                            height: width * 0.1,
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: note,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                            ),
                          ),
                          SizedBox(height: width * 0.03,),

                          const Text('الملاحظة', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            width: width,
                            height: width * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
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
                              onPressed: () async {await addNote(context);},
                              child: noteProvider.addNoteStatusCode != 0 ? Text("موافق", style: TextStyle(fontSize: width * 0.05, color: Colors.white, fontWeight: FontWeight.bold),) : const CircularProgressIndicator(color: Colors.white,),
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

  Future<void> addNote(BuildContext context) async {
    var noteProvider = Provider.of<NoteViewModel>(context, listen: false);
    if(noteProvider.newNote?.NOTELV == null){
      Toast(context: context, title: 'يرجى اختيار التلميذ', style: ToastificationStyle.minimal, type: ToastificationType.error);
    }else if(note.text == ''){
      Toast(context: context, title: 'يرجى إدخال العلامة', style: ToastificationStyle.minimal, type: ToastificationType.error);
    }else if(double.parse(note.text) > noteProvider.selectedClass!.ANVMOYSUR){
      Toast(context: context, title: 'يجب أن لا تتعدى العلامة ${noteProvider.selectedClass!.ANVMOYSUR.round()}', style: ToastificationStyle.minimal, type: ToastificationType.error);
    }else{
      noteProvider.newNote!.NOTVALEUR = double.parse(note.text);
      noteProvider.newNote!.SEMOBSERV = observation.text;
      // await noteProvider.addNotes();
      if(noteProvider.addNoteStatusCode == 201){
        Toast(context: context, title: 'تمت الإضافة بنجاح', style: ToastificationStyle.minimal, type: ToastificationType.success);
        Navigator.pop(context);
        noteProvider.getNotes();
      }else if(noteProvider.addNoteStatusCode == 409){
        Toast(context: context, title: 'تمت وضع العلامة لهذا التلميذ مسبقا', style: ToastificationStyle.minimal, type: ToastificationType.error);
      }else{
        Toast(context: context, title: 'تعذر الإتصال بالخادم', style: ToastificationStyle.minimal, type: ToastificationType.error);
      }
    }
  }
}