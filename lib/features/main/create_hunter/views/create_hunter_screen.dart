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
    final vm = context.watch<CreateHunterViewModel>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB7F8DB), // soft green
              Color(0xFF50A7C2), // soft blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header & Icon
                    Text(
                      "Buat Profil Hunter",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                        letterSpacing: 1.1,
                        shadows: [
                          Shadow(
                            color: Colors.green.shade200,
                            blurRadius: 4,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.green.shade700,
                      child: Icon(Icons.eco, color: Colors.white, size: 48),
                    ),
                    const SizedBox(height: 24),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.shade100.withValues(alpha: 0.18),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Username
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Username",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _usernameController,
                              style: TextStyle(
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person, color: Colors.green.shade700),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Nama panggilanmu",
                                hintStyle: TextStyle(color: Colors.green.shade200),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tanggal Lahir",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            DatePickerFormField(
                              onDateSelected: (date) {
                                setState(() {
                                  _tanggalLahir = date;
                                });
                              },
                              initialDate: _tanggalLahir,
                              textStyle: TextStyle(
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w600,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.green.shade200,
                              ),
                              iconColor: Colors.green.shade700,
                            ),
                            const SizedBox(height: 18),
                            // Error message
                            if (vm.errorMessage != null && vm.errorMessage!.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  vm.errorMessage!,
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                ),
                                icon: const Icon(Icons.check_circle),
                                label: const Text(
                                  "DAFTAR",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  final success = await vm.registerHunter(_usernameController.text, _tanggalLahir);
                                  if (success) {
                                    if (!context.mounted) return;
                                    Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (_) => false);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      "🌱 Selamat bergabung! Jadilah pahlawan lingkungan bersama Trash Hunt! 🌏",
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}