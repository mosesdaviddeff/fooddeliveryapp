import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> orders = FirebaseFirestore
      .instance
      .collection('orders');

  Future<void> saveOrderToDatabase(String receipt) async {
    final user = FirebaseAuth.instance.currentUser;
    await orders.add({
      'userId': user?.uid,
      'userEmail': user?.email,
      'date': FieldValue.serverTimestamp(),
      'order': receipt,
    });
  }

  // stream of orders for currently logged in user
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserOrdersStream() {
    final user = FirebaseAuth.instance.currentUser;
    return orders
        .where('userId', isEqualTo: user?.uid)
        .orderBy('date', descending: true)
        .snapshots();
  }
}
