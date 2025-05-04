import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteService {
  final CollectionReference customersRef =
      FirebaseFirestore.instance.collection('customers');

  Future<List<String>> getCustomers() async {
    try {
      final snapshot = await customersRef.orderBy('name').get();
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      return [];
    }
  }
}
