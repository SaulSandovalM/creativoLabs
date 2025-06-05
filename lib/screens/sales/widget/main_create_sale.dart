import 'package:creativolabs/api/customers_service.dart';
// import 'package:creativolabs/api/sales_service.dart';
import 'package:creativolabs/providers/business_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainCreateSale extends StatefulWidget {
  const MainCreateSale({super.key});

  @override
  State<MainCreateSale> createState() => _MainCreateSaleState();
}

class _MainCreateSaleState extends State<MainCreateSale> {
  // final _formKey = GlobalKey<FormState>();
  // final CustomersService _customersService = CustomersService();
  // final SalesService _salesService = SalesService();

  // String? clienteSeleccionado;
  // String? estadoSeleccionado;
  // String? dropdownValue;
  // String numeroOrden = '';

  // List<String> clientes = [];
  // final List<String> estados = [
  //   'Aguascalientes',
  //   'Baja California',
  //   'Baja California Sur',
  //   'Campeche',
  //   'Chiapas',
  //   'Chihuahua',
  //   'Ciudad de México',
  //   'Coahuila',
  //   'Colima',
  //   'Durango',
  //   'Estado de México',
  //   'Guanajuato',
  //   'Guerrero',
  //   'Hidalgo',
  //   'Jalisco',
  //   'Michoacán',
  //   'Morelos',
  //   'Nayarit',
  //   'Nuevo León',
  //   'Oaxaca',
  //   'Puebla',
  //   'Querétaro',
  //   'Quintana Roo',
  //   'San Luis Potosí',
  //   'Sinaloa',
  //   'Sonora',
  //   'Tabasco',
  //   'Tamaulipas',
  //   'Tlaxcala',
  //   'Veracruz',
  //   'Yucatán',
  //   'Zacatecas'
  // ];

  // String formatDate(DateTime date) {
  //   return DateFormat('dd MMMM yyyy', 'es').format(date);
  // }

