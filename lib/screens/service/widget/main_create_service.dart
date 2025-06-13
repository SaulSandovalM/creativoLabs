import 'package:creativolabs/api/service_service.dart';
import 'package:creativolabs/core/widgets/button.dart';
import 'package:creativolabs/core/widgets/input.dart';
import 'package:creativolabs/core/widgets/multi_select.dart';
import 'package:creativolabs/providers/business_model.dart';
import 'package:flutter/material.dart';
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
              Input(
                controller: _nameController,
                label: 'Nombre del servicio',
              ),
              const SizedBox(height: 25),
              Input(
                controller: _priceController,
                label: 'Precio',
                keyboardType: TextInputType.number,
                isCurrency: true,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 25),
              Input(
                controller: _descriptionController,
                label: 'Descripción',
                maxLines: 5,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              MultiSelect(
                onTap: _mostrarSelectorCategorias,
                selectedCategories: _categoriasSeleccionadas,
                labelText: 'Categorías',
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
              Button(
                title: 'Guardar',
                onPressed: saveService,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
