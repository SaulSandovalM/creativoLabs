import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  // guardar un nuevo servicio
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

  // Obtener un servicio por su ID dentro de un negocio específico
  Future<DocumentSnapshot?> getServiceById({
    required String businessId,
    required String serviceId,
  }) async {
    final doc = await servicesRef
        .doc(businessId)
        .collection('services')
        .doc(serviceId)
        .get();
    return doc.exists ? doc : null;
  }

  // Actualizar un servicio por su ID dentro de un negocio específico
  Future<void> updateService({
    required String businessId,
    required String serviceId,
    required Map<String, dynamic> serviceData,
  }) async {
    await servicesRef
        .doc(businessId)
        .collection('services')
        .doc(serviceId)
        .update(serviceData);
  }

  /// Elimina un servicio por su ID dentro de un negocio específico
  Future<void> deleteService({
    required String businessId,
    required String serviceId,
  }) async {
    try {
      final serviceDoc =
          servicesRef.doc(businessId).collection('services').doc(serviceId);
      await serviceDoc.delete();
    } catch (e) {
      rethrow;
    }
  }

  // Buscar todos los servicios por categoría
  Stream<List<Map<String, dynamic>>> searchAllServicesByCategory(
      String category) {
    return FirebaseFirestore.instance
        .collectionGroup('services')
        .where('category', arrayContains: category)
        .snapshots()
        .map((snapshot) {
      debugPrint('Snapshot data: ${snapshot.docs.length} documents found.');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    }).handleError((error, stackTrace) {
      debugPrint('Error en searchAllServicesByCategory: $error');
      debugPrint('StackTrace: $stackTrace');
    });
  }
}
