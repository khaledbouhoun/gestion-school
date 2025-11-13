import 'package:al_moiin/view_models/note_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModifyNoteDialog extends StatelessWidget {
  final String obsrvationtext;
  ModifyNoteDialog({super.key, this.obsrvationtext = ''});

  final TextEditingController observation = TextEditingController();

  @override
  Widget build(BuildContext context) {
    observation.text = obsrvationtext;

    final width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer<NoteViewModel>(
        builder: (context, noteProvider, child) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
              child: SizedBox(
                width: width * 0.6,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'تغيير الملاحظة',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: width * 0.055, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ملاحظة المادة',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: width,
                          height: width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color.fromRGBO(10, 107, 77, 1.0)),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: TextField(
                            controller: observation,
                            maxLines: 3,
                            maxLength: 100,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        SizedBox(height: width * 0.03),

                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Theme.of(context).secondaryHeaderColor),
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                            ),
                            onPressed: () {
                              Navigator.pop(context, observation.text);
                            },
                            child: noteProvider.modifyNoteStatusCode != 0
                                ? Text(
                                    "موافق",
                                    style: TextStyle(fontSize: width * 0.05, color: Colors.white, fontWeight: FontWeight.bold),
                                  )
                                : const CircularProgressIndicator(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
