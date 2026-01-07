import 'package:flutter/material.dart';

class GuestHomePage extends StatelessWidget {
  const GuestHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),

      appBar: AppBar(
        backgroundColor: Color(0xFFFCE4EC),
        elevation: 3,
        titleSpacing: 10,
        title: Image.asset(
          'assets/logo/logo_enchanted.png',
          height: 55, // bigger logo
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF8E7CC3), width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Color(0xFF8E7CC3),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF8E7CC3), width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: const Color(0xFF8E7CC3),
              ),
              child: const Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],

      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Banner image
              Container(
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/guest_home/guest_home_page_image.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Welcome Box
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4))
                      ]),
                  child: const Column(
                    children: [
                      Text(
                        "Welcome to Enchanted Event Hall",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6A4E90)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Step into a world of elegance.\nDiscover breathtaking halls crafted for magical moments and unforgettable celebrations.",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "\"Where every celebration feels enchanted.\"",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF8E7CC3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Featured Halls",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),

              const SizedBox(height: 12),

              _hallCard("Luxe Grand Hall", "RM 4,000", 'assets/halls/luxe_grand_hall.png'),
              _hallCard("Ocean Crystal Hall", "RM 3,300", 'assets/halls/ocean_crystal_hall.png'),
              _hallCard("Dream Forest Hall", "RM 3,000", 'assets/halls/dream_forest_majestic_hall.png'),

              const SizedBox(height: 25),


              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2))
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Ready to Book Your Event?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Create an account to browse our full collection of event halls, check availability, and make instant bookings.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E7CC3),
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Login"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        "Register Now",
                        style: TextStyle(
                          color: Color(0xFF8E7CC3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Center(
                child: Text(
                  "© 2025 Enchanted. Find your perfect venue.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hallCard(String title, String price, String img) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(img),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Text(
          "$title\n$price",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
