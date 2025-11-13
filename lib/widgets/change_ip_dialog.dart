import 'package:al_moiin/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import '../view_models/auth_view_model.dart';

class ChangeIPDialog extends StatefulWidget {
  const ChangeIPDialog({super.key});
  @override
  State<StatefulWidget> createState() => ChangeIPDialogDialogPage();

  static void showChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ChangeIPDialog();
      },
    );
  }
}

class ChangeIPDialogDialogPage extends State<ChangeIPDialog> {
  TextEditingController ip = TextEditingController();
  TextEditingController port = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    ip.dispose();
    port.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    ip.text = authProvider.ip_address;
    port.text = authProvider.port;
    return AlertDialog(
      //backgroundColor: Colors.green[100],
      content: SingleChildScrollView(
        child: SizedBox(
          width: width * 0.6, //height: height * 0.75,
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                  child: Text(
                    'تغيير عنوان ip و port',
                    style: TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: width * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Adresse IP',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: width * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Theme.of(context).secondaryHeaderColor),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextFormField(
                      controller: ip,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: width * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Port',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: width * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Theme.of(context).secondaryHeaderColor),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextFormField(
                      controller: port,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: width * 0.03),

              ElevatedButton(
                onPressed: () async {
                  if (ip.text != '' || port.text != '') {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    authProvider.ip_address = ip.text;
                    authProvider.port = port.text;
                    prefs.setString('ip_address', ip.text);
                    prefs.setString('port', port.text);
                  }
                  Toast(
                    context: context,
                    title: 'Adresse ip: ${authProvider.ip_address}\nPort: ${authProvider.port}',
                    style: ToastificationStyle.minimal,
                    type: ToastificationType.info,
                  );
                  Navigator.pop(context);
                  authProvider.getUsersAndFolders();
                  authProvider.notifyListeners();
                },
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Theme.of(context).secondaryHeaderColor)),
                child: const Text(
                  'موافق',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
