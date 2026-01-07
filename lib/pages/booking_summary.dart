import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_booking.dart';

class BookingSummaryPage extends StatelessWidget {
  final String hallId;
  final String hallName;
  final int capacity;
  final int hallPrice;
  final String date; // YYYY-MM-DD
  final String timeSlot; // morning / afternoon / evening
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

  /// 🔑 SINGLE SOURCE OF TRUTH (24 HOURS)
  static const Map<String, Map<String, String>> timeSlots = {
    'morning': {'start': '09:00', 'end': '13:00'},
    'afternoon': {'start': '14:00', 'end': '18:00'},
    'evening': {'start': '19:00', 'end': '23:00'},
  };

  String get startTime => timeSlots[timeSlot]?['start'] ?? '-';
  String get endTime => timeSlots[timeSlot]?['end'] ?? '-';

  double get addOnTotal =>
      selectedAddOns.fold(0.0, (s, a) => s + (a['price'] ?? 0));

  double get subtotal => hallPrice + addOnTotal;
  double get tax => subtotal * 0.06;
  double get total => subtotal + tax;

  Future<void> _confirmBooking(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef =
    await FirebaseFirestore.instance.collection('bookings').add({
      'userId': user.uid,
      'userEmail': user.email,
      'hallId': hallId,
      'hallName': hallName,
      'hallPrice': hallPrice,
      'bookingDate': date,
      'timeSlot': timeSlot,
      'startTime': startTime,
      'endTime': endTime,
      'addOns': selectedAddOns,
      'addOnTotal': addOnTotal,
      'subtotal': subtotal,
      'tax': tax,
      'totalPrice': total,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EditBookingPage(
          bookingId: docRef.id,
          hallName: hallName,
          hallPrice: hallPrice,
          date: date,
          timeSlot: timeSlot,
          addOns: selectedAddOns,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _card("Event Hall", [
              _row("Hall", hallName),
              _row("Capacity", "$capacity guests"),
            ]),
            _card("Date & Time", [
              _row("Date", date),
              _row("Time", "$startTime - $endTime"),
            ]),
            if (selectedAddOns.isNotEmpty)
              _card(
                "Add-on Services",
                selectedAddOns
                    .map((a) => _row(
                  a['name'] ?? '-',
                  "RM ${a['price'] ?? 0}",
                ))
                    .toList(),
              ),
            _card("Price Summary", [
              _row("Hall Rental", "RM $hallPrice"),
              _row("Add-ons", "RM ${addOnTotal.toStringAsFixed(2)}"),
              const Divider(),
              _row("Subtotal", "RM ${subtotal.toStringAsFixed(2)}"),
              _row("Tax (6%)", "RM ${tax.toStringAsFixed(2)}"),
              const Divider(),
              _row("Total", "RM ${total.toStringAsFixed(2)}", bold: true),
            ]),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => _confirmBooking(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E7CC3),
                ),
                child: const Text("Confirm Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, List<Widget> children) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        ...children,
      ],
    ),
  );

  Widget _row(String left, String right, {bool bold = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left),
        Text(
          right,
          style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
        ),
      ],
    ),
  );
}
