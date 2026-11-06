// food item

class Food {
  final String name;              //cheese burger
  final String description;       //burger full of cheese
  final String imagePath;        //lib/images/chooseburger.png
  final double price;           // $4.99
  final FoodCategory category;  //burger
  List<Addon> availableAddons;  //extra cheese

  Food({required this.name,
        required this. description,
        required this.imagePath,
        required this.price,
        required this.category,
        required this.availableAddons,

        });

}

//food categories

enum FoodCategory {
  burgers,
  salad,
  sides,
  dessert,
  drinks,
}

// food addons

class Addon {
  String name;
  double price;

  Addon({
    required this.name,
    required this.price
  });

}