  // final TextEditingController _dateController = TextEditingController();
  // final TextEditingController _timeController = TextEditingController();
  // final TextEditingController _orderNumberController = TextEditingController();

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? selectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2100),
  //     locale: const Locale('es', 'ES'),
  //   );

  //   if (selectedDate != null) {
  //     _dateController.text = formatDate(selectedDate);

  // _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
  // _dateController.text = formatDate(selectedDate);
  //   }
  // }

  // Future<void> _generarNumeroOrden() async {
  //   int nextOrderNumber = await _salesService.getLastSalesNumber();
  //   setState(() {
  //     _orderNumberController.text = nextOrderNumber.toString();
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _cargarClientes();
  //   _generarNumeroOrden();
  // }

  // Future<void> _cargarClientes() async {
  //   try {
  //     final stream = _customersService.getCustomersStreamByBusiness('bus_456');
  //     stream.listen((snapshot) {
  //       final List<String> clientesList =
  //           snapshot.docs.map((doc) => doc['name'] as String).toList();
  //       setState(() {
  //         clientes = clientesList;
  //         if (clientes.isNotEmpty) {
  //           clienteSeleccionado = clientes.first;
  //         }
  //       });
  //     });
  //   } catch (e) {
  //     debugPrint('Error al cargar clientes: $e');
  //   }
  // }

  // @override
  // void dispose() {
  //   _timeController.dispose();
  //   super.dispose();
  // }

  final _formKey = GlobalKey<FormState>();

  List<String> clientes = [];
  String? clienteSeleccionado;
  String? customerId;
  String? businessId;

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

  String? estadoSeleccionado;
  final TextEditingController _orderNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _shippingController = TextEditingController();

  final CustomersService _customersService = CustomersService();
  // final SalesService _salesService = SalesService();

  double subtotal = 1000.0;
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    _cargarClientes();
    // _generarNumeroOrden();
  }

  Future<void> _cargarClientes() async {
    try {
      final businessId =
          Provider.of<BusinessModel>(context, listen: false).businessId;
      if (businessId == null) return;

      final stream = _customersService.getCustomersStreamByBusiness(businessId);
      stream.listen((snapshot) {
        final List<String> clientesList =
            snapshot.docs.map((doc) => doc['name'] as String).toList();
        setState(() {
          clientes = clientesList;
          if (clientes.isNotEmpty) clienteSeleccionado = clientes.first;
        });
      }, onError: (error) {
        debugPrint('Error al cargar clientes: $error');
        setState(() {
          clientes = [];
          clienteSeleccionado = null;
        });
      });
    } catch (e) {
      debugPrint('Excepción al cargar clientes: $e');
      setState(() {
        clientes = [];
        clienteSeleccionado = null;
      });
    }
  }

  // Future<void> _generarNumeroOrden() async {
  //   if (businessId == null) return;
  //   debugPrint('Business ID: $businessId');
  //   int nextOrderNumber = await _salesService.getLastSalesNumber(businessId!);
  //   // debugPrint('Next order number: $nextOrderNumber');
  //   setState(() {
  //     _orderNumberController.text = nextOrderNumber.toString();
  //   });
  // }

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

  Future<void> _submitSale() async {
    //   if (_formKey.currentState?.validate() ?? false) {
    //     final businessId = Provider.of<BusinessModel>(context, listen: false).businessId;
    //     if (businessId == null) return;

    //     try {
    //       final now = DateTime.now();
    //       final discount = double.tryParse(_discountController.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    //       final shipping = double.tryParse(_shippingController.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    //       total = subtotal - discount + shipping;

    //       final saleData = {
    //         'orderNumber': int.parse(_orderNumberController.text),
    //         'createdAt': now,
    //         'customerName': clienteSeleccionado,
    //         'customerId': customerId ?? '',
    //         'date': _dateController.text,
    //         'time': _timeController.text,
    //         'location': {
    //           'estado': estadoSeleccionado,
    //           'ciudad': _cityController.text,
    //           'direccion': _addressController.text,
    //           'cp': _cpController.text,
    //         },
    //         'note': _noteController.text,
    //         'discount': discount,
    //         'shipping': shipping,
    //         'subtotal': subtotal,
    //         'total': total,
    //         'status': 'Pendiente',
    //       };

    //       await FirebaseFirestore.instance
    //           .collection('business')
    //           .doc(businessId)
    //           .collection('sales')
    //           .add(saleData);

    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(content: Text('Venta registrada exitosamente')),
    //       );

    //       Navigator.pop(context);
    //     } catch (e) {
    //       debugPrint('Error al guardar la venta: $e');
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(content: Text('Error al guardar la venta')),
    //       );
    //     }
    //   }
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
    _discountController.dispose();
    _shippingController.dispose();
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
                    child: DropdownButtonFormField<String>(
                      value: clienteSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Cliente',
                        border: OutlineInputBorder(),
                      ),
                      items: clientes.map((String cliente) {
                        return DropdownMenuItem<String>(
                          value: cliente,
                          child: Text(cliente),
                        );
                      }).toList(),
                      onChanged: (String? nuevoCliente) {
                        setState(() {
                          clienteSeleccionado = nuevoCliente;
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
                    child: TextFormField(
                      controller: _orderNumberController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Orden',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Día',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_month),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona un día';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      readOnly: true,
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
                    child: DropdownButtonFormField<String>(
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
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Ciudad',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una ciudad';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Dirección',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una dirección';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'CP',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un código postal';
                        }
                        if (value.length != 5) {
                          return 'El código postal debe tener 5 dígitos';
                        }
                        return null;
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
                    child: TextFormField(
                      maxLines: 5,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        labelText: 'Nota',
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
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Descuento',
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
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Envio',
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
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 350,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Subtotal'),
                                  const Text('\$1000.00'),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Descuento'),
                                  const Text('\$1000.00'),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Envio'),
                                  const Text('\$1000.00'),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total'),
                                  const Text('\$1000.00'),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: _submitSale,
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Color(0xFFf8f1fa),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 18,
                                      ),
                                    ),
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: _submitSale,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 18,
                                      ),
                                    ),
                                    child: const Text(
                                      'Guardar venta',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
