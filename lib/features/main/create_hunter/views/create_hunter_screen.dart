import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_hunt/core/routing/app_router.dart';
import 'package:trash_hunt/features/main/create_hunter/viewmodels/create_hunter_viewmodel.dart';
import 'package:trash_hunt/widgets/date_picker_form_field.dart';

class CreateHunterScreen extends StatefulWidget {
  const CreateHunterScreen({super.key});

  @override
  State<CreateHunterScreen> createState() => _CreateHunterScreenState();
}

class _CreateHunterScreenState extends State<CreateHunterScreen> {
  final TextEditingController _usernameController = TextEditingController();

  DateTime _tanggalLahir = DateTime.now();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final vm = context.watch<CreateHunterViewModel>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: scheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Username"),
                              TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "John Doe",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tanggal Lahir"),
                              DatePickerFormField(
                                onDateSelected: (date) {
                                  setState(() {
                                    _tanggalLahir = date;
                                  });
                                },
                                initialDate: _tanggalLahir,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (vm.errorMessage != null) ... [
                          Text(vm.errorMessage!, style: TextStyle(color: Colors.red)),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                        InkWell(
                          onTap: () async {
                            try {
                              final success = await vm.registerHunter(_usernameController.text, _tanggalLahir);

                              if (success) {
                                if (!context.mounted) return;
                                Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (_) => false);
                              }
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                              color: scheme.inversePrimary,
                              border: Border.all(
                                color: scheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "DAFTAR",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
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