import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> orders = FirebaseFirestore
      .instance
      .collection('orders');

  Future<void> saveOrderToDatabase(String receipt) async {
    await orders.add({'date': FieldValue.serverTimestamp(), 'order': receipt});
  }
}
