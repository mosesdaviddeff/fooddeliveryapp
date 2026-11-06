import 'package:flutter/material.dart';
import 'package:food_app/components/my_button.dart';
import 'package:food_app/components/my_cart_tile.dart';
import 'package:food_app/model/restaurant.dart';
import 'package:food_app/pages/payment_page.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(builder: (context, restaurant, child) {
      // cart
      final userCart = restaurant.cart;

      //scaffold UI
      return Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            //clear cart
            IconButton(onPressed: () {
              showDialog(context: context, builder: (context) => AlertDialog(
                title: const Text("Are you sure you want to clear the cart?"),
                actions: [
                  //cancel btn
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel")),
                  // yes btn
                  TextButton(
                    onPressed: ()  { 
                      Navigator.pop(context);
                  restaurant.clearCart();
                    },
                  child: const Text("Yes")),
                ],
              ));
            }, 
            icon: const Icon(Icons.delete),
            ),
          ],

        ),
        body: Column(
          children: [

            //List of cart
            Expanded(
              child: Column(
                children: [
                  userCart.isEmpty 
                  ? const Expanded(
                    child: Center(
                      child:  Text("Cart is empty!"))) 
                  :Expanded(
                    child: ListView.builder(
                      itemCount: userCart.length,
                      itemBuilder: (context, index) {
              
                        //get individual cart item
                        final cartItem = userCart[index];
              
                        //return cart tile UI
                        return MyCartTile(cartItem: cartItem);
                      } 
                        ),
                        ),
                ],
              ),
            ),
             // button to pay
             MyButton(onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentPage())),

             text: "Go to Checkout"),

             const SizedBox(height: 25,)
          ],
        ),
       

      );
    });
  }
}