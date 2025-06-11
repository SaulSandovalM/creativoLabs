import 'package:creativolabs/api/service_service.dart';
import 'package:creativolabs/core/widgets/button.dart';
import 'package:creativolabs/providers/business_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class MainEditService extends StatefulWidget {
  final String serviceId;

  const MainEditService({super.key, required this.serviceId});

  @override
  State<MainEditService> createState() => _MainEditServiceState();
}

class _MainEditServiceState extends State<MainEditService> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ServiceService _serviceService = ServiceService();
  bool _loading = true;
  bool _showService = true;
  List<String> _categoriasSeleccionadas = [];

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

  @override
  void initState() {
    super.initState();
    _loadServiceData();
  }

  Future<void> _loadServiceData() async {
    final businessId =
        Provider.of<BusinessModel>(context, listen: false).businessId;
    if (businessId == null) return;

    final doc = await _serviceService.getServiceById(
      businessId: businessId,
      serviceId: widget.serviceId,
    );

    if (doc != null) {
      final data = doc.data() as Map<String, dynamic>;
      _nameController.text = data['name'] ?? '';
      _priceController.text = data['price'] ?? '';
      _descriptionController.text = data['description'] ?? '';
      _categoriasSeleccionadas = List<String>.from(data['category'] ?? []);
      _showService = data['show'] ?? true;
    }

    setState(() => _loading = false);
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

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final businessId =
          Provider.of<BusinessModel>(context, listen: false).businessId;
      if (businessId == null) return;
      await _serviceService.updateService(
        businessId: businessId,
        serviceId: widget.serviceId,
        serviceData: {
          'name': _nameController.text,
          'price': _priceController.text.replaceAll(',', ''),
          'description': _descriptionController.text,
          'category': _categoriasSeleccionadas,
          'show': _showService,
        },
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Servicio actualizado')),
      );
      context.go('/services');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del servicio',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Por favor ingresa el nombre'
                  : null,
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
              validator: (value) => value == null || value.isEmpty
                  ? 'Por favor ingrese un precio'
                  : null,
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
              validator: (value) => value == null || value.isEmpty
                  ? 'Por favor ingrese una descripción'
                  : null,
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
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: _categoriasSeleccionadas.join(', '),
                    ),
                  ),
                  validator: (value) {
                    if (_categoriasSeleccionadas.isEmpty) {
                      return 'Por favor selecciona al menos una categoría';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),
            CheckboxListTile(
              title: const Text('¿Mostrar servicio al público?'),
              value: _showService,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _showService = value);
                }
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 25),
            Button(
              title: 'Guardar cambios',
              onPressed: _saveChanges,
              icon: Icons.save,
            ),
          ],
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
