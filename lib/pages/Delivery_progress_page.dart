// ignore_for_file: file_names

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/my_reciept.dart';
import 'package:food_app/model/restaurant.dart';
import 'package:food_app/services/database/firestore.dart';
import 'package:provider/provider.dart';

class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({super.key});

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  final FirestoreService db = FirestoreService();
  late final String _receipt;
  bool _isSavingOrder = true;
  bool _orderSaved = false;
  String? _saveError;

  @override
  void initState() {
    super.initState();

    _receipt = context.read<Restaurant>().displayCartReciept();
    _saveOrder();

    // Clear cart once receipt is generated so it's fresh for next order
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<Restaurant>().clearCart();
      }
    });
  }

  Future<void> _saveOrder() async {
    setState(() {
      _isSavingOrder = true;
      _orderSaved = false;
      _saveError = null;
    });

    try {
      await db.saveOrderToDatabase(_receipt);
      if (!mounted) return;
      setState(() {
        _isSavingOrder = false;
        _orderSaved = true;
      });
    } on FirebaseException catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'order submission',
        ),
      );
      if (!mounted) return;
      setState(() {
        _isSavingOrder = false;
        _saveError =
            'Could not save your order (${error.code}): '
            '${error.message ?? 'Check your connection and Firestore rules.'}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: Column(
        children: [
          const MyReciept(),
          if (_isSavingOrder) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 8),
            const Text('Saving your order...'),
          ] else if (_saveError != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _saveError!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            TextButton(onPressed: _saveOrder, child: const Text('Retry')),
          ] else if (_orderSaved) ...[
            const Text('Order saved successfully.'),
          ],
        ],
      ),
    );
  }

  // custom bottom nav bar -  message / call delivery driver
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        )
      ),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          //profile pic of driver
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle
            ),
            child: IconButton(
              onPressed: () {}, 
              icon: const Icon(Icons.person)),
          ),
            const SizedBox(width: 10),

          //driver details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Moses Deff", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),),
              Text("Driver", style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),),
            ],
          ),

          const Spacer(),

            Row(
              children: [
                //message btn
                Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle
            ),
            child: IconButton(
              onPressed: () {}, 
              icon: const Icon(Icons.message),
              color: Theme.of(context).colorScheme.primary,
              ),
          ),

              const SizedBox(width: 10),

                //call btn
                Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle
            ),
            child: IconButton(
              onPressed: () {}, 
              icon: const Icon(Icons.call),
              color: Colors.green,
              
              ),
          ),
              ],
            )
        ],
      ),
    );
  }
}
