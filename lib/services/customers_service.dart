import 'package:cloud_firestore/cloud_firestore.dart';

class CustomersService {
  final CollectionReference customersRef =
      FirebaseFirestore.instance.collection('customers');

  // Obtener clientes de un negocio específico
  Stream<QuerySnapshot> getCustomersStreamByBusiness(String businessId) {
    return customersRef
        .where('businessId', isEqualTo: businessId)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots();
  }

  // Obtener un cliente por ID
  Future<Map<String, dynamic>?> getCustomerById(String id) async {
    final doc = await customersRef.doc(id).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  /// Elimina un cliente por su ID en Firestore.
  Future<void> deleteCustomerById(String id) async {
    await customersRef.doc(id).delete();
  }

  // Crear un nuevo cliente y dirección
  Future<void> addCustomerWithAddress({
    required Map<String, dynamic> customerData,
    required Map<String, dynamic> addressData,
  }) async {
    final customerRef = customersRef;

    // 1. Crear el cliente
    final nuevoCliente = await customerRef.add({
      ...customerData,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 2. Crear dirección como subcolección del nuevo cliente
    await nuevoCliente.collection('direcciones').add({
      ...addressData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Agregar una dirección a un cliente existente
  Future<void> addAddress({
    required String customerId,
    required Map<String, dynamic> addressData,
  }) async {
    final customerRef = customersRef.doc(customerId).collection('direcciones');

    await customerRef.add({
      ...addressData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
