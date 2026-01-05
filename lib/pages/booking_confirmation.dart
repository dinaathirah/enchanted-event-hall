import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingConfirmationPage extends StatelessWidget {
  final String bookingId;
  final String fullName;
  final String email;
  final String phone;

  const BookingConfirmationPage({
    super.key,
    required this.bookingId,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  Future<void> _confirmBooking(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({
      'status': 'confirmed',
    });
  }

  @override
  Widget build(BuildContext context) {
    _confirmBooking(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // HEADER
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

            // BOOKING ID
            _infoCard(
              Column(
                children: [
                  const Text(
                    "Confirmation Number",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bookingId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CUSTOMER INFO
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
                  _detail("Full Name", fullName),
                  _detail("Email Address", email),
                  _detail("Phone Number", phone),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _infoCard(
              Column(
                children: [
                  const Text(
                    "A confirmation email has been sent to",
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

  Widget _infoCard(Widget child) => Container(
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

  Widget _detail(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
