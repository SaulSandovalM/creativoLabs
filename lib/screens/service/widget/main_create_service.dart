import 'package:creativolabs/api/service_service.dart';
import 'package:creativolabs/core/widgets/button.dart';
import 'package:creativolabs/providers/business_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainCreateService extends StatefulWidget {
  const MainCreateService({super.key});

  @override
  State<MainCreateService> createState() => _MainCreateServiceState();
}

class _MainCreateServiceState extends State<MainCreateService> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _categorias = [
    'Carpintería',
    'Plomería',
    'Electricidad',
    'Limpieza',
    'Mecánica',
    'Reparaciones',
    'Control de Plagas',
    'Jardinería',
    'Pintura',
    'Albañilería',
    'Cerrajería',
    'Tecnología',
    'Cuidado de Mascotas',
    'Cuidado de Niños',
    'Cuidado de Ancianos',
    'Cuidado de Personas con Discapacidad',
    'Otros',
  ];
  List<String> _categoriasSeleccionadas = [];

  bool _showService = true;

  final ServiceService _serviceService = ServiceService();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _mostrarSelectorCategorias() async {
    final seleccionadas = List<String>.from(_categoriasSeleccionadas);
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Selecciona categorías'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: _categorias.map((categoria) {
                    return CheckboxListTile(
                      value: seleccionadas.contains(categoria),
                      title: Text(categoria),
                      onChanged: (bool? checked) {
                        setStateDialog(() {
                          if (checked == true) {
                            seleccionadas.add(categoria);
                          } else {
                            seleccionadas.remove(categoria);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _categoriasSeleccionadas = seleccionadas;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> saveService() async {
    if (_formKey.currentState!.validate()) {
      final businessId =
          Provider.of<BusinessModel>(context, listen: false).businessId;
      if (businessId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se ha cargado el negocio actual')),
        );
        return;
      }
      await _serviceService.addService(
        businessId: businessId,
        serviceData: {
          'name': _nameController.text,
          'price': _priceController.text.replaceAll(',', ''),
          'description': _descriptionController.text,
          'category': _categoriasSeleccionadas,
          'show': _showService,
          'status': 'activo',
        },
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Servicio guardado')),
      );
      _formKey.currentState!.reset();
      _nameController.clear();
      _priceController.clear();
      _descriptionController.clear();
      context.go('/services');
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
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del servicio',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un precio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: _mostrarSelectorCategorias,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Categorías',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(
                      text: _categoriasSeleccionadas.join(', '),
                    ),
                    validator: (value) {
                      if (_categoriasSeleccionadas.isEmpty) {
                        return 'Por favor selecciona al menos una categoría';
                      }
                      return null;
                    },
                    readOnly: true,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              CheckboxListTile(
                title: const Text('¿Mostrar servicio al público?'),
                value: _showService,
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      _showService = value;
                    });
                  }
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 25),
              Button(title: 'Guardar', onPressed: saveService),
            ],
          ),
        ),
      ),
    );
  }
}

// Clase personalizada para formatear como moneda
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final int value = int.parse(newValue.text.replaceAll(',', ''));
    final String newText = NumberFormat.currency(
      locale: 'es_MX',
      symbol: '',
      decimalDigits: 0,
    ).format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
