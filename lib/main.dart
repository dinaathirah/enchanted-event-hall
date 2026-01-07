import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


// pages
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/guest_home.dart';
import 'pages/hall_list_page.dart';
import 'pages/login_admin.dart';
import 'pages/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enchanted Event Hall',

      // Start page
      home: const GuestHomePage(),


      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/guestHome': (context) => const GuestHomePage(),
        '/hallList': (context) => const HallListPage(),
        '/adminLogin': (context) => const AdminLoginPage(),
        '/adminDashboard': (context) => const AdminDashboardPage(),
      },
    );
  }
}
