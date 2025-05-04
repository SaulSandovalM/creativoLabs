import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final CollectionReference ordersRef =
      FirebaseFirestore.instance.collection('orders');

  // Obtener órdenes de un cliente específico
  Future<List<QueryDocumentSnapshot>> getOrdersByCustomer(
      String customerId) async {
    QuerySnapshot snapshot = await ordersRef
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs;
  }

  // Obtener órdenes de un negocio específico
  Stream<QuerySnapshot> getOrdersStreamByBusiness(String businessId) {
    return ordersRef
        .where('businessId', isEqualTo: businessId)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots();
  }

  // Obtener órdenes de un negocio filtradas por estado
  Future<List<QueryDocumentSnapshot>> getOrdersByBusinessAndStatus(
      String businessId, String status) async {
    QuerySnapshot snapshot = await ordersRef
        .where('businessId', isEqualTo: businessId)
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs;
  }

  // Stream en tiempo real para un cliente
  Stream<QuerySnapshot> getOrdersStreamByCustomer(String customerId) {
    return ordersRef
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
