import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_hunt/core/routing/app_router.dart';
import '../viewmodels/auth_viewmodel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmedPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmedPassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmedPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

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
                    // Logo/Avatar
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.green.shade700,
                      child: Icon(Icons.eco, color: Colors.white, size: 48),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Sign Up to Trash Hunt",
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
                            // Email
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon: Icon(Icons.email, color: Colors.green.shade700),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Your Email",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            // Password
                            TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock, color: Colors.green.shade700),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.green.shade400,
                                  ),
                                ),
                              ),
                              obscureText: _obscurePassword,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(height: 16),
                            // Confirmed Password
                            TextField(
                              controller: confirmedPasswordController,
                              decoration: InputDecoration(
                                labelText: "Confirmed Password",
                                prefixIcon: Icon(Icons.lock_outline, color: Colors.green.shade700),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Confirmed Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmedPassword = !_obscureConfirmedPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureConfirmedPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.green.shade400,
                                  ),
                                ),
                              ),
                              obscureText: _obscureConfirmedPassword,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(height: 18),
                            // Sign Up Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 3,
                                ),
                                icon: const Icon(Icons.person_add),
                                label: const Text(
                                  "Sign Up",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  final success = await vm.signUpWithEmail(
                                    emailController.text,
                                    passwordController.text,
                                    confirmedPasswordController.text,
                                  );
                                  if (success) {
                                    if (!mounted) return;
                                    await vm.checkHunter()
                                        ? Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (_) => false)
                                        : Navigator.pushNamedAndRemoveUntil(context, AppRouter.createHunter, (_) => false);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Error message (placeholder jika belum ada error)
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: vm.errorMessage != null && vm.errorMessage!.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Text(
                                        vm.errorMessage!,
                                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  : const SizedBox(height: 24), // Placeholder
                            ),
                            const SizedBox(height: 10),
                            // Google Sign Up
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.green.shade400),
                                  foregroundColor: Colors.green.shade700,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                icon: Image.asset(
                                  "assets/icons/google.png",
                                  width: 28,
                                  height: 28,
                                ),
                                label: const Text(
                                  "Sign Up with Google",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                onPressed: () async {
                                  final success = await vm.signInWithGoogle();
                                  if (!context.mounted) return;
                                  if (success) {
                                    if (!mounted) return;
                                    await vm.checkHunter()
                                        ? Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (_) => false)
                                        : Navigator.pushNamedAndRemoveUntil(context, AppRouter.createHunter, (_) => false);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 18),
                            // Sign In
                            InkWell(
                              onTap: () => Navigator.pushNamedAndRemoveUntil(context, AppRouter.signin, (route) => false),
                              child: Text(
                                "Sudah punya akun? Masuk di sini",
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
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
        ),
      ),
    );
  }
}