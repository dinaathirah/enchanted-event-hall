import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CancelBookingPage extends StatelessWidget {
  final String bookingId;
  final String customerName;
  final String hallName;
  final String date;
  final String timeSlot;

  const CancelBookingPage({
    super.key,
    required this.bookingId,
    required this.customerName,
    required this.hallName,
    required this.date,
    required this.timeSlot,
  });

  Future<void> _cancelBooking(BuildContext context) async {
    final docRef =
    FirebaseFirestore.instance.collection('bookings').doc(bookingId);

    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking not found")),
      );
      return;
    }

    final currentStatus = snapshot['status'];

    // Prevent double cancel
    if (currentStatus == 'cancelled') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking already cancelled")),
      );
      return;
    }

    await docRef.update({
      'status': 'cancelled',
      'cancelledAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking cancelled successfully")),
    );

    // 🔁 Clear navigation stack
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170),
        child: Container(
          color: const Color(0xFFD32F2F),
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: const [
              Icon(Icons.warning_amber_rounded,
                  size: 55, color: Colors.white),
              SizedBox(height: 10),
              Text(
                "Cancel Booking",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Are you sure you want to cancel this booking?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            _infoCard(
              Column(
                children: [
                  const Text(
                    "Booking ID",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bookingId,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _infoCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detail("Customer Name", customerName),
                  _detail("Event Hall", hallName),
                  _detail("Date", date),
                  _detail("Time Slot", timeSlot),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _infoCard(
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "This action cannot be undone. Once cancelled, "
                          "the booking slot will be released.",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF8E7CC3)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Keep Booking",
                  style: TextStyle(color: Color(0xFF8E7CC3)),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _cancelBooking(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Confirm Cancellation"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(Widget child) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: child,
  );

  Widget _detail(String title, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 3),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
