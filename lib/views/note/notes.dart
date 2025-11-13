import 'package:al_moiin/home.dart';
import 'package:al_moiin/models/evaluation.dart';
import 'package:al_moiin/models/period.dart';
import 'package:al_moiin/view_models/note_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/widgets/add_note_dialog.dart';
import 'package:al_moiin/widgets/note_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../models/class.dart';
import '../../models/module.dart';
import '../../models/note.dart';
import '../../view_models/auth_view_model.dart';
import '../../widgets/toast.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<StatefulWidget> createState() => NotesPage();
}

class NotesPage extends State<Notes> {
  @override
  void initState() {
    super.initState();
    final noteProvider = Provider.of<NoteViewModel>(context, listen: false);
    noteProvider.initFunction();

    // }
  }

  @override
  Widget build(BuildContext context) {
    // var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    // var noteProvider = Provider.of<NoteViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.push(context, MaterialPageRoute(builder: (builder) => const Home()));
          return false;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: _appBar(context, width, height),
          body: SizedBox(
            width: width,
            height: height,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _HeaderSection(width: width, height: height),
                ),
                _NotesSliverList(width: width, height: height),
              ],
            ),
          ),
          // floatingActionButton: _AddNoteButton(width: width),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
}

PreferredSizeWidget _appBar(BuildContext context, double width, double height) {
  return AppBar(
    toolbarHeight: height * 0.1,
    automaticallyImplyLeading: false,
    elevation: 6,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    flexibleSpace: Container(color: Theme.of(context).secondaryHeaderColor),
    title: Text(
      'العلامات',
      style: TextStyle(
        color: Colors.white,
        fontSize: width * 0.07,
        fontWeight: FontWeight.bold,
        shadows: [Shadow(color: Colors.black.withOpacity(0.3), offset: const Offset(2, 2), blurRadius: 4)],
      ),
    ),
    actions: [
      Consumer2<AuthViewModel, NoteViewModel>(
        builder: (context, auth, note, child) {
          bool isEnabledAnneAndPeriod = auth.selectedYear?.ANECLOSE == 0 && note.selectedPeriod?.ANPCLOSE == 0;
          bool isEnabled = note.statueButtonSave;
          return InkWell(
            onTap: isEnabled && isEnabledAnneAndPeriod ? () async => await note.saveAllChanges(context) : null,
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: width * 0.3,
              height: width * 0.1,
              margin: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: 6),
              decoration: BoxDecoration(
                gradient: isEnabled && isEnabledAnneAndPeriod
                    ? const LinearGradient(
                        colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(colors: [Color(0xFFB9B9B9), Color(0xFF8E8E8E)]),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: isEnabled && isEnabledAnneAndPeriod ? Colors.blue.withOpacity(0.4) : Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: note.isLoadingStatusButton
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(
                        isEnabledAnneAndPeriod ? 'حفظ' : 'فصل مغلق',
                        style: TextStyle(color: Colors.white, fontSize: width * 0.045, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
              ),
            ),
          );
        },
      ),
    ],
  );
}

// Separate widget for header to isolate rebuilds
class _HeaderSection extends StatelessWidget {
  final double width;
  final double height;

  const _HeaderSection({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width * 0.55,
      padding: EdgeInsets.all(width * 0.02),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Theme.of(context).secondaryHeaderColor, blurRadius: 30.0, offset: const Offset(0.0, 0.75))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PeriodDropdown(width: width),
          _ClassDropdown(width: width),
          _ModuleDropdown(width: width),
          _EvaluationDropdown(width: width),
          _ListHeader(width: width),
        ],
      ),
    );
  }
}

// Period dropdown - only rebuilds when periods change
class _PeriodDropdown extends StatelessWidget {
  final double width;

  const _PeriodDropdown({required this.width});

