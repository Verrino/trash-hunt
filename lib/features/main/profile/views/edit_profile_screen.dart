import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_hunt/features/main/profile/viewmodels/edit_profile_viewmodel.dart';
import 'package:trash_hunt/widgets/date_picker_form_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  DateTime? _tanggalLahir;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final vm = context.read<EditProfileViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await vm.getHunter();
      if (!mounted) return;
      setState(() {
        _usernameController.text = vm.hunter!.username;
        _tanggalLahir = vm.hunter!.birthDate;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700.withValues(alpha: 0.85),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Kembali',
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB7F8DB),
              Color(0xFF50A7C2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: vm.hunter == null || _usernameController.text.isEmpty || _tanggalLahir == null
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Edit Profile',
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
                          radius: 48,
                          backgroundColor: Colors.green.shade700,
                          child: Icon(Icons.eco, color: Colors.white, size: 54),
                        ),
                        const SizedBox(height: 24),
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          color: Colors.green.shade50,
                          shadowColor: Colors.green.shade200,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Username
                                Text(
                                  "Username",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade900,
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
                                    hintText: "Username",
                                    hintStyle: TextStyle(color: Colors.green.shade200),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                // Tanggal Lahir
                                Text(
                                  "Tanggal Lahir",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade900,
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
                                if (_errorMessage != null && _errorMessage!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
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
                                    icon: const Icon(Icons.save),
                                    label: const Text(
                                      'Simpan Perubahan',
                                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      if (_usernameController.text.trim().isEmpty) {
                                        setState(() {
                                          _errorMessage = "Username tidak boleh kosong";
                                        });
                                        return;
                                      }
                                      if (_tanggalLahir == null) {
                                        setState(() {
                                          _errorMessage = "Tanggal lahir harus diisi";
                                        });
                                        return;
                                      }
                                      setState(() {
                                        _errorMessage = null;
                                      });
                                      final vm = context.read<EditProfileViewModel>();
                                      final success = await vm.editHunter(_usernameController.text, _tanggalLahir!);

                                      if (success) {
                                        if (!context.mounted) return;
                                        Navigator.pop(context, true);
                                      } else {
                                        setState(() {
                                          _errorMessage = "Gagal menyimpan perubahan. Coba lagi.";
                                        });
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
                          "🌱 Jadilah inspirasi untuk lingkungan yang lebih hijau! 🌏",
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
    );
  }
}