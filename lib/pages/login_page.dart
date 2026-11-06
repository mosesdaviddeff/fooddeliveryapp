import 'package:flutter/material.dart';
import 'package:food_app/components/my_button.dart';
import 'package:food_app/components/my_textfield.dart';
import 'package:food_app/pages/home_page.dart';
import 'package:food_app/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controllers
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

  //lgin method
  void login() async {
// get instance of auth service
final authService = AuthService();

// try sign in
  try {
    await authService.signInWithEmailPassword(
      emailController.text,
      passwordController.text
      );
  }
//display any errors
catch (e) {
  showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text(e.toString()),
    ) 
    );
}

  //navigate to the home page
  Navigator.push(context, MaterialPageRoute(
    builder: (context) => const HomePage(),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.fastfood, 
              size: 100, 
              color: Theme.of(context).colorScheme.inversePrimary),

            const SizedBox(height: 20),

            // app slogan
              Text("Food Delivery App",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.inversePrimary,
              )),

                 const SizedBox(height: 20),

            //  email textfield
            MyTextField(
              controller: emailController, 
              hintText: 'Email', 
              obscureText: false
            ),

            const SizedBox(height: 20),

            //password textfield
           MyTextField(
              controller: passwordController, 
              hintText: 'Password', 
              obscureText: true,
            ),
            const SizedBox(height: 20),
            //signin button
            MyButton(
              text: "Sign In",
              onTap: () {
                login();
                },
            ),

            const SizedBox(height: 20),
            //not registered? register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Register now",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}