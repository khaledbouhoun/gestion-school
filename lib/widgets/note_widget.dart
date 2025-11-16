import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/view_models/note_view_model.dart';
import 'package:al_moiin/widgets/modify_group_observation_dialog.dart';
import 'package:al_moiin/widgets/modify_note_dialog.dart';
import 'package:al_moiin/widgets/delete_warning_dialog.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../models/note.dart';

class NoteWidget extends StatefulWidget {
  final Note note;
  // final FocusNode nextFocusNode;
  const NoteWidget({super.key, required this.note});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  @override
  void initState() {
    super.initState();
    // Add listener to save on focus change
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return ExpandableNotifier(
      child: Container(
        width: width,
        padding: EdgeInsets.all(width * 0.02),
        margin: EdgeInsets.only(top: width * 0.02),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ScrollOnExpand(
          scrollOnExpand: true,
          scrollOnCollapse: false,
          child: ExpandablePanel(
            header: _NoteHeader(note: widget.note, width: width),
            collapsed: Container(),
            expanded: _NoteExpanded(note: widget.note, width: width),
          ),
        ),
      ),
    );
  }
}

// Separate widget for the header to prevent unnecessary rebuilds
class _NoteHeader extends StatelessWidget {
  final Note note;
  final double width;

  const _NoteHeader({required this.note, required this.width});

  @override
  Widget build(BuildContext context) {
    // Only read provider once without listening
    final noteProvider = context.read<NoteViewModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            '${note.ELVNOM} ${note.ELVPRENOM}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: width * 0.045),
          ),
        ),
        Expanded(
          flex: 2,
          child: _NoteTextField(note: note, width: width),
        ),
      ],
    );
  }
}

// Optimized TextField that doesn't trigger page rebuilds
class _NoteTextField extends StatefulWidget {
  final Note note;
  final double width;

  const _NoteTextField({required this.note, required this.width});

  @override
  State<_NoteTextField> createState() => _NoteTextFieldState();
}

class _NoteTextFieldState extends State<_NoteTextField> {
  Color _getBorderColor(BuildContext context, double? value) {
    if (value == null) return Colors.grey;
    final noteProvider = context.read<NoteViewModel>();
    final threshold = noteProvider.selectedClass!.ANVMOYSUR / 2;
    return value >= threshold ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _getBorderColor(context, widget.note.NOTVALEUR);
    final noteProvider = Provider.of<NoteViewModel>(context, listen: false);
    final maxValue = noteProvider.selectedClass?.ANVMOYSUR ?? 0;

    return TextField(
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      controller: widget.note.controller,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}(\.\d{0,2})?$'))],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: widget.width * 0.01),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: borderColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: borderColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: borderColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: '--',
        hintStyle: TextStyle(fontSize: 18, color: Colors.grey[400], fontWeight: FontWeight.bold),
        errorText: (widget.note.NOTVALEUR != null && widget.note.NOTVALEUR! > maxValue) ? 'أكبر من الحد المسموح ($maxValue)' : null,
      ),
      style: TextStyle(color: borderColor, fontWeight: FontWeight.w800, fontSize: 22, fontFamily: 'arial'),
      onChanged: (val) {
        print('note valeur : ${widget.note.NOTVALEUR ?? 'null'}');
        double? parsedVal = double.tryParse(val);
        if (val.isNotEmpty && parsedVal != null && parsedVal > maxValue) {
          Toast(
            context: context,
            title: 'القيمة المدخلة أكبر من الحد المسموح به ($maxValue)',
            style: ToastificationStyle.minimal,
            type: ToastificationType.warning,
          );
          widget.note.NOTVALEUR = null;
          noteProvider.statueButtonSaveFunction();
          noteProvider.notifyListeners();
          return;
        }
        setState(() {
          widget.note.NOTVALEUR = val.isEmpty ? null : parsedVal;
          noteProvider.statueButtonSaveFunction();
        });

        noteProvider.notifyListeners();
      },
      onSubmitted: (val) {
        double? parsedVal = double.tryParse(val);
        if (val.isEmpty || parsedVal == null) {
          setState(() {
            widget.note.NOTVALEUR = null;
          });
        }
        noteProvider.notifyListeners();
      },
    );
  }
}

