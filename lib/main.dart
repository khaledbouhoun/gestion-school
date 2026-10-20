import 'package:al_moiin/view_models/absence_view_model.dart';
import 'package:al_moiin/view_models/auth_view_model.dart';
import 'package:al_moiin/view_models/discipline_view_model.dart';
import 'package:al_moiin/view_models/license_view_model.dart';
import 'package:al_moiin/view_models/note_view_model.dart';
import 'package:al_moiin/view_models/student_view_model.dart';
import 'package:al_moiin/view_models/system_view_model.dart';
import 'package:al_moiin/view_models/tranche_view_model.dart';
import 'package:al_moiin/views/license_activation_page.dart';
import 'package:al_moiin/widgets/toast.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'ask_first.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthViewModel authViewModel = AuthViewModel();
  SystemViewModel systemViewModel = SystemViewModel(authViewModel);
  LicenseViewModel licenseViewModel = LicenseViewModel(authViewModel);
  await authViewModel.getDeviceInfo();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authViewModel),
        ChangeNotifierProvider(create: (_) => systemViewModel),
        ChangeNotifierProvider(create: (_) => licenseViewModel),
        ChangeNotifierProvider(create: (_) => StudentViewModel(authViewModel)),
        ChangeNotifierProvider(create: (_) => AbsenceViewModel(authViewModel, systemViewModel)),
        ChangeNotifierProvider(create: (_) => NoteViewModel(authViewModel)),
        ChangeNotifierProvider(create: (_) => DisciplineViewModel(authViewModel)),
        ChangeNotifierProvider(create: (_) => TrancheViewModel(authViewModel)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'المعين',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(236, 236, 241, 1.0),
        fontFamily: ArabicThemeData.font(arabicFont: ArabicFont.dinNextLTArabic),
        package: ArabicThemeData.package,
        secondaryHeaderColor: const Color.fromRGBO(21, 176, 130, 1), //light blue
        colorScheme: ColorScheme.fromSeed(seedColor: Theme.of(context).secondaryHeaderColor),
        useMaterial3: true,
      ),
      home: const Directionality(textDirection: TextDirection.rtl, child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    getIPAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final licenseViewModel = context.watch<LicenseViewModel>();
    return FutureBuilder<CheckResult>(
      future: licenseViewModel.checkActivationStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !licenseViewModel.isActivated) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!licenseViewModel.isActivated) {
          return const Directionality(textDirection: TextDirection.rtl, child: LicenseActivationPage());
        }

        return Directionality(textDirection: TextDirection.rtl, child: AskFirst());
      },
    );
  }

  Future<void> getIPAddress() async {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    authProvider.ip_address = prefs.getString('ip_address') ?? '';
    authProvider.port = prefs.getString('port') ?? '';
    authProvider.useDirectUrl = prefs.getBool('useDirectUrl') ?? false;

    Toast(
      context: context,
      title:
          'Address: ${authProvider.ip_address}'
          '\nPort: ${authProvider.useDirectUrl ? "-" : authProvider.port}'
          '\nMode: ${authProvider.useDirectUrl ? "Direct URL" : "IP + Port"}',
      style: ToastificationStyle.minimal,
      type: ToastificationType.info,
    );
  }
}
