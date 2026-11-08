import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/pages/verify_email_page.dart';
import 'package:food_app/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {
          // Firebase is checking auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // user is logged in (VerifyEmailPage will show HomePage if already verified)
          if (snapshot.hasData) {
            return const VerifyEmailPage();
          }

          // user is NOT logged in
          return const LoginOrRegister();
        },
      ),
    );
  }
}