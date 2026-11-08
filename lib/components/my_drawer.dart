// lib/components/my_drawer.dart
import 'package:flutter/material.dart';
import 'package:food_app/components/my_drawer_tile.dart';
import 'package:food_app/model/restaurant.dart';
import 'package:food_app/pages/orders_page.dart';
import 'package:food_app/pages/settings_page.dart';
import 'package:food_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  Future<void> _logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      context.read<Restaurant>().clearCart();
      await AuthService().signOut();
      navigator.popUntil((route) => route.isFirst);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not log out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colors.surface,
      child: Column(
        children: [
          // app logo
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Icon(
              Icons.fastfood,
              size: 60,
              color: colors.inversePrimary,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Divider(color: colors.secondary),
          ),

          // home tile
          MyDrawerTile(
            text: "H O M E",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),

          // orders tile
          MyDrawerTile(
            text: "O R D E R S",
            icon: Icons.receipt_long,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrdersPage()),
              );
            },
          ),

          // settings tile
          MyDrawerTile(
            text: "S E T T I N G S",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),

          const Spacer(),

          // logout tile
          MyDrawerTile(
            text: "L O G O U T",
            icon: Icons.logout,
            onTap: () => _logout(context),
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}