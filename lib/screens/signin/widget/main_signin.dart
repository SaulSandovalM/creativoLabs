import 'package:creativolabs/core/constants/colors.dart';
import 'package:creativolabs/core/widgets/button.dart';
import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/core/widgets/input.dart';
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
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = userCredential.user;
      await user?.reload();
      user = _auth.currentUser;
      if (user != null && user.emailVerified) {
        if (!mounted) return;
        context.go('/dashboard');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Debes verificar tu correo electrónico antes de ingresar.',
            ),
          ),
        );
        await _auth.signOut();
      }
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
                            Input(
                              controller: _emailController,
                              label: 'Correo electrónico',
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa tu correo';
                                }
                                if (!value.contains('@')) {
                                  return 'Correo inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.go('/reset-password');
                                  },
                                  child: const Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Input(
                              controller: _passwordController,
                              label: 'Contraseña',
                              obscureText: true,
                              minLength: 6,
                            ),
                            const SizedBox(height: 40),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "¿Aún no tienes una cuenta?",
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              context.go('/signup'),
                                          child: const Text(
                                            "Regístrate aquí.",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Button(
                                      title: 'Entrar',
                                      onPressed: _signIn,
                                      isLoading: _isLoading,
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
