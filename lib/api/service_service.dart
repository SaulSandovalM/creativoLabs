import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceService {
  final CollectionReference servicesRef =
      FirebaseFirestore.instance.collection('business');

  // Obtener servicios de un negocio específico
  Stream<QuerySnapshot> getServiceStreamByBusiness(String businessId) {
    return servicesRef
        .doc(businessId)
        .collection('services')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> addService({
    required String businessId,
    required Map<String, dynamic> serviceData,
  }) async {
    try {
      // Referencia a la subcolección de servicios dentro de un negocio específico
      final servicesCollection =
          servicesRef.doc(businessId).collection('services');

      await servicesCollection.add({
        ...serviceData,
        'businessId': businessId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
