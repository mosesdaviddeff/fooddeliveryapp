import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/services/database/firestore.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Just now";
    final dt = timestamp.toDate();
    return DateFormat('MMM dd, yyyy - hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: colors.surface,
        foregroundColor: colors.inversePrimary,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreService.getUserOrdersStream(),
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // error
          if (snapshot.hasError) {
            final errorMsg = snapshot.error.toString();
            final isPermission = errorMsg.contains('permission-denied');

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: colors.error),
                    const SizedBox(height: 16),
                    Text(
                      isPermission
                          ? "Firestore permission denied.\nPlease make sure your Firebase Security Rules allow read access for authenticated users."
                          : "Could not load orders:\n$errorMsg",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.error, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          }

          final docs = List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
            snapshot.data?.docs ?? [],
          );

          // Sort in memory by date descending (avoids requiring a Firestore composite index)
          docs.sort((a, b) {
            final aDate = a.data()['date'] as Timestamp?;
            final bDate = b.data()['date'] as Timestamp?;
            if (aDate == null && bDate == null) return 0;
            if (aDate == null) return 1;
            if (bDate == null) return -1;
            return bDate.compareTo(aDate);
          });

          // empty state
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: colors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No orders yet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your past orders will appear here.",
                    style: TextStyle(color: colors.primary),
                  ),
                ],
              ),
            );
          }

          // order list
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final timestamp = data['date'] as Timestamp?;
              final receipt = (data['order'] as String?) ?? 'No receipt details';

              return Card(
                color: colors.secondary,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: colors.tertiary.withOpacity(0.3),
                  ),
                ),
                elevation: 0,
                child: ExpansionTile(
                  iconColor: colors.inversePrimary,
                  collapsedIconColor: colors.inversePrimary,
                  leading: Icon(
                    Icons.fastfood,
                    color: colors.primary,
                  ),
                  title: Text(
                    _formatTimestamp(timestamp),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colors.inversePrimary,
                    ),
                  ),
                  subtitle: Text(
                    "Order #${docs[index].id.substring(0, 6).toUpperCase()}",
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.primary,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colors.tertiary.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          receipt,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            color: colors.inversePrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
