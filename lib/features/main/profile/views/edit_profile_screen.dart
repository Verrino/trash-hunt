import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_hunt/core/domain/entities/hunter.dart';
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
    if (vm.hunter == null || _usernameController.text.isEmpty || _tanggalLahir == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return buildEditProfileView(context, vm.hunter!);
  }

  Widget buildEditProfileView(
    BuildContext context,
    Hunter hunter,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final vm = context.watch<EditProfileViewModel>();

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 100),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    controller: _usernameController,
                    onChanged: (value) {

                    },
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
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
                ElevatedButton(
                  onPressed: () async {
                    final success = await vm.editHunter(_usernameController.text, _tanggalLahir!);

                    if (success) {
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
