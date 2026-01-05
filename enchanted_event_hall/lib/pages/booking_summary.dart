import 'package:flutter/material.dart';
import 'booking_confirmation.dart';
import 'edit_booking.dart';

class BookingSummaryPage extends StatelessWidget {
  final String hallName;
  final int capacity;
  final int hallPrice;
  final String date;
  final String timeSlot;
  final List<Map<String, dynamic>> selectedAddOns;

  const BookingSummaryPage({
    super.key,
    required this.hallName,
    required this.capacity,
    required this.hallPrice,
    required this.date,
    required this.timeSlot,
    required this.selectedAddOns,
  });

  @override
  Widget build(BuildContext context) {
    double addOnTotal = selectedAddOns.fold(
      0.0,
          (sum, item) => sum + item["price"],
    );

    double subtotal = hallPrice.toDouble() + addOnTotal;
    double tax = subtotal * 0.06;
    double total = subtotal + tax;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFCE4EC),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF8E7CC3)),
        title: const Text(
          "Booking Summary",
          style: TextStyle(
            color: Color(0xFF8E7CC3),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            _sectionTitle("Selected Event Hall"),
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailRow("Hall Name", hallName),
                  _detailRow("Capacity", "$capacity guests"),
                  _detailRow("Location", "Level 5, Main Building"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _sectionTitle("Date & Time"),
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailRow("Date", date),
                  _detailRow("Time Slot", timeSlot),
                  _detailRow("Duration", "5 hours"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _sectionTitle("Add-on Services"),
            _card(
              Column(
                children: selectedAddOns.isNotEmpty
                    ? selectedAddOns
                    .map((e) => _priceRow(e["title"], e["price"]))
                    .toList()
                    : const [
                  Text("No additional services selected."),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _sectionTitle("Price Summary"),
            _card(
              Column(
                children: [
                  _priceRow("Event Hall Rental", hallPrice.toDouble()),
                  _priceRow("Add-on Services", addOnTotal),
                  _priceRow("Subtotal", subtotal),
                  _priceRow("Service Tax (6%)", tax),
                  const Divider(),
                  _priceRow("Total Amount", total, bold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBookingPage(
                            hallName: hallName,
                            date: date,
                            timeSlot: timeSlot,
                            addOns: selectedAddOns,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF8E7CC3)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Edit Booking",
                      style: TextStyle(color: Color(0xFF8E7CC3)),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookingConfirmationPage(
                            bookingNumber: "BKG-2024-001234",
                            fullName: "Sarah Tan Wei Ling",
                            email: "sarah.tan@email.com",
                            phone: "+60 12-345 6789",
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8E7CC3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Confirm Booking"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            "RM ${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
