import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_booking.dart';
import 'booking_confirmation.dart';

class BookingSummaryPage extends StatefulWidget {
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

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  late String date;
  late String timeSlot;
  late List<Map<String, dynamic>> selectedAddOns;

  /// SINGLE SOURCE OF TRUTH
  static const Map<String, Map<String, String>> timeSlots = {
    'morning': {'start': '09:00', 'end': '13:00'},
    'afternoon': {'start': '14:00', 'end': '18:00'},
    'evening': {'start': '19:00', 'end': '23:00'},
  };

  @override
  void initState() {
    super.initState();
    date = widget.date;
    timeSlot = widget.timeSlot;
    selectedAddOns = List<Map<String, dynamic>>.from(widget.selectedAddOns);
  }

  String get startTime => timeSlots[timeSlot]!['start']!;
  String get endTime => timeSlots[timeSlot]!['end']!;

  double get addOnTotal =>
      selectedAddOns.fold(0.0, (s, a) => s + (a['price'] ?? 0));

  double get subtotal => widget.hallPrice + addOnTotal;
  double get tax => subtotal * 0.06;
  double get total => subtotal + tax;

  /// 🔑 CONFIRM BOOKING (STATUS = PENDING)
  Future<void> _confirmBooking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef =
    await FirebaseFirestore.instance.collection('bookings').add({
      'userId': user.uid,
      'userEmail': user.email,
      'hallId': widget.hallId,
      'hallName': widget.hallName,
      'hallPrice': widget.hallPrice,
      'capacity': widget.capacity,
      'bookingDate': date,
      'timeSlot': timeSlot,
      'startTime': startTime,
      'endTime': endTime,
      'addOns': selectedAddOns,
      'addOnTotal': addOnTotal,
      'subtotal': subtotal,
      'tax': tax,
      'totalPrice': total,

      // 🔴 FIX UTAMA: ADMIN APPROVAL REQUIRED
      'status': 'pending',

      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BookingConfirmationPage(
          bookingId: docRef.id,
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
              _row("Hall", widget.hallName),
              _row("Capacity", "${widget.capacity} guests"),
            ]),

            _card("Date & Time", [
              _row("Date", date),
              _row("Time", "$startTime - $endTime"),
            ]),

            _card(
              "Add-on Services",
              selectedAddOns.isEmpty
                  ? [_row("-", "RM 0.00")]
                  : selectedAddOns
                  .map(
                    (a) => _row(
                  a['name'] ?? "-",
                  "RM ${a['price']}",
                ),
              )
                  .toList(),
            ),

            _card("Price Summary", [
              _row("Hall Rental", "RM ${widget.hallPrice}"),
              _row("Add-ons", "RM ${addOnTotal.toStringAsFixed(2)}"),
              const Divider(),
              _row("Subtotal", "RM ${subtotal.toStringAsFixed(2)}"),
              _row("Tax (6%)", "RM ${tax.toStringAsFixed(2)}"),
              const Divider(),
              _row(
                "Total",
                "RM ${total.toStringAsFixed(2)}",
                bold: true,
              ),
            ]),

            const SizedBox(height: 24),

            /// ✏️ EDIT BOOKING
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditBookingPage(
                        hallName: widget.hallName,
                        hallPrice: widget.hallPrice,
                        date: date,
                        timeSlot: timeSlot,
                        addOns: selectedAddOns,
                      ),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      date = result['date'];
                      timeSlot = result['timeSlot'];
                      selectedAddOns =
                      List<Map<String, dynamic>>.from(result['addOns']);
                    });
                  }
                },
                child: const Text("Edit Booking"),
              ),
            ),

            const SizedBox(height: 12),

            /// ✅ CONFIRM BOOKING
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _confirmBooking,
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

  /// ---------- UI HELPERS ----------

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
        Text(
          title,
          style:
          const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
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
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : null,
          ),
        ),
      ],
    ),
  );
}
