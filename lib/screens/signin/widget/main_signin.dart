import 'package:creativolabs/core/constants/colors.dart';
import 'package:creativolabs/core/widgets/container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class MainSignIn extends StatefulWidget {
  final double headerHeight;

  const MainSignIn({super.key, required this.headerHeight});

  @override
  MainSignInState createState() => MainSignInState();
}

class MainSignInState extends State<MainSignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      context.go('/dashboard');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showAuthError(e.code);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAuthError(String errorCode) {
    final errorMessages = {
      'invalid-email': 'El correo electrónico no es válido.',
      'invalid-credential': 'Las credenciales no son válidas.',
      'user-disabled': 'El usuario ha sido deshabilitado.',
      'user-not-found': 'No se encontró un usuario con ese correo.',
      'wrong-password': 'La contraseña es incorrecta.',
    };

    final errorMessage = errorMessages[errorCode] ??
        'Ocurrió un error: $errorCode. Inténtalo de nuevo.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $errorMessage')),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu correo';
    }
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double availableHeight = screenHeight - widget.headerHeight;

    return MainContainer(
      child: SizedBox(
        height: availableHeight,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: CustomColor.navBarBg,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'INICIA SESIÓN',
                        style: TextStyle(fontSize: 16),
                      ),
                      const Text(
                        'Bienvenido de nuevo',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Inicie sesión para administrar su cuenta.',
                        style: TextStyle(fontSize: 16),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Correo electrónico',
                                border: OutlineInputBorder(),
                              ),
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: 20),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Olvidaste tu contraseña?',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Contraseña',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa tu contraseña';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 40),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 15,
                                        ),
                                      ),
                                      onPressed: _isLoading ? null : _signIn,
                                      child: _isLoading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text("Entrar"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
