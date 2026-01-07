import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CancelBookingPage extends StatelessWidget {
  final String bookingId;

  const CancelBookingPage({
    super.key,
    required this.bookingId,
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

    final status = snapshot['status'];

    if (status == 'cancelled') {
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

    // 🔁 Kembali ke home (clear stack)
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),
      appBar: AppBar(
        title: const Text("Cancel Booking"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('bookings')
            .doc(bookingId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _info("Booking ID", bookingId),
                _info("Event Hall", data['hallName'] ?? "-"),
                _info("Date", data['bookingDate'] ?? "-"),
                _info(
                  "Time",
                  "${data['startTime'] ?? "-"} - ${data['endTime'] ?? "-"}",
                ),
                _info("Status", data['status'] ?? "-"),

                const SizedBox(height: 30),

                const Text(
                  "⚠️ This action cannot be undone.",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _cancelBooking(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text("Confirm Cancellation"),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Keep Booking"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
