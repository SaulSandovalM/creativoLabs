import 'package:cloud_firestore/cloud_firestore.dart';

class CustomersService {
  final CollectionReference customersRef =
      FirebaseFirestore.instance.collection('business');
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('users');

  // Obtener clientes de un negocio específico
  Stream<QuerySnapshot> getCustomersStreamByBusiness(String businessId) {
    return customersRef
        .doc(businessId)
        .collection('customers')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Obtener un cliente por ID
  Future<Map<String, dynamic>?> getCustomerById({
    required String businessId,
    required String customerId,
  }) async {
    final doc = await customersRef
        .doc(businessId)
        .collection('customers')
        .doc(customerId)
        .get();

    if (doc.exists) {
      return {
        ...doc.data()!,
        'id': doc.id,
      };
    } else {
      return null;
    }
  }

  /// Elimina un cliente por su ID en Firestore.
  Future<void> deleteCustomer({
    required String businessId,
    required String customerId,
  }) async {
    await customersRef
        .doc(businessId)
        .collection('customers')
        .doc(customerId)
        .delete();
  }

  // Crear un nuevo cliente y dirección
  Future<void> addCustomerWithAddress({
    required String businessId,
    required Map<String, dynamic> customerData,
    // required Map<String, dynamic> addressData,
  }) async {
    try {
      // Referencia a la colección de clientes bajo un negocio específico
      final customerRef = customersRef.doc(businessId).collection('customers');

      // 1. Crear el cliente
      await customerRef.add({
        ...customerData,
        'businessId': businessId,
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

  Future<void> updateCustomer({
    required String businessId,
    required String customerId,
    required Map<String, dynamic> customerData,
  }) async {
    final docRef =
        customersRef.doc(businessId).collection('customers').doc(customerId);
    await docRef.update(customerData);
  }

  Future<void> createCustomerForUser({
    required String userId,
    required String name,
    required String lastName,
    required String secondLastName,
    required String email,
    required String phoneNumber,
    required String company,
    required String status,
    required String? state,
    required String city,
    required String address,
    required String cp,
  }) async {
    await userRef.doc(userId).set({
      'name': name,
      'lastName': lastName,
      'secondLastName': secondLastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'company': company,
      'status': status,
      'state': state,
      'city': city,
      'address': address,
      'cp': cp,
      'role': 'customer',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Future<String?> getCustomerIdByUser() async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid == null) return null;

  //   final doc = await userRef.doc(uid).get();

  //   if (doc.exists) {
  //     debugPrint('Customer encontrado: ${doc.id}');
  //     return doc.id;
  //   }

  //   debugPrint('No se encontró customer para UID: $uid');
  //   return null;
  // }
}
