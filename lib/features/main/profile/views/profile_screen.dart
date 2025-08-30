import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_hunt/core/domain/entities/hunter.dart';
import 'package:trash_hunt/core/routing/app_router.dart';
import 'package:trash_hunt/features/main/profile/viewmodels/profile_viewmodel.dart';
import 'package:trash_hunt/widgets/showcase_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    final vm = context.read<ProfileViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await vm.getHunter();
    });
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  void refreshHunter() async {
    final vm = context.read<ProfileViewModel>();
    await vm.getHunter();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final scheme = Theme.of(context).colorScheme;
    if (vm.hunter == null) {
      return const Center(child: CircularProgressIndicator());
    }
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
        child: SafeArea(
          child: SizedBox.expand(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: buildProfileView(vm.hunter!, context, scheme, vm),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileView(Hunter hunter, BuildContext context, ColorScheme scheme, ProfileViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Header Avatar dan Username
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.green.shade700,
              child: Icon(Icons.eco, color: Colors.white, size: 54),
            ),
            const SizedBox(width: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hunter.username,
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
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.amber.shade700, size: 22),
                    const SizedBox(width: 4),
                    Text(
                      "Level ${hunter.level}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Card utama profil
        Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          color: Colors.green.shade50,
          shadowColor: Colors.green.shade200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              children: [
                // XP Bar
                Text(
                  "XP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 240,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: hunter.exp / vm.expToNext(hunter.level),
                      backgroundColor: Colors.green.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
                      minHeight: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${hunter.exp} / ${vm.expToNext(hunter.level)} XP",
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                // Showcase statistik
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ShowcaseCard(
                        title: "Total Hunt",
                        value: hunter.totalTrash.toString(),
                        icon: Icons.recycling,
                        color: Colors.green.shade400,
                      ),
                      const SizedBox(width: 12),
                      ShowcaseCard(
                        title: "Coins",
                        value: hunter.coins.toString(),
                        icon: Icons.monetization_on,
                        color: Colors.amber.shade700,
                      ),
                      const SizedBox(width: 12),
                      ShowcaseCard(
                        title: "Teman",
                        value: hunter.friendIds.length.toString(),
                        icon: Icons.people,
                        color: Colors.blue.shade400,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Motivasi
                Text(
                  "🌱 Terima kasih sudah berkontribusi untuk bumi yang lebih hijau! 🌏",
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
        const SizedBox(height: 28),
        // Tombol aksi
        Column(
          children: [
            _ProfileActionButton(
              icon: Icons.edit,
              label: "Edit Profile",
              color: scheme.inversePrimary,
              onTap: () async {
                final result = await Navigator.pushNamed(context, AppRouter.editProfile);
                if (result == true) {
                  if (!context.mounted) return;
                  final vm = context.read<ProfileViewModel>();
                  await vm.getHunter(forceRefresh: true);
                  setState(() {}); // agar rebuild jika perlu
                }
              },
            ),
            const SizedBox(height: 16),
            _ProfileActionButton(
              icon: Icons.settings,
              label: "Pengaturan",
              color: scheme.secondaryContainer,
              onTap: () {
                // TODO: Implement pengaturan
              },
            ),
            const SizedBox(height: 16),
            _ProfileActionButton(
              icon: Icons.exit_to_app,
              label: "Sign Out",
              color: Colors.red.shade400,
              textColor: Colors.white,
              onTap: () async {
                final success = await vm.signOut();
                if (success) {
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(context, AppRouter.signin, (_) => false);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

// Tombol aksi profil dengan style konsisten
class _ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color? textColor;
  final VoidCallback onTap;

  const _ProfileActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveTextColor = textColor ??
        (ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? Colors.white
            : Colors.green.shade900);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.green.withValues(alpha: 0.15),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: effectiveTextColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 17,
                    color: effectiveTextColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
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