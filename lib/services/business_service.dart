import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessService {
  final CollectionReference businessRef =
      FirebaseFirestore.instance.collection('business');
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('users');

  /// Crea un negocio y actualiza el perfil del usuario con el negocioId.
  Future<void> createBusinessForUser({
    required String userId,
    required String nombre,
    required String apellido,
    required String email,
  }) async {
    // 1. Crear el negocio
    final negocioRef = await businessRef.add({
      'nombre': '$nombre $apellido',
      'ownerId': userId,
      'creadoEn': FieldValue.serverTimestamp(),
    });

    final negocioId = negocioRef.id;

    // 2. Guardar el perfil del usuario con el negocioId
    await userRef.doc(userId).set({
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'negocioId': negocioId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
