import 'package:creativolabs/api/customers_service.dart';
import 'package:creativolabs/core/widgets/button.dart';
import 'package:creativolabs/core/widgets/input.dart';
import 'package:creativolabs/core/widgets/select.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:creativolabs/providers/business_model.dart';

class MainEditCustomer extends StatefulWidget {
  final Map<String, dynamic> customer;

  const MainEditCustomer({super.key, required this.customer});

  @override
  State<MainEditCustomer> createState() => _MainEditCustomerState();
}

class _MainEditCustomerState extends State<MainEditCustomer> {
  final _formKey = GlobalKey<FormState>();

  String? estadoSeleccionado;
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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _secondLastNameController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();

  final CustomersService _customersService = CustomersService();

  @override
  void initState() {
    super.initState();
    final customer = widget.customer;
    _nameController.text = customer['name'] ?? '';
    _lastNameController.text = customer['lastName'] ?? '';
    _secondLastNameController.text = customer['secondLastName'] ?? '';
    _emailController.text = customer['email'] ?? '';
    _phoneController.text = customer['phoneNumber'] ?? '';
    _companyController.text = customer['company'] ?? '';
    _cityController.text = customer['ciudad'] ?? '';
    _addressController.text = customer['direccion'] ?? '';
    _cpController.text = customer['cp'] ?? '';
    estadoSeleccionado = customer['estado'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _cpController.dispose();
    super.dispose();
  }

  Future<void> updateCustomer() async {
    if (_formKey.currentState!.validate()) {
      final businessId =
          Provider.of<BusinessModel>(context, listen: false).businessId;
      if (businessId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se ha cargado el negocio actual')),
        );
        return;
      }
      try {
        await _customersService.updateCustomer(
          businessId: businessId,
          customerId: widget.customer['id'],
          customerData: {
            'name': _nameController.text,
            'lastName': _lastNameController.text,
            'secondLastName': _secondLastNameController.text,
            'email': _emailController.text,
            'phoneNumber': _phoneController.text,
            'company': _companyController.text,
            'estado': estadoSeleccionado,
            'ciudad': _cityController.text,
            'direccion': _addressController.text,
            'cp': _cpController.text,
          },
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente actualizado correctamente')),
        );
        context.go('/customers');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Información básica',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Input(
                      controller: _nameController,
                      label: 'Nombre',
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Input(
                      controller: _lastNameController,
                      label: 'Apellido paterno',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Input(
                      controller: _secondLastNameController,
                      label: 'Apellido materno',
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Input(
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
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  const SizedBox(width: 25),
                  Expanded(
                    child: Input(
                      controller: _companyController,
                      label: 'Compañia',
                      validator: (value) => null,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                height: 40,
              ),
              const Text(
                'Dirección',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Select<String>(
                      value: estadoSeleccionado,
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
                          estadoSeleccionado = nuevoEstado;
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
                  const SizedBox(width: 25),
                  Expanded(
                    child: Input(
                      controller: _cityController,
                      label: 'Ciudad',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Input(
                      controller: _addressController,
                      label: 'Dirección',
                    ),
                  ),
                  const SizedBox(width: 25),
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
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Button(
                    title: 'Guardar cliente',
                    onPressed: () async => await updateCustomer(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
