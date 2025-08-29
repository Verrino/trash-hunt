import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_hunt/core/domain/entities/hunter.dart';
import 'package:trash_hunt/core/routing/app_router.dart';
import 'package:trash_hunt/features/main/profile/viewmodels/profile_viewmodel.dart';
import 'package:trash_hunt/widgets/showcase_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final vm = context.read<ProfileViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await vm.getHunter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    if (vm.hunter == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return buildProfileView(vm.hunter!, context);
  }

  Widget buildProfileView(Hunter hunter, BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final vm = context.watch<ProfileViewModel>();

    return SingleChildScrollView(
      child: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 100),
              ),
              const SizedBox(height: 16),
              Text(
                hunter.username,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                hunter.level.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Exp bar
              SizedBox(
                width: 300,
                child: LinearProgressIndicator(
                  value: hunter.exp / vm.expToNext(hunter.level),
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text("${hunter.exp}/${vm.expToNext(hunter.level)}"),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ShowcaseCard(title: "Total Hunt:", value: hunter.totalTrash.toString()),
                    ShowcaseCard(title: "Coins:", value: hunter.coins.toString()),
                    ShowcaseCard(title: "Teman:", value: hunter.friendIds.length.toString()),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.editProfile);
                },
                child: Container(
                  width: 350,
                  height: 60,
                  decoration: BoxDecoration(
                    color: scheme.inversePrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit Profile'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  
                },
                child: Container(
                  width: 350,
                  height: 60,
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.settings),
                      SizedBox(width: 8),
                      Text('Pengaturan'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final success = await vm.signOut();
                  if (success) {
                    if (!mounted) return;
                    Navigator.pushNamedAndRemoveUntil(context, AppRouter.signin, (_) => false);
                  }
                },
                child: Container(
                  width: 350,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Sign Out'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
