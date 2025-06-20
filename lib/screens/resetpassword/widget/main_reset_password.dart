import 'package:creativolabs/api/auth_service.dart';
import 'package:creativolabs/core/constants/colors.dart';
import 'package:creativolabs/core/widgets/container.dart';
import 'package:flutter/material.dart';

class MainResetPassword extends StatefulWidget {
  final double headerHeight;

  const MainResetPassword({super.key, required this.headerHeight});

  @override
  MainResetPasswordState createState() => MainResetPasswordState();
}

class MainResetPasswordState extends State<MainResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    setState(() => _loading = true);
    final String email = _emailController.text.trim();
    final String? error = await AuthService().sendResetEmail(email);
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ??
              'Correo de recuperación enviado. Revisa tu bandeja de entrada.',
        ),
        backgroundColor: error == null ? Colors.green : Colors.red,
        duration: const Duration(seconds: 4),
      ),
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
              child: Container(color: CustomColor.navBarBg),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RESETEAR CONTRASEÑA',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Correo electrónico',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu correo electrónico';
                              }
                              final emailRegex =
                                  RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Correo inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _loading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 15,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _resetPassword();
                                    }
                                  },
                                  child: const Text(
                                    'Enviar correo de recuperación',
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
