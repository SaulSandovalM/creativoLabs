import 'package:creativolabs/api/customers_service.dart';
import 'package:creativolabs/api/sales_service.dart';
import 'package:creativolabs/api/service_service.dart';
import 'package:creativolabs/core/widgets/button.dart';
import 'package:creativolabs/core/widgets/input.dart';
import 'package:creativolabs/core/widgets/select.dart';
import 'package:creativolabs/providers/business_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class MainCreateSale extends StatefulWidget {
  const MainCreateSale({super.key});

  @override
  State<MainCreateSale> createState() => _MainCreateSaleState();
}

class _MainCreateSaleState extends State<MainCreateSale> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> clientes = [];
  List<Map<String, dynamic>> servicios = [];
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

  String? servicioSeleccionado;
  String? clienteSeleccionado;
  String? customerId;
  String? businessId;
  String? estadoSeleccionado;

  final _priceController = TextEditingController();
  final TextEditingController _orderNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final CustomersService _customersService = CustomersService();
  final SalesService _salesService = SalesService();
  final ServiceService _serviceService = ServiceService();

  double total = 0.0;

  @override
  void initState() {
    super.initState();
    final model = Provider.of<BusinessModel>(context, listen: false);
    businessId = model.businessId;
    _cargarClientes();
    _generarNumeroOrden();
    _cargarServicios();
  }

  Future<void> _cargarClientes() async {
    try {
      final stream =
          _customersService.getCustomersStreamByBusiness(businessId!);
      stream.listen((snapshot) {
        final List<Map<String, dynamic>> clientesList =
            snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'name': data['name'] ?? '',
            'address': data['direccion'] ?? '',
            'city': data['ciudad'] ?? '',
            'state': data['estado'] ?? '',
            'cp': data['cp']?.toString() ?? '',
          };
        }).toList();
        setState(() {
          clientes = clientesList;
          if (clientes.isNotEmpty) {
            customerId = clientes.first['id'];
            clienteSeleccionado = clientes.first['name'];
            estadoSeleccionado = clientes.first['state'];
            _cityController.text = clientes.first['city'];
            _addressController.text = clientes.first['address'];
            _cpController.text = clientes.first['cp'];
          }
        });
      }, onError: (error) {
        setState(() {
          clientes = [];
          clienteSeleccionado = null;
        });
      });
    } catch (e) {
      setState(() {
        clientes = [];
        clienteSeleccionado = null;
      });
    }
  }

  Future<void> _generarNumeroOrden() async {
    if (businessId == null) return;
    int nextOrderNumber = await _salesService.getLastSalesNumber(businessId!);
    setState(() {
      _orderNumberController.text = nextOrderNumber.toString();
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'es').format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'),
    );
    if (selectedDate != null) {
      _dateController.text = formatDate(selectedDate);
    }
  }

  Future<void> _cargarServicios() async {
    final stream = _serviceService.getServiceStreamByBusiness(businessId!);
    stream.listen((snapshot) {
      final List<Map<String, dynamic>> serviciosData = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'name': data['name'],
          'price': data['price'],
        };
      }).toList();
      setState(() {
        servicios = serviciosData;
        if (servicios.isNotEmpty) {
          servicioSeleccionado = servicios.first['name'];
          _priceController.text = servicios.first['price'].toString();
        }
      });
    }, onError: (error) {
      setState(() {
        servicios = [];
        servicioSeleccionado = null;
        _priceController.clear();
      });
    });
  }

  Future<void> _submitOrder() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (businessId == null ||
        clienteSeleccionado == null ||
        servicioSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faltan datos importantes para guardar la orden'),
        ),
      );
      return;
    }
    try {
      final double total = double.tryParse(
            _priceController.text.replaceAll(RegExp(r'[^\d.]'), ''),
          ) ??
          0.0;
      await _salesService.saveSale(
        businessId: businessId!,
        customerId: customerId ?? '',
        customerName: clienteSeleccionado!,
        orderNumber: int.parse(_orderNumberController.text),
        date: _dateController.text,
        time: _timeController.text,
        state: estadoSeleccionado!,
        city: _cityController.text,
        address: _addressController.text,
        cp: _cpController.text,
        service: servicioSeleccionado!,
        price: total,
        note: _noteController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orden registrada exitosamente')),
      );
      context.go('/sales');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar la orden')),
      );
    }
  }

  @override
  void dispose() {
    _orderNumberController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _cpController.dispose();
    _noteController.dispose();
    super.dispose();
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
                    child: Select<String>(
                      value: clienteSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Cliente',
                        border: OutlineInputBorder(),
                      ),
                      items: clientes.map((cliente) {
                        return DropdownMenuItem<String>(
                          value: cliente['name'],
                          child: Text(cliente['name']),
                        );
                      }).toList(),
                      onChanged: (String? nuevoCliente) {
                        final cliente = clientes.firstWhere(
                          (c) => c['name'] == nuevoCliente,
                          orElse: () => {},
                        );
                        setState(() {
                          customerId = cliente['id'];
                          clienteSeleccionado = nuevoCliente;
                          estadoSeleccionado = cliente['state'];
                          _cityController.text = cliente['city'];
                          _addressController.text = cliente['address'];
                          _cpController.text = cliente['cp'];
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione un cliente';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Input(
                      controller: _orderNumberController,
                      label: 'Orden',
                      readOnly: true,
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
                      controller: _dateController,
                      label: 'Día',
                      decoration: const InputDecoration(
                        labelText: 'Día',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_month),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Input(
                      controller: _timeController,
                      label: 'Hora',
                      decoration: const InputDecoration(
                        labelText: 'Hora',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _timeController.text = pickedTime.format(context);
                          });
                        }
                      },
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
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        border: OutlineInputBorder(),
                      ),
                      items: estados.map((String estado) {
                        return DropdownMenuItem<String>(
                          value: estado,
                          child: Text(estado),
                        );
                      }).toList(),
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
              Divider(
                color: Colors.grey,
                thickness: 1,
                height: 40,
              ),
              const Text(
                'Información adicional',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Input(
                      controller: _noteController,
                      label: 'Nota',
                      maxLines: 5,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        labelText: 'Nota',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                height: 40,
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: servicioSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Servicio',
                        border: OutlineInputBorder(),
                      ),
                      items: servicios.map((servicio) {
                        return DropdownMenuItem<String>(
                          value: servicio['name'],
                          child: Text(servicio['name']),
                        );
                      }).toList(),
                      onChanged: (String? nuevoServicio) {
                        setState(() {
                          servicioSeleccionado = nuevoServicio;

                          final servicio = servicios.firstWhere(
                            (s) => s['name'] == nuevoServicio,
                            orElse: () => {'price': 0},
                          );

                          _priceController.text = servicio['price'].toString();
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione un servicio';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Input(
                      controller: _priceController,
                      label: 'Total',
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      isCurrency: true,
                      decoration: const InputDecoration(
                        labelText: 'Total',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 10),
                    Button(
                      title: 'Crear orden',
                      onPressed: _submitOrder,
                    )
                  ],
                ),
              ),
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
