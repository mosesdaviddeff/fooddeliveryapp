import 'package:flutter/material.dart';
import 'package:food_app/model/restaurant.dart';
import 'package:provider/provider.dart';

class MyCurrentLocation extends StatelessWidget {
  const MyCurrentLocation({super.key});

  Future<void> openLocationSearchBox(BuildContext context) async {
    final textController = TextEditingController();

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Your Location"),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Enter address..."),
          ),
          actions: [

            //cancel address btn
            MaterialButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                textController.clear();
              },
              child: const Text("Cancel"),
            ),

            // save address btn
            MaterialButton(
              onPressed: () {
                context.read<Restaurant>().updateDeliveryAddress(
                  textController.text,
                );
                Navigator.pop(dialogContext);
                textController.clear();
              },
              child: const Text("Save"),
            ),
          ],
        ),
      );
    } finally {
      textController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deliver now",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () => openLocationSearchBox(context),
            child: Row(
              children: [
                //address
                Consumer<Restaurant>(
                  builder: (context, restaurant, child) =>
                      Text(restaurant.deliveryAddress),
                ),

                //drop down menu
                Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
