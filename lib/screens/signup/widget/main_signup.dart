import 'package:creativolabs/core/constants/colors.dart';
import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/api/business_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainSignUp extends StatefulWidget {
  final double headerHeight;

  const MainSignUp({super.key, required this.headerHeight});

  @override
  MainSignUpState createState() => MainSignUpState();
}

class MainSignUpState extends State<MainSignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final BusinessService _businessService = BusinessService();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Crear usuario
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final String userId = userCredential.user!.uid;

        // Llamar a la función de creación del negocio
        await _businessService.createBusinessForUser(
          userId: userId,
          name: _nameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro y negocio creados correctamente.'),
          ),
        );
        context.go('/dashboard');
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'REGISTRATE',
                        style: TextStyle(fontSize: 16),
                      ),
                      const Text(
                        'Crea una cuenta',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Llena el formulario para empezar',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Nombre',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Ingresa tu nombre';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _lastNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Apellido',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Ingresa tu apellido';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Correo electrónico',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa tu correo';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 40),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Contraseña',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return 'Mínimo 6 caracteres';
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
                                    Row(
                                      children: [
                                        const Text("Ya tienes una cuenta?"),
                                        TextButton(
                                          onPressed: () {
                                            context.go('/signin');
                                          },
                                          child: const Text(
                                            "Entra  .",
                                            style: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 15,
                                        ),
                                      ),
                                      onPressed: _register,
                                      child: const Text("Registrate"),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.grey),
                                    children: [
                                      const TextSpan(
                                        text:
                                            'Al hacer clic en "Registrate", aceptas los',
                                      ),
                                      TextSpan(
                                        text:
                                            ' términos y condiciones de nuestra empresa.',
                                        style:
                                            const TextStyle(color: Colors.blue),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            context.go('/terms');
                                          },
                                      ),
                                    ],
                                  ),
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
            Expanded(
              child: Container(
                color: CustomColor.navBarBg,
              ),
            )
          ],
        ),
      ),
    );
  }
}
