import 'package:creativolabs/core/constants/colors.dart';
import 'package:creativolabs/core/widgets/button.dart';
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
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _businessService = BusinessService();
  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCredential.user;
      if (user == null) throw FirebaseAuthException(code: 'user-null');

      await _businessService.createBusinessForUser(
        userId: user.uid,
        name: _nameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
      );

      await user.sendEmailVerification();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Registro exitoso. Revisa tu correo para verificar tu cuenta.'),
        ),
      );
      context.go('/signin');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: _nameController,
            label: 'Nombre',
            validatorMessage: 'Ingresa tu nombre',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTextField(
            controller: _lastNameController,
            label: 'Apellido',
            validatorMessage: 'Ingresa tu apellido',
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? validatorMessage,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            (label == 'Contraseña' && value.length < 6)) {
          return validatorMessage ?? 'Campo inválido';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableHeight =
        MediaQuery.of(context).size.height - widget.headerHeight;

    return MainContainer(
      child: SizedBox(
        height: availableHeight,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('REGISTRATE', style: TextStyle(fontSize: 16)),
                      const Text('Crea una cuenta',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      const Text('Llena el formulario para empezar',
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 40),
                      _buildNameFields(),
                      const SizedBox(height: 40),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Correo electrónico',
                        validatorMessage: 'Ingresa tu correo',
                      ),
                      const SizedBox(height: 40),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Contraseña',
                        validatorMessage: 'Mínimo 6 caracteres',
                        obscureText: true,
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text("¿Ya tienes una cuenta?"),
                              TextButton(
                                onPressed: () => context.go('/signin'),
                                child: const Text("Entra.",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          ),
                          Button(
                            title: 'Registrate',
                            onPressed: _register,
                            isLoading: _isLoading,
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
                                    'Al hacer clic en "Registrate", aceptas los'),
                            TextSpan(
                              text:
                                  ' términos y condiciones de nuestra empresa.',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => context.go('/terms'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: Container(color: CustomColor.navBarBg)),
          ],
        ),
      ),
    );
  }
}
