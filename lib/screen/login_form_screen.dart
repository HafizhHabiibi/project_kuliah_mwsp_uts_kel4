import 'package:flutter/material.dart';

import 'forget_pass_screen.dart';
import 'register_form_screen.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/main_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/services/cart_service.dart';
import 'package:project_kuliah_mwsp_uts_kel4/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // ================= LOGIN EMAIL =================
  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final authService = AuthService();
      final result = await authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (result['success'] == true) {
        final user = result['user'];
        CartService().setCurrentUser(user.id.toString());

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login berhasil!")));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "Login gagal")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ================= LOGIN GOOGLE =================
  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final authService = AuthService();
      final result = await authService.loginWithGoogle();

      if (result['success'] == true) {
        final user = result['user'];
        CartService().setCurrentUser(user.id.toString());

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login Google berhasil!")));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "Login Google gagal")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error login Google: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: const Color.fromRGBO(74, 55, 73, 1)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.90,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
                      ),
                      const SizedBox(height: 24),

                      // EMAIL
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Email'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // PASSWORD
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Password'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color.fromRGBO(74, 55, 73, 1),
                            ),
                            onPressed: _togglePassword,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // LOGIN BUTTON
                      ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: const Color.fromRGBO(74, 55, 73, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("LOGIN"),
                      ),

                      const SizedBox(height: 10),

                      // FORGOT PASSWORD (SAMA SEPERTI YANG LAMA)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Color.fromRGBO(74, 55, 73, 1),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ForgetPassScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Reset Password",
                                style: TextStyle(
                                  color: Color.fromRGBO(74, 55, 73, 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // GOOGLE LOGIN (TENGAH & BISA DIKLIK)
                      GestureDetector(
                        onTap: _loginWithGoogle,
                        child: Image.asset(
                          'assets/images/social/google-mail.png',
                          height: 40,
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text("Don’t have any account?"),
                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterFormScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: const Color.fromRGBO(
                            229,
                            229,
                            229,
                            1,
                          ),
                        ),
                        child: const Text("CREATE AN ACCOUNT"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
