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
    required DateTime? dateTimeStamp,
    required String state,
    required String city,
    required String address,
    required String cp,
    required String service,
    required String paymentMethod,
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
        'dateTimeStamp': dateTimeStamp,
        'state': state,
        'city': city,
        'address': address,
        'cp': cp,
        'service': service,
        'price': price,
        'note': note,
        'status': 'Pendiente',
        'paymentMethod': paymentMethod,
      };
      // debugPrint('Guardando venta: $saleData');
      await saleDoc.set(saleData);
    } catch (e) {
      throw Exception('Error al guardar la venta: $e');
    }
  }

  // Obtener un orden por su ID dentro de un negocio específico
  Future<Map<String, dynamic>?> getOrderById({
    required String businessId,
    required String orderId,
  }) async {
    final doc =
        await salesRef.doc(businessId).collection('orders').doc(orderId).get();
    if (doc.exists) {
      return {
        ...doc.data()!,
        'id': doc.id,
      };
    } else {
      return null;
    }
  }

  Future<void> updateSale({
    required String businessId,
    required String orderId,
    required Map<String, dynamic> data,
  }) async {
    final docRef = salesRef.doc(businessId).collection('orders').doc(orderId);
    await docRef.update(data);
  }

  Future<void> updateStatusSale({
    required String businessId,
    required String orderId,
    required Map<String, dynamic> data,
  }) async {
    await salesRef
        .doc(businessId)
        .collection('orders')
        .doc(orderId)
        .update(data);
  }

  // Contar el número de órdenes de un negocio específico
  Future<int> getOrdersCount(String businessId, String type) async {
    final snapshot = await salesRef
        .doc(businessId)
        .collection('orders')
        .where('status', isEqualTo: type)
        .get();
    return snapshot.docs.length;
  }

  // Contar el número de clientes en un negocio específico
  Future<int> getCustomersCountByBusiness(String businessId) async {
    final snapshot =
        await salesRef.doc(businessId).collection('customers').get();
    return snapshot.docs.length;
  }

  // Obtener los próximos eventos de un negocio específico
  Stream<List<Map<String, dynamic>>> getUpcomingEvents(String businessId) {
    final now = Timestamp.now();
    return salesRef
        .doc(businessId)
        .collection('orders')
        .where('dateTimeStamp', isGreaterThanOrEqualTo: now)
        .orderBy('dateTimeStamp')
        .limit(4)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }
}
