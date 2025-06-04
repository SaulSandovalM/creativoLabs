import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BusinessService {
  final CollectionReference businessRef =
      FirebaseFirestore.instance.collection('business');
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('users');

  /// Crea un negocio y actualiza el perfil del usuario con el negocioId.
  Future<void> createBusinessForUser({
    required String userId,
    required String name,
    required String lastName,
    required String email,
  }) async {
    // 1. Crear el negocio
    final negocioRef = await businessRef.add({
      'name': '$name $lastName',
      'ownerId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final businessId = negocioRef.id;

    // 2. Guardar el perfil del usuario con el businessId
    await userRef.doc(userId).set({
      'name': name,
      'lastName': lastName,
      'email': email,
      'businessId': businessId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Obtiene el businessId del usuario actual.
  Future<String?> getBusinessIdByUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    debugPrint('Current User ID: $uid');
    if (uid == null) return null;

    final querySnapshot =
        await businessRef.where('ownerId', isEqualTo: uid).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    }

    return null;
  }
}
