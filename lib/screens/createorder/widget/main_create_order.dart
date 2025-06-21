import 'package:creativolabs/api/sales_service.dart';
import 'package:creativolabs/api/service_service.dart';
import 'package:creativolabs/core/widgets/button.dart';
import 'package:creativolabs/core/widgets/input.dart';
import 'package:creativolabs/core/widgets/select.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class MainCreateOrder extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  final String servicePrice;

  const MainCreateOrder({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
  });

  @override
  State<MainCreateOrder> createState() => _MainCreateOrderState();
}

class _MainCreateOrderState extends State<MainCreateOrder> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> services = [];

  String? serviceSelected;
  String? selectedPaymentMethod;
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

  final _priceController = TextEditingController();
  final TextEditingController _orderNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _secondLastNameController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final SalesService _salesService = SalesService();
  final ServiceService _serviceService = ServiceService();

  double total = 0.0;

  @override
  void initState() {
    super.initState();
    serviceSelected = widget.serviceName;
    _priceController.text = widget.servicePrice;
    _generateOrderNumber();
    _loadServices();
  }

  Future<void> _generateOrderNumber() async {
    debugPrint('Generating order number for service: ${widget.serviceId}');
    int nextOrderNumber =
        await _salesService.getLastSalesNumber(widget.serviceId);
    setState(() {
      _orderNumberController.text = nextOrderNumber.toString();
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'es').format(date);
  }

  DateTime? getSelectedDateTime() {
    if (_dateController.text.isEmpty || _timeController.text.isEmpty) {
      return null;
    }
    try {
      final date = DateFormat('dd MMMM yyyy', 'es').parse(_dateController.text);
      final time =
          TimeOfDay.fromDateTime(DateFormat.Hm().parse(_timeController.text));
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    } catch (e) {
      return null;
    }
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
    final stream = _serviceService.getServiceStreamByBusiness(widget.serviceId);
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

  Future<void> _submitOrder() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (serviceSelected == null) {
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

      final dateTimeStamp = getSelectedDateTime();

      await _salesService.saveSaleCustomer(
        businessId: widget.serviceId,
        customerName: _nameController.text,
        customerLastName: _lastNameController.text,
        customerSecondLastName: _secondLastNameController.text,
        orderNumber: int.parse(_orderNumberController.text),
        date: _dateController.text,
        time: _timeController.text,
        dateTimeStamp: dateTimeStamp,
        state: stateSelected!,
        city: _cityController.text,
        address: _addressController.text,
        cp: _cpController.text,
        service: serviceSelected!,
        paymentMethod: selectedPaymentMethod!,
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
                    child: Input(
                      controller: _nameController,
                      label: 'Nombre',
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Input(
                      controller: _lastNameController,
                      label: 'Apellido',
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
                      label: 'Segundo Apellido',
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
