import 'package:flutter/material.dart';

class BookingConfirmationPage extends StatelessWidget {
  final String bookingNumber;
  final String fullName;
  final String email;
  final String phone;

  const BookingConfirmationPage({
    super.key,
    required this.bookingNumber,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),

      body: SingleChildScrollView(
        child: Column(
          children: [


            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 38),
              color: const Color(0xFF9BD59B),
              child: Column(
                children: const [
                  Icon(Icons.check_circle,
                      size: 60, color: Colors.white),

                  SizedBox(height: 12),

                  Text(
                    "Booking Confirmed!",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "Your booking has been successfully confirmed",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),


            _infoCard(
              Column(
                children: [
                  const Text(
                    "Confirmation Number",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bookingNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),


            _infoCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Customer Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const Divider(thickness: 1),

                  const SizedBox(height: 6),
                  _detail("Full Name", fullName),
                  _detail("Email Address", email),
                  _detail("Phone Number", phone),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // EMAIL SENT CARD
            _infoCard(
              Column(
                children: [
                  Text(
                    "A confirmation email has been sent to",
                    style: TextStyle(color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A4E90),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text("Thank you for your booking!"),
                ],
              ),
            ),

            const SizedBox(height: 30),


          ],
        ),
      ),
    );
  }


  Widget _infoCard(Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }


  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
