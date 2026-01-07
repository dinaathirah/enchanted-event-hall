import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_booking.dart';

class BookingSummaryPage extends StatefulWidget {
  final String hallId;
  final String hallName;
  final int capacity;
  final int hallPrice;
  final String date;        // YYYY-MM-DD
  final String timeSlot;    // morning | afternoon | evening
  final List<Map<String, dynamic>> selectedAddOns;

  const BookingSummaryPage({
    super.key,
    required this.hallId,
    required this.hallName,
    required this.capacity,
    required this.hallPrice,
    required this.date,
    required this.timeSlot,
    required this.selectedAddOns,
  });

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  String get startTime {
    switch (widget.timeSlot) {
      case 'morning':
        return '09:00';
      case 'afternoon':
        return '14:00';
      case 'evening':
        return '19:00';
      default:
        return '';
    }
  }

  String get endTime {
    switch (widget.timeSlot) {
      case 'morning':
        return '13:00';
      case 'afternoon':
        return '18:00';
      case 'evening':
        return '23:00';
      default:
        return '';
    }
  }

  Future<void> _confirmBooking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // PREVENT DOUBLE BOOKING
    final conflict = await FirebaseFirestore.instance
        .collection('bookings')
        .where('hallId', isEqualTo: widget.hallId)
        .where('bookingDate', isEqualTo: widget.date)
        .where('timeSlot', isEqualTo: widget.timeSlot)
        .where('status', whereIn: ['pending', 'confirmed'])
        .get();

    if (conflict.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("This time slot is already booked")),
      );
      return;
    }

    double addOnTotal = widget.selectedAddOns.fold(
      0.0,
          (sum, item) => sum + (item['price'] ?? 0),
    );

    double subtotal = widget.hallPrice + addOnTotal;
    double tax = subtotal * 0.06;
    double total = subtotal + tax;

    // SAVE BOOKING
    final docRef =
    await FirebaseFirestore.instance.collection('bookings').add({
      'userId': user.uid,
      'userEmail': user.email,
      'hallId': widget.hallId,
      'hallName': widget.hallName,
      'bookingDate': widget.date,
      'timeSlot': widget.timeSlot,
      'startTime': startTime,
      'endTime': endTime,
      'addOns': widget.selectedAddOns,
      'totalPrice': total,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    //GO TO EDIT PAGE
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EditBookingPage(
          bookingId: docRef.id,
          hallName: widget.hallName,
          date: widget.date,
          timeSlot: widget.timeSlot,
          addOns: widget.selectedAddOns,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),
      appBar: AppBar(
        title: const Text("Booking Summary"),
        backgroundColor: const Color(0xFFFCE4EC),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Hall: ${widget.hallName}"),
            Text("Date: ${widget.date}"),
            Text("Time: $startTime - $endTime"),
            const Spacer(),
            ElevatedButton(
              onPressed: _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8E7CC3),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Confirm Booking"),
            ),
          ],
        ),
      ),
    );
  }
}