  @override
  Widget build(BuildContext context) {
    final systemProvider = context.watch<SystemViewModel>();
    final noteProvider = context.read<NoteViewModel>();

    return SizedBox(
      width: width * 0.65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الفصل',
            style: TextStyle(color: Colors.white, fontSize: width * 0.05, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.009),
            width: width * 0.45,
            height: width * 0.1,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: DropdownButton<Period>(
              value: context.select<NoteViewModel, Period?>((vm) => vm.selectedPeriod),
              underline: Container(),
              isExpanded: true,
              onChanged: (Period? period) async {
                await noteProvider.resetNotes();
                noteProvider.selectedPeriod = period;
                await noteProvider.getNotes();
              },
              items: systemProvider.periods!.map<DropdownMenuItem<Period>>((Period period) {
                return DropdownMenuItem<Period>(
                  value: period,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      padding: EdgeInsets.only(left: width * 0.02),
                      width: width * 0.35,
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Text(
                        period.PERNOM,
                        style: TextStyle(fontSize: width * 0.04, color: Colors.black, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Class dropdown - only rebuilds when classes change
class _ClassDropdown extends StatelessWidget {
  final double width;

  const _ClassDropdown({required this.width});

  @override
  Widget build(BuildContext context) {
    final systemProvider = context.watch<SystemViewModel>();
    final noteProvider = context.read<NoteViewModel>();

    return SizedBox(
      width: width * 0.65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الفوج',
            style: TextStyle(color: Colors.white, fontSize: width * 0.05, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.009),
            width: width * 0.45,
            height: width * 0.1,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: DropdownButton<Class>(
              value: context.select<NoteViewModel, Class?>((vm) => vm.selectedClass),
              underline: Container(),
              isExpanded: true,
              onChanged: (Class? selectedClass) async {
                noteProvider.selectedClass = selectedClass;
                noteProvider.selectedModule = null;
                // noteProvider.selectedEvaluation = null;

                await noteProvider.resetNotes();
                await noteProvider.getModules();
                await noteProvider.getModulesGroups();
                // notifyListeners() removed; not needed here
              },
              items: systemProvider.classes?.map<DropdownMenuItem<Class>>((Class selectedClass) {
                return DropdownMenuItem<Class>(
                  value: selectedClass,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      padding: EdgeInsets.only(left: width * 0.02),
                      width: width * 0.4,
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Text(
                        selectedClass.CLSNOM,
                        style: TextStyle(fontSize: width * 0.04, color: Colors.black, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Module dropdown - only rebuilds when modules change
class _ModuleDropdown extends StatelessWidget {
  final double width;

  const _ModuleDropdown({required this.width});

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.read<NoteViewModel>();

    return SizedBox(
      width: width * 0.65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المادة',
            style: TextStyle(color: Colors.white, fontSize: width * 0.05, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.009),
            width: width * 0.45,
            height: width * 0.1,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Selector<NoteViewModel, List<Module>?>(
              selector: (_, vm) => vm.modules,
              builder: (context, modules, _) {
                return DropdownButton<Module>(
                  value: context.select<NoteViewModel, Module?>((vm) => vm.selectedModule),
                  underline: Container(),
                  isExpanded: true,
                  onChanged: (Module? selectedModule) async {
                    noteProvider.selectedModule = selectedModule;
                    noteProvider.selectedEvaluation = null;
                    await noteProvider.resetNotes();
                    await noteProvider.getEvaluations();
                    // notifyListeners() removed; not needed here
                  },
                  items: modules?.map<DropdownMenuItem<Module>>((Module selectedModule) {
                    return DropdownMenuItem<Module>(
                      value: selectedModule,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          padding: EdgeInsets.only(left: width * 0.02),
                          width: width * 0.37,
                          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: Text(
                            selectedModule.MATNOM,
                            style: TextStyle(fontSize: width * 0.04, color: Colors.black, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Evaluation dropdown - only rebuilds when evaluations change
class _EvaluationDropdown extends StatelessWidget {
  final double width;

  const _EvaluationDropdown({required this.width});

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.read<NoteViewModel>();

    return SizedBox(
      width: width * 0.65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التقييم',
            style: TextStyle(color: Colors.white, fontSize: width * 0.05, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.009),
            width: width * 0.45,
            height: width * 0.1,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Selector<NoteViewModel, List<Evaluation>?>(
              selector: (_, vm) => vm.evaluations,
              builder: (context, evaluations, _) {
                return DropdownButton<Evaluation>(
                  value: context.select<NoteViewModel, Evaluation?>((vm) => vm.selectedEvaluation),
                  underline: Container(),
                  isExpanded: true,
                  onChanged: (Evaluation? selectedEvaluation) async {
                    noteProvider.selectedEvaluation = selectedEvaluation;
                    await noteProvider.getNotes();
                    // notifyListeners() removed; not needed here
                  },
                  items: evaluations?.map<DropdownMenuItem<Evaluation>>((Evaluation selectedEvaluation) {
                    return DropdownMenuItem<Evaluation>(
                      value: selectedEvaluation,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          padding: EdgeInsets.only(left: width * 0.02),
                          width: width * 0.37,
                          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: Text(
                            selectedEvaluation.EVANOM,
                            style: TextStyle(fontSize: width * 0.04, color: Colors.black, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ListHeader extends StatelessWidget {
  final double width;

  const _ListHeader({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 13,
            child: Text(
              'التلميذ',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.045),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              'العلامة',
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.045),
            ),
          ),
        ],
      ),
    );
  }
}

// Notes list section as a sliver for scrollable header hiding
class _NotesSliverList extends StatelessWidget {
  final double width;
  final double height;

  const _NotesSliverList({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Selector<NoteViewModel, int?>(
      selector: (_, vm) => vm.bodyStatuesCode,
      builder: (context, bodyStatuesCode, _) {
        final noteProvider = context.read<NoteViewModel>();

        if (bodyStatuesCode == 200) {
          return Selector<NoteViewModel, int>(
            selector: (_, vm) => vm.notes?.length ?? 0,
            builder: (context, notesLength, _) {
              final notes = noteProvider.notes;
              return SliverPadding(
                padding: EdgeInsets.only(bottom: width * 0.02, right: width * 0.02, left: width * 0.02),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final note = notes![index];
                    return NoteWidget(key: ValueKey(note.NOTELV), note: note);
                  }, childCount: notesLength),
                ),
              );
            },
          );
        } else if (bodyStatuesCode == 404) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text('لا توجد مواد متاحة', style: TextStyle(fontSize: width * 0.05)),
            ),
          );
        } else if (bodyStatuesCode == 0) {
          return const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator()));
        } else {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('تعذر الإتصال بالخادم', style: TextStyle(fontSize: width * 0.05)),
                SizedBox(height: height * 0.02),
                ElevatedButton(
                  style: ButtonStyle(padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
                  onPressed: () async {
                    await noteProvider.getNotes();
                  },
                  child: Container(
                    padding: EdgeInsets.all(width * 0.03),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Text(
                      'حاول مجددا',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

// Add note button - only rebuilds when necessary conditions change
class _AddNoteButton extends StatelessWidget {
  final double width;

  const _AddNoteButton({required this.width});

  @override
  Widget build(BuildContext context) {
    // Removed unused variable authProvider
    final noteProvider = context.read<NoteViewModel>();

    return Selector2<AuthViewModel, NoteViewModel, bool>(
      selector: (_, auth, note) => auth.selectedYear?.ANECLOSE == 0 && note.selectedPeriod?.ANPCLOSE == 0,
      builder: (context, isEnabled, _) {
        return TextButton(
          style: const ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
          ),
          onPressed: () async {
            if (isEnabled) {
              await noteProvider.getStudentsWithoutEvaluation();
              if (noteProvider.students?.length == 0) {
                Toast(
                  context: context,
                  title: 'جميع التلاميذ لديهم علامات في ${noteProvider.selectedEvaluation!.EVANOM}',
                  style: ToastificationStyle.minimal,
                  type: ToastificationType.info,
                );
                return;
              }
              noteProvider.newNote = Note();
              noteProvider.newNote?.NOTELV = noteProvider.students?.first.elvno;
              noteProvider.newNote?.NOTANE = noteProvider.selectedClass!.CLSANE;
              noteProvider.newNote?.NOTPER = noteProvider.selectedPeriod!.PERNO;
              noteProvider.newNote?.NOTCYC = noteProvider.selectedClass!.CLSCYC;
              noteProvider.newNote?.NOTNIV = noteProvider.selectedClass!.CLSNIV;
              noteProvider.newNote?.NOTCLS = noteProvider.selectedClass!.CLSNO;
              noteProvider.newNote?.NOTSPC = noteProvider.selectedClass!.CLSSPC;
              noteProvider.newNote?.NOTMAT = noteProvider.selectedModule!.MATNO;
              noteProvider.newNote?.NOTEVA = noteProvider.selectedEvaluation!.EVANO;
              AddNoteDialog.showAddDialog(context);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isEnabled ? Theme.of(context).secondaryHeaderColor : Colors.grey,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isEnabled ? Theme.of(context).secondaryHeaderColor : Colors.grey,
                  blurRadius: 20.0,
                  offset: const Offset(0.0, 0.75),
                ),
              ],
            ),
            child: Icon(Icons.add, color: Colors.white, size: width * 0.15),
          ),
        );
      },
    );
  }
}
