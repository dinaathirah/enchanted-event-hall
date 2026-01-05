import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cancel_booking_page.dart';

class EditBookingPage extends StatefulWidget {
  final String bookingId;
  final String hallName;
  final String date;
  final String timeSlot;
  final List<Map<String, dynamic>> addOns;

  const EditBookingPage({
    super.key,
    required this.bookingId,
    required this.hallName,
    required this.date,
    required this.timeSlot,
    required this.addOns,
  });

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  late String selectedHall;
  late String selectedDate;
  late String selectedSlot;

  @override
  void initState() {
    super.initState();
    selectedHall = widget.hallName;
    selectedDate = widget.date;
    selectedSlot = widget.timeSlot;
  }

  Future<void> _saveChanges() async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(widget.bookingId)
        .update({
      'hallName': selectedHall,
      'bookingDate': selectedDate,
      'timeSlot': selectedSlot,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking updated")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),
      appBar: AppBar(
        title: const Text("Edit Booking"),
        backgroundColor: const Color(0xFFFCE4EC),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Hall: $selectedHall"),
            Text("Date: $selectedDate"),
            Text("Slot: $selectedSlot"),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text("Save Changes"),
            ),

            const SizedBox(height: 10),

            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CancelBookingPage(
                      bookingId: widget.bookingId,
                      customerName: "User",
                      hallName: selectedHall,
                      date: selectedDate,
                      timeSlot: selectedSlot,
                    ),
                  ),
                );
              },
              child: const Text("Cancel Booking"),
            ),
          ],
        ),
      ),
    );
  }
}
