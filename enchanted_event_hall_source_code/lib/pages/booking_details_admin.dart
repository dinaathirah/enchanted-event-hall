import 'package:flutter/material.dart';
import 'manage_bookings.dart';

class BookingDetailsAdminPage extends StatelessWidget {
  final Map<String, dynamic> booking;

  const BookingDetailsAdminPage({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor =
    booking["status"] == "approved"
        ? Colors.green
        : booking["status"] == "pending"
        ? Colors.orange
        : Colors.red;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFCE4EC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ManageBookingsPage(),
              ),
            );
          },
        ),
        title: const Text(
          "Booking Details",
          style: TextStyle(
            color: Color(0xFF6A4E90),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF6A4E90)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔹 BOOKING INFO
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row("Hall Name", booking["hallName"]),
                  _row("Booking Date", booking["bookingDate"]),
                  _row(
                    "Time",
                    "${booking["startTime"]} - ${booking["endTime"]}",
                  ),
                  _row(
                    "Status",
                    booking["status"].toUpperCase(),
                    color: statusColor,
                    bold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 PAYMENT INFO
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row(
                    "Total Amount",
                    "RM ${booking["totalPrice"]}",
                    bold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 USER INFO (MINIMUM – OK FOR LECTURER)
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row("User ID", booking["userId"]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }

  Widget _row(
      String label,
      String value, {
        bool bold = false,
        Color? color,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
