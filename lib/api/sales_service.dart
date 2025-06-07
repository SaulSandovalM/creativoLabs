import 'package:cloud_firestore/cloud_firestore.dart';

class SalesService {
  final CollectionReference salesRef =
      FirebaseFirestore.instance.collection('business');

  // Obtener órdenes de un cliente específico
  Future<List<QueryDocumentSnapshot>> getSalesByCustomer(
      String customerId) async {
    QuerySnapshot snapshot = await salesRef
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs;
  }

  // Obtener órdenes de un negocio específico
  Stream<QuerySnapshot> getSalesStreamByBusiness(String businessId) {
    return salesRef
        .doc(businessId)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Obtener órdenes de un negocio filtradas por estado
  Future<List<QueryDocumentSnapshot>> getSalesByBusinessAndStatus(
      String businessId, String status) async {
    QuerySnapshot snapshot = await salesRef
        .where('businessId', isEqualTo: businessId)
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs;
  }

  // Stream en tiempo real para un cliente
  Stream<QuerySnapshot> getSalesStreamByCustomer(String customerId) {
    return salesRef
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Obtiene el número de la última orden registrada en la colección 'Seles'.
  // Si no hay órdenes, devuelve 1 como número inicial.
  Future<int> getLastSalesNumber(String businessId) async {
    try {
      final QuerySnapshot snapshot = await salesRef
          .doc(businessId)
          .collection('orders')
          .orderBy('orderNumber', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final lastOrder = snapshot.docs.first;
        return (lastOrder['orderNumber'] ?? 0) + 1;
      } else {
        return 1;
      }
    } catch (e) {
      return 1;
    }
  }

  Future<void> saveSale({
    required String businessId,
    required String customerId,
    required String customerName,
    required int orderNumber,
    required String date,
    required String time,
    required String state,
    required String city,
    required String address,
    required String cp,
    required String service,
    required double price,
    required String note,
  }) async {
    try {
      final DocumentReference saleDoc =
          salesRef.doc(businessId).collection('orders').doc();
      final saleData = {
        'customerId': customerId,
        'orderNumber': orderNumber,
        'customerName': customerName,
        'createdAt': FieldValue.serverTimestamp(),
        'date': date,
        'time': time,
        'state': state,
        'city': city,
        'address': address,
        'cp': cp,
        'service': service,
        'price': price,
        'note': note,
        'status': 'Pendiente',
      };
      // debugPrint('Guardando venta: $saleData');
      await saleDoc.set(saleData);
    } catch (e) {
      throw Exception('Error al guardar la venta: $e');
    }
  }
}
