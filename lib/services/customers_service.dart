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
}