// Separate widget for expanded content
class _NoteExpanded extends StatelessWidget {
  final Note note;
  final double width;

  const _NoteExpanded({required this.note, required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ActionButtons(note: note, width: width),
        _ObservationText(note: note, width: width),
      ],
    );
  }
}

// Action buttons that only check specific conditions
class _ActionButtons extends StatelessWidget {
  final Note note;
  final double width;

  const _ActionButtons({required this.note, required this.width});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthViewModel>();
    final noteProvider = context.read<NoteViewModel>();
    final isEnabled = authProvider.selectedYear!.ANECLOSE == 0 && noteProvider.selectedPeriod!.ANPCLOSE == 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Tooltip(
          message: 'تغيير ملاحظة المجموعة',
          child: IconButton(
            onPressed: () async {
              noteProvider.selectedStudentForObservation = note.NOTELV;
              await noteProvider.getStudentGroupObservation();
              if (noteProvider.studentGroupObservationStatusCode != 200 && noteProvider.studentGroupObservationStatusCode != 404) {
                return;
              }
              ModifyGroupObservationDialog.showModifyDialog(context);
            },
            icon: Icon(Icons.edit_note_rounded, size: width * 0.08, color: const Color.fromRGBO(225, 179, 18, 1.0)),
          ),
        ),
        Tooltip(
          message: 'تغيير علامة و ملاحظة المادة',
          child: IconButton(
            onPressed: () async {
              if (isEnabled) {
                // noteProvider.modifiedNote = Note.modified(note.toJson());
                var response = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ModifyNoteDialog(obsrvationtext: note.SEMOBSERV);
                  },
                );
                print("response : $response");
                if (response != null && response is String && response.isNotEmpty) {
                  note.SEMOBSERV = response;
                  noteProvider.statueButtonSaveFunction();
                  // Use a public method to notify listeners if needed
                  // If you have a public update method, use it here instead
                  // noteProvider.updateObservation(note, response[0]);
                }
              }
            },
            icon: Icon(Icons.edit_rounded, color: isEnabled ? const Color.fromRGBO(225, 179, 18, 1.0) : Colors.grey),
          ),
        ),
        Tooltip(
          message: 'حذف النقطة و العلامة',
          child: IconButton(
            onPressed: () {
              if (isEnabled) {
                DeleteWarningDialog.showDeleteWarningDialog(context, () async {
                  await noteProvider.deleteNote(note);
                  if (noteProvider.deleteNoteStatusCode == 200) {
                    Toast(context: context, title: 'تمت الحذف بنجاح', style: ToastificationStyle.minimal, type: ToastificationType.success);
                    Navigator.pop(context);
                    await noteProvider.getNotes();
                  } else {
                    Toast(
                      context: context,
                      title: 'تعذر الإتصال بالخادم',
                      style: ToastificationStyle.minimal,
                      type: ToastificationType.error,
                    );
                  }
                });
              }
            },
            icon: Icon(Icons.remove_circle_rounded, color: isEnabled ? Colors.red : Colors.grey),
          ),
        ),
      ],
    );
  }
}

class _ObservationText extends StatelessWidget {
  final Note note;
  final double width;

  const _ObservationText({required this.note, required this.width});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'الملاحظة: ',
            style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold, fontSize: width * 0.04),
          ),
          TextSpan(
            text: note.SEMOBSERV == '' ? 'لا توجد ملاحظة' : note.SEMOBSERV,
            style: TextStyle(color: Colors.black, fontSize: width * 0.04),
          ),
        ],
      ),
      textAlign: TextAlign.start,
    );
  }
}
