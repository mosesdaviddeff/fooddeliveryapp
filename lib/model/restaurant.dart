import 'dart:async';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/model/cart_item.dart';
import 'package:food_app/model/food.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Restaurant extends ChangeNotifier {
  static const String defaultAddress = "Set your location";

  StreamSubscription<User?>? _authSubscription;
  String? _currentUserId;

  Restaurant() {
    _initAuthListener();
  }

  void _initAuthListener() {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // User logged out: clear cart and reset delivery address
        _currentUserId = null;
        _cart.clear();
        _deliveryAddress = defaultAddress;
        notifyListeners();
      } else if (_currentUserId != user.uid) {
        // New user or account switch: clear previous user's cart and load this user's location
        _currentUserId = user.uid;
        _cart.clear();
        _loadDeliveryAddressForUser(user.uid);
      }
    });
  }

  Future<void> _loadDeliveryAddressForUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('deliveryAddress_$userId');
    if (savedAddress != null && savedAddress.trim().isNotEmpty) {
      _deliveryAddress = savedAddress;
    } else {
      _deliveryAddress = defaultAddress;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  //list of food menu
  final List<Food> _menu = [
    Food(
      name: "Classic Cheese Burger", 
      description: "A juicy beef patty with melted cheddar, lettuce, tomato, and a hint of onion and pickle", 
      imagePath: "lib/images/burgers/cheese_burger.jpg", 
      price: 8.99, 
      category: FoodCategory.burgers, 
      availableAddons: [
        Addon(name: "Extra Cheese", price: 0.99),
        Addon(name: "Bacon", price: 1.99),
        Addon(name: "Avocado", price: 2.99),
      ],
      ),

      Food(
      name: "BBQ Bacon Burger", 
      description: "A juicy beef patty topped with smoky BBQ sauce, crispy bacon, melted cheddar, lettuce, tomato, and a hint of onion and pickle.", 
      imagePath: "lib/images/burgers/bbq_burger.jpg", 
      price: 10.99, 
      category: FoodCategory.burgers, 
      availableAddons: [
        Addon(name: "Grilled Onions", price: 1.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra BBQ Sauce", price: 2.99),
      ],
      ),

      Food(
      name: "Veggie Burger", 
      description: "A hearty veggie patty topped with smoky BBQ sauce, crispy bacon, melted cheddar, lettuce, tomato, and a hint of onion and pickle.", 
      imagePath: "lib/images/burgers/vege_burger.jpg", 
      price: 9.99, 
      category: FoodCategory.burgers, 
      availableAddons: [
        Addon(name: "Vegan Cheese", price: 2.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Grilled Mushrooms", price: 6.99),
      ],
      ),

      Food(
      name: "Aloha Burger", 
      description: "A juicy beef patty topped with smoky BBQ sauce, grilled pineapple, crispy bacon, melted cheddar, lettuce, tomato, and a hint of onion and pickle.", 
      imagePath: "lib/images/burgers/aloha_burger.jpg", 
      price: 11.99, 
      category: FoodCategory.burgers, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),
      Food(
      name: "Blue Melon Burger", 
      description: "A juicy beef patty topped with smoky BBQ sauce, grilled pineapple, crispy bacon, melted cheddar, lettuce, tomato, and a hint of onion and pickle.", 
      imagePath: "lib/images/burgers/aloha_burger.jpg", 
      price: 11.99, 
      category: FoodCategory.burgers, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      //salads
        Food(
      name: "Asian Sesame Salad", 
      description: "Crisp greens piled high with charred pineapple, smoky bacon crumbles, shredded cheddar, ripe tomato, and slivers of onion and pickle, all brought together with a tangy BBQ vinaigrette.", 
      imagePath: "lib/images/salads/asiansesame_salad.jpg", 
      price: 10.99, 
      category: FoodCategory.salad, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "Caeser Salad", 
      description: "Crisp greens piled high with charred pineapple, smoky bacon crumbles, shredded cheddar, ripe tomato, and slivers of onion and pickle, all brought together with a tangy BBQ vinaigrette.", 
      imagePath: "lib/images/salads/ceaser_salad.jpg", 
      price: 9.99, 
      category: FoodCategory.salad, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "Greek Salad", 
      description: "Crisp greens piled high with charred pineapple, smoky bacon crumbles, shredded cheddar, ripe tomato, and slivers of onion and pickle, all brought together with a tangy BBQ vinaigrette.", 
      imagePath: "lib/images/salads/greek_salad.jpg", 
      price: 7.99, 
      category: FoodCategory.salad, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "Quinoa Salad", 
      description: "Crisp greens piled high with charred pineapple, smoky bacon crumbles, shredded cheddar, ripe tomato, and slivers of onion and pickle, all brought together with a tangy BBQ vinaigrette.", 
      imagePath: "lib/images/salads/quinoa_salad.jpg", 
      price: 9.99, 
      category: FoodCategory.salad, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "Southwest Salad", 
      description: "Crisp greens piled high with charred pineapple, smoky bacon crumbles, shredded cheddar, ripe tomato, and slivers of onion and pickle, all brought together with a tangy BBQ vinaigrette.", 
      imagePath: "lib/images/salads/southwest_salad.jpg", 
      price: 9.99, 
      category: FoodCategory.salad, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),
      
      //sides
      Food(
      name: "Garlic Bread", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/sides/garlic_bread_side.jpg", 
      price: 6.99, 
      category: FoodCategory.sides, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "Loaded Fries", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/sides/loadedfries_sides.jpg", 
      price: 9.99, 
      category: FoodCategory.sides, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "Crispy Mac & Cheese", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/sides/mad_side.jpg", 
      price: 7.99, 
      category: FoodCategory.sides, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "Mashed Potatoes", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/sides/mashed_potato.jpg", 
      price: 9.99, 
      category: FoodCategory.sides, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "Onion Rings", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/sides/onion_rings.jpg", 
      price: 9.99, 
      category: FoodCategory.sides, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),
     
      //desserts
        Food(
      name: "Cake", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/desserts/cake.jpg", 
      price: 6.99, 
      category: FoodCategory.dessert, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),
      Food(
      name: "Coffee", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/desserts/coffee.jpg", 
      price: 4.99, 
      category: FoodCategory.dessert, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "Donought", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/desserts/donut.jpg", 
      price: 4.99, 
      category: FoodCategory.dessert, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "Pizza", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/desserts/pizza.jpg", 
      price: 4.99, 
      category: FoodCategory.dessert, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "Sidecake", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/desserts/sidecake.jpg", 
      price: 4.99, 
      category: FoodCategory.dessert, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      //drinks
      Food(
      name: "Coke", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/drinks/coca_cola.jpg", 
      price: 2.99, 
      category: FoodCategory.drinks, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "7up", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/drinks/7up.jpg", 
      price: 2.99, 
      category: FoodCategory.drinks, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "Fanta", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/drinks/fanta.jpg", 
      price: 5.99, 
      category: FoodCategory.drinks, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "Pepsi", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/drinks/pepsi.jpg", 
      price: 5.99, 
      category: FoodCategory.drinks, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),

      Food(
      name: "Sprite", 
      description: "A cool, crunchy slaw with shredded cabbage and carrots in a tangy vinaigrette — the perfect contrast to rich, smoky flavors.", 
      imagePath: "lib/images/drinks/sprite.jpg", 
      price: 5.99, 
      category: FoodCategory.drinks, 
      availableAddons: [
        Addon(name: "Teriyaki Glaze", price: 0.99),
        Addon(name: "Bacon", price: 3.49),
        Addon(name: "Extra Pineapple", price: 6.99),
      ],
      ),
  ];
  // user cart

final List<CartItem> _cart = [];

//delivery address - user can edit
String _deliveryAddress = defaultAddress;

// GETTERS

List<Food> get menu => _menu;
List<CartItem> get cart => _cart;
String get deliveryAddress => _deliveryAddress;


//OPERATIONS




// add to cart
void addToCart (Food food, List<Addon> selectedAddons){
  // see if there is a cart item with already same food and selected addons
  CartItem? cartItem = _cart.firstWhereOrNull((item) {
    // Check if the food items are the same
    bool isSameFood = item.food == food;

    //check if th list of selected addons are the same
    bool isSameAddons =  ListEquality().equals(item.selectedAddons, selectedAddons);

    return isSameFood && isSameAddons;
  });
  // if item already exists,  increase it's quantity
  if (cartItem != null) {
    cartItem.quantity++;
  }

  // otherwise add new cart item
  else {
    _cart.add(CartItem(
      food: food, 
      selectedAddons: selectedAddons),
      );
  }
  notifyListeners();
}

// remove from cart
void removeFromCart(CartItem cartItem) {
  int cartIndex = _cart.indexOf(cartItem);

  if (cartIndex != -1) {
    if (_cart[cartIndex].quantity > 1) {
      _cart[cartIndex].quantity--;
    } else {
      _cart.removeAt(cartIndex);
    }
  }

  notifyListeners();
}

//get total price of cart
double getTotalPrice() {
  double total = 0.0;

  for (CartItem cartItem in _cart) {
    double itemTotal = cartItem.food.price;

    for (Addon addon in cartItem.selectedAddons) {
      itemTotal += addon.price;
    }

    total += itemTotal * cartItem.quantity;
  }

  return total;
}

// get total number of items in cart
int getTotalItemCount () {
  int totalItemCount = 0;

  for (CartItem cartItem in _cart) {
    totalItemCount += cartItem.quantity;
  }

  return totalItemCount;
}

//clear cart
void clearCart() {
  _cart.clear();
  notifyListeners();
}

// update delivery address
void updateDeliveryAddress(String newAddress) async {
  final trimmed = newAddress.trim();
  _deliveryAddress = trimmed.isEmpty ? defaultAddress : trimmed;
  notifyListeners();

  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('deliveryAddress_${user.uid}', _deliveryAddress);
  }
}
//HELPERS
// generate reciept
  String displayCartReciept() {
    final reciept = StringBuffer();
    reciept.writeln("Here's your reciept: ");
    reciept.writeln();

    // format the date to include up to seconds only
    String formattedDate =  DateFormat('yyy-MM-dd HH:mm:ss').format(DateTime.now());

    reciept.writeln(formattedDate);
    reciept.writeln();
    reciept.writeln("------------------------------------------------------------------------");

    for (final cartItem in _cart) {
      reciept.writeln("${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}");
      if (cartItem.selectedAddons.isNotEmpty) {
        reciept.writeln("   Add-ons: ${_formatAddons(cartItem.selectedAddons)}");
      }
      reciept.writeln();
    }

    reciept.writeln("------------------------------------------------------------------------");
    reciept.writeln();
    reciept.writeln("Total Items: ${getTotalItemCount()}");
    reciept.writeln("Total Price: ${_formatPrice(getTotalPrice())}");
    reciept.writeln();
    reciept.writeln("Delivering to: $deliveryAddress");

    return reciept.toString();


  }
//format double value int money
String _formatPrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }
//format list of addons into string
String _formatAddons(List<Addon> addons) {
  return addons
  .map((addon) => "${addon.name} (${_formatPrice(addon.price)})")
  .join(", ");
}
      
 

} 