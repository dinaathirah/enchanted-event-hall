import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingConfirmationPage extends StatelessWidget {
  final String bookingId;

  const BookingConfirmationPage({
    super.key,
    required this.bookingId,
  });

  Future<void> _confirm() async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({'status': 'confirmed'});
  }

  @override
  Widget build(BuildContext context) {
    _confirm();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 70, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              "Booking Confirmed!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Booking ID: $bookingId"),
          ],
        ),
      ),
    );
  }
}
