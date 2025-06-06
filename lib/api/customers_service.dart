import 'package:cloud_firestore/cloud_firestore.dart';

class CustomersService {
  final CollectionReference customersRef =
      FirebaseFirestore.instance.collection('business');

  // Obtener clientes de un negocio específico
  Stream<QuerySnapshot> getCustomersStreamByBusiness(String businessId) {
    return customersRef
        .doc(businessId)
        .collection('customers')
        .orderBy('createdAt', descending: true)
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
    required String businessId,
    required Map<String, dynamic> customerData,
    required Map<String, dynamic> addressData,
  }) async {
    try {
      // Referencia a la colección de clientes bajo un negocio específico
      final customerRef = customersRef.doc(businessId).collection('customers');

      // 1. Crear el cliente
      final nuevoCliente = await customerRef.add({
        ...customerData,
        'businessId': businessId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Crear dirección como subcolección del nuevo cliente
      await nuevoCliente.collection('addresses').add({
        ...addressData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
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
