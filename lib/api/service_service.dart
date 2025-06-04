import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceService {
  final CollectionReference serviceRef =
      FirebaseFirestore.instance.collection('services');

  // Obtener servicios de un negocio específico
  Stream<QuerySnapshot> getServiceStreamByBusiness(String businessId) {
    return serviceRef
        .where('businessId', isEqualTo: businessId)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots();
  }
}
