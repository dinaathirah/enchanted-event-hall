import 'package:flutter/material.dart';

// Pages WITHOUT parameters
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/guest_home.dart';
import 'pages/hall_list_page.dart';
import 'pages/date_time_page.dart';
import 'pages/add_on_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enchanted Event Hall',

      // Default starting page
      home: const GuestHomePage(),

      // Only register pages WITHOUT required arguments
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/guestHome': (context) => const GuestHomePage(),
        '/hallList': (context) => const HallListPage(),
        '/dateTime': (context) => const DateTimePage(),
        '/addOns': (context) => const AddOnServicesPage(),
      },
    );
  }
}
