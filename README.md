# Foodly

# Food Delivery App

A Flutter food-delivery app prototype. Users can browse a sample food menu, customize items, manage a cart, enter a delivery address, and submit orders to Firebase.

## Features

- Sign in or register with email and password, or use Google Sign-In.
- Verify email addresses for email-based accounts.
- Browse menu categories and select food add-ons.
- Add items to a cart and review an order receipt.
- Save a delivery address on the device for the signed-in user.
- Save orders to Cloud Firestore and view order history.
- Switch between light and dark themes; the preference is saved locally.

## Built with

- Flutter and Dart
- Provider for app state
- Firebase Authentication for sign-in
- Cloud Firestore for order records
- SharedPreferences for local settings and delivery addresses

## Setup and run

1. Install Flutter and configure Firebase for the platforms you want to run.
2. Enable the authentication providers used by the app and configure Firestore access for authenticated users.
3. From the project directory, run:

   ```bash
   flutter pub get
   flutter run

