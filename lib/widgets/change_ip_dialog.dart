import 'package:al_moiin/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../view_models/auth_view_model.dart';

class ChangeIPDialog extends StatefulWidget {
  const ChangeIPDialog({super.key});

  @override
  State<ChangeIPDialog> createState() => _ChangeIPDialogState();

  static void showChangeDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const ChangeIPDialog());
  }
}

class _ChangeIPDialogState extends State<ChangeIPDialog> {
  final TextEditingController ip = TextEditingController();
  final TextEditingController port = TextEditingController();

  bool useDirectUrl = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthViewModel>(context, listen: false);

      ip.text = auth.ip_address;
      port.text = auth.port;

      setState(() {
        useDirectUrl = auth.useDirectUrl;
      });
    });
  }

  @override
  void dispose() {
    ip.dispose();
    port.dispose();
    super.dispose();
  }

  Widget buildField({required String title, required TextEditingController controller, TextInputType keyboard = TextInputType.text, String? hint}) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Container(
          height: width * .15,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Theme.of(context).secondaryHeaderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboard,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final authProvider = Provider.of<AuthViewModel>(context, listen: false);

    return AlertDialog(
      content: SingleChildScrollView(
        child: SizedBox(
          width: width * .65,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Server Configuration",
                style: TextStyle(fontSize: width * .04, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).secondaryHeaderColor.withValues(alpha: .35)),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor, borderRadius: BorderRadius.circular(14)),
                      child: Icon(useDirectUrl ? Icons.language : Icons.router, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            useDirectUrl ? "Direct Server URL" : "Local IP + Port",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            useDirectUrl ? "Example: https://api.softel.com" : "Example: 192.168.1.65 : 5050",
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: useDirectUrl,
                      activeThumbColor: Theme.of(context).secondaryHeaderColor,
                      onChanged: (value) {
                        setState(() {
                          useDirectUrl = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              buildField(
                title: useDirectUrl ? "Server URL" : "IP Address",
                controller: ip,
                hint: useDirectUrl ? "https://api.softel.com" : "192.168.1.65",
              ),

              const SizedBox(height: 15),

              if (!useDirectUrl) buildField(title: "Port", controller: port, keyboard: TextInputType.number, hint: "5050"),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).secondaryHeaderColor),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();

                    authProvider.useDirectUrl = useDirectUrl;
                    authProvider.ip_address = ip.text.trim();
                    authProvider.port = useDirectUrl ? '' : port.text.trim();

                    await prefs.setString('ip_address', authProvider.ip_address);

                    await prefs.setString('port', authProvider.port);

                    await prefs.setBool('useDirectUrl', useDirectUrl);

                    Toast(context: context, title: "URL:\n${authProvider.url}", style: ToastificationStyle.minimal, type: ToastificationType.success);

                    Navigator.pop(context);

                    authProvider.getUsersAndFolders();
                    authProvider.notifyListeners();
                  },
                  child: const Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
