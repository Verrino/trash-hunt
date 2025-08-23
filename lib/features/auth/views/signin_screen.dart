import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_hunt/core/routing/app_router.dart';
import 'package:trash_hunt/core/services/session_manager.dart';
import '../viewmodels/auth_viewmodel.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final session = context.read<SessionManager>();
    if (session.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (_) => false);
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final scheme = Theme.of(context).colorScheme;

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
                              Text("Email"),
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Your Email",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Password"),
                              TextField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
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
                                    ),
                                  ),
                                ),
                                obscureText: _obscurePassword,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text("or login with"),
                        SizedBox(
                          height: 12,
                        ),
                        InkWell(
                          onTap: () async {
                            final success = await vm.signInWithGoogle();

                            if (!context.mounted) return;

                            if (success) {
                              Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (route) => false);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: scheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/icons/google.png",
                                  width: 40,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text("Google"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        if (vm.errorMessage != null) ... [
                          Text(vm.errorMessage!, style: TextStyle(color: Colors.red)),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                        InkWell(
                          onTap: () async {
                            final success = await vm.signInWithEmail(emailController.text, passwordController.text);

                            if (!context.mounted) return;

                            if (success) {
                              Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (route) => false);
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
                              "Sign In",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        InkWell(
                          onTap: () => Navigator.pushNamedAndRemoveUntil(context, AppRouter.signup, (route) => false),
                          child: Text("Don't have an account? Sign Up", style: TextStyle(color: scheme.primary)),
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
