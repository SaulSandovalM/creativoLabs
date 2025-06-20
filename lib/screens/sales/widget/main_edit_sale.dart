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
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainEditSale extends StatefulWidget {
  final Map<String, dynamic> order;

  const MainEditSale({super.key, required this.order});

  @override
  State<MainEditSale> createState() => _MainEditSaleState();
}

class _MainEditSaleState extends State<MainEditSale> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> services = [];

  String? serviceSelected;
  String? selectedPaymentMethod;
  String? customerSelected;
  String? customerId;
  String? businessId;

  final _priceController = TextEditingController();
  final TextEditingController _orderNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
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
    businessId = Provider.of<BusinessModel>(context, listen: false).businessId;

    _loadCustomers();
    _loadServices();
    final order = widget.order;
    customerSelected = order['customerName'];
    _orderNumberController.text = order['orderNumber'].toString();
    _dateController.text = order['date'];
    _timeController.text = order['time'];
    _stateController.text = order['state'];
    _cityController.text = order['city'];
    _addressController.text = order['address'];
    _cpController.text = order['cp'];
    _noteController.text = order['note'];
    _priceController.text = order['price'].toString();
    serviceSelected = order['service'];
    selectedPaymentMethod = order['paymentMethod'];
  }

  Future<void> _loadCustomers() async {
    try {
      final stream =
          _customersService.getCustomersStreamByBusiness(businessId!);
      await for (final snapshot in stream) {
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
          customers = clientesList;
          debugPrint('Clientes cargados: $customers');
        });
        break;
      }
    } catch (e) {
      setState(() {
        customers = [];
        customerSelected = null;
      });
    }
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

  Future<void> _loadServices() async {
    final stream = _serviceService.getServiceStreamByBusiness(businessId!);
    stream.listen((snapshot) {
      final List<Map<String, dynamic>> dataService = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'name': data['name'],
          'price': data['price'],
        };
      }).toList();
      setState(() {
        services = dataService;
      });
    }, onError: (error) {
      setState(() {
        services = [];
        serviceSelected = null;
        _priceController.clear();
      });
    });
  }

  Future<void> _updateOrder() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (businessId == null ||
        customerSelected == null ||
        serviceSelected == null ||
        widget.order['id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faltan datos importantes para actualizar la orden'),
        ),
      );
      return;
    }
    try {
      final double total = double.tryParse(
            _priceController.text.replaceAll(RegExp(r'[^\d.]'), ''),
          ) ??
          0.0;
      final updatedData = {
        'customerId': customerId ?? '',
        'customerName': customerSelected!,
        'orderNumber': int.parse(_orderNumberController.text),
        'date': _dateController.text,
        'time': _timeController.text,
        'state': _stateController.text,
        'city': _cityController.text,
        'address': _addressController.text,
        'cp': _cpController.text,
        'service': serviceSelected!,
        'paymentMethod': selectedPaymentMethod!,
        'price': total,
        'note': _noteController.text,
      };
      await _salesService.updateSale(
        businessId: businessId!,
        orderId: widget.order['id'],
        data: updatedData,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orden actualizada exitosamente')),
      );
      context.go('/sales');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar la orden')),
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
                      value: customerSelected,
                      decoration: const InputDecoration(
                        labelText: 'Cliente',
                        border: OutlineInputBorder(),
                      ),
                      items: customers.map((customer) {
                        return DropdownMenuItem<String>(
                          value: customer['name'],
                          child: Text(customer['name']),
                        );
                      }).toList(),
                      onChanged: (String? nuevoCliente) {
                        final customer = customers.firstWhere(
                          (c) => c['name'] == nuevoCliente,
                          orElse: () => {},
                        );
                        setState(() {
                          customerId = customer['id'];
                          customerSelected = nuevoCliente;
                          _stateController.text = customer['state'];
                          _cityController.text = customer['city'];
                          _addressController.text = customer['address'];
                          _cpController.text = customer['cp'];
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
                    child: Input(
                      controller: _stateController,
                      label: 'Estado',
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Input(
                      controller: _cityController,
                      label: 'Ciudad',
                      readOnly: true,
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
                      readOnly: true,
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
                      readOnly: true,
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
              const Text(
                'Servicio',
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
                      value: serviceSelected,
                      items: services.map((service) {
                        return DropdownMenuItem<String>(
                          value: service['name'],
                          child: Text(service['name']),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Servicio',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String? nuevoServicio) {
                        setState(() {
                          serviceSelected = nuevoServicio;
                          final service = services.firstWhere(
                            (s) => s['name'] == nuevoServicio,
                            orElse: () => {'price': 0},
                          );
                          _priceController.text = service['price'].toString();
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
                    child: Select<String>(
                      value: selectedPaymentMethod,
                      items: const [
                        DropdownMenuItem(
                          value: 'Efectivo',
                          child: Text('Efectivo'),
                        ),
                        DropdownMenuItem(
                          value: 'Tarjeta',
                          child: Text('Tarjeta'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Método de pago',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPaymentMethod = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione un método de pago';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${(double.tryParse(_priceController.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
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
                      title: 'Actualizar orden',
                      onPressed: _updateOrder,
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
