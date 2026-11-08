import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/pages/home_page.dart';
import 'package:food_app/services/auth/auth_service.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage>
    with WidgetsBindingObserver {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  int resendCooldown = 30;
  Timer? _authCheckTimer;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final user = FirebaseAuth.instance.currentUser;
    isEmailVerified = user?.emailVerified ?? false;

    if (!isEmailVerified) {
      // Start cooldown for resend button (initial email was sent on register)
      _startCooldown();

      // Check periodically if the user has clicked the link in Gmail
      _authCheckTimer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => _checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authCheckTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When user returns to the app from Gmail/browser, check immediately
    if (state == AppLifecycleState.resumed) {
      _checkEmailVerified();
    }
  }

  void _startCooldown() {
    setState(() {
      canResendEmail = false;
      resendCooldown = 30;
    });

    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (resendCooldown > 0) {
            resendCooldown--;
          } else {
            canResendEmail = true;
            timer.cancel();
          }
        });
      }
    });
  }

  Future<void> _checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();

    if (user != null && user.emailVerified) {
      _authCheckTimer?.cancel();
      if (mounted) {
        setState(() => isEmailVerified = true);
      }
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verification email sent! Check your Gmail.")),
        );
      }

      _startCooldown();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error sending verification: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;

    // If verified, proceed to HomePage
    if (isEmailVerified) {
      return const HomePage();
    }

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text("Verify Email"),
        backgroundColor: colors.surface,
        foregroundColor: colors.inversePrimary,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () => AuthService().signOut(),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // mail icon
              Icon(
                Icons.mark_email_unread_outlined,
                size: 100,
                color: colors.primary,
              ),
              const SizedBox(height: 25),

              // Title
              Text(
                "Verify your email address",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colors.inversePrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                "A verification email has been sent to:\n",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: colors.primary,
                ),
              ),
              Text(
                user?.email ?? "your email",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.inversePrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Please open Gmail, click the verification link, and your app will automatically activate.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: colors.primary,
                ),
              ),

              const SizedBox(height: 35),

              // "I've Verified" button
              GestureDetector(
                onTap: _checkEmailVerified,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: colors.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "I've Verified My Email",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colors.inversePrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Resend email button
              TextButton.icon(
                onPressed: canResendEmail ? _sendVerificationEmail : null,
                icon: const Icon(Icons.refresh),
                label: Text(
                  canResendEmail
                      ? "Resend Email"
                      : "Resend email in ${resendCooldown}s",
                  style: TextStyle(
                    color: canResendEmail ? colors.inversePrimary : colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Cancel / Back to Login
              TextButton(
                onPressed: () => AuthService().signOut(),
                child: Text(
                  "Cancel & Sign Out",
                  style: TextStyle(
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
