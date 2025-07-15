import 'package:creativolabs/api/customers_service.dart';
import 'package:creativolabs/core/constants/colors.dart';
import 'package:creativolabs/core/widgets/button.dart';
import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/core/widgets/input.dart';
import 'package:creativolabs/core/widgets/select.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class MainSignup extends StatefulWidget {
  const MainSignup({super.key});

  @override
  MainSignupState createState() => MainSignupState();
}

class MainSignupState extends State<MainSignup> {
  String? stateSelected;

  List<String> estados = [
    'Aguascalientes',
    'Baja California',
    'Baja California Sur',
    'Campeche',
    'Chiapas',
    'Chihuahua',
    'Ciudad de México',
    'Coahuila',
    'Colima',
    'Durango',
    'Estado de México',
    'Guanajuato',
    'Guerrero',
    'Hidalgo',
    'Jalisco',
    'Michoacán',
    'Morelos',
    'Nayarit',
    'Nuevo León',
    'Oaxaca',
    'Puebla',
    'Querétaro',
    'Quintana Roo',
    'San Luis Potosí',
    'Sinaloa',
    'Sonora',
    'Tabasco',
    'Tamaulipas',
    'Tlaxcala',
    'Veracruz',
    'Yucatán',
    'Zacatecas'
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _secondLastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _cpController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _customerService = CustomersService();
  final _phoneController = TextEditingController();

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

      await _customerService.createCustomerForUser(
        userId: user.uid,
        name: _nameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        secondLastName: _secondLastNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        company: '',
        status: 'Activo',
        state: stateSelected,
        city: _cityController.text.trim(),
        address: _addressController.text.trim(),
        cp: _cpController.text.trim(),
      );

      await user.sendEmailVerification();
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registro exitoso. Revisa tu correo para verificar tu cuenta.',
          ),
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

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      child: SizedBox(
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
                      Row(
                        children: [
                          Expanded(
                            child: Input(
                              controller: _nameController,
                              label: 'Nombre',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Input(
                              controller: _lastNameController,
                              label: 'Primer Apellido',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: Input(
                              controller: _secondLastNameController,
                              label: 'Segundo Apellido',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Input(
                              controller: _phoneController,
                              label: 'Teléfono',
                              keyboardType: TextInputType.number,
                              minLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                      const SizedBox(height: 40),
                      Input(
                        controller: _passwordController,
                        label: 'Contraseña',
                        obscureText: true,
                        minLength: 6,
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: Select<String>(
                              value: stateSelected,
                              items: estados.map((String estado) {
                                return DropdownMenuItem<String>(
                                  value: estado,
                                  child: Text(estado),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                labelText: 'Estado',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String? nuevoEstado) {
                                setState(() {
                                  stateSelected = nuevoEstado;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor seleccione un estado';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Input(
                              controller: _cityController,
                              label: 'Ciudad',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: Input(
                              controller: _addressController,
                              label: 'Dirección',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Input(
                              controller: _cpController,
                              label: 'CP',
                              keyboardType: TextInputType.number,
                              minLength: 5,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(5),
                              ],
                            ),
                          ),
                        ],
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
                                  'Al hacer clic en "Registrate", aceptas los',
                            ),
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
