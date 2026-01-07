import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_on_page.dart';

class DateTimePage extends StatefulWidget {
  final String hallId;
  final String hallName;
  final int capacity;
  final int price;

  const DateTimePage({
    super.key,
    required this.hallId,
    required this.hallName,
    required this.capacity,
    required this.price,
  });

  @override
  State<DateTimePage> createState() => _DateTimePageState();
}

class _DateTimePageState extends State<DateTimePage> {
  DateTime? selectedDate;
  String? selectedSlot;
  bool isChecking = false;

  final Map<String, Map<String, String>> timeSlots = {
    'morning': {'label': 'Morning', 'time': '9:00 AM – 1:00 PM'},
    'afternoon': {'label': 'Afternoon', 'time': '2:00 PM – 6:00 PM'},
    'evening': {'label': 'Evening', 'time': '7:00 PM – 11:00 PM'},
  };

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }


  Future<bool> isSlotAvailable(String date, String slot) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('hallId', isEqualTo: widget.hallId)
        .where('bookingDate', isEqualTo: date)
        .where('timeSlot', isEqualTo: slot)
        .where('status', whereIn: ['pending', 'confirmed'])
        .get();

    return snapshot.docs.isEmpty;
  }

  Future<void> proceedNext() async {
    if (selectedDate == null || selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date and time slot")),
      );
      return;
    }

    setState(() => isChecking = true);

    final dateString =
        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

    final available = await isSlotAvailable(dateString, selectedSlot!);

    setState(() => isChecking = false);

    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selected slot is already booked"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddOnServicesPage(
          hallId: widget.hallId,
          hallName: widget.hallName,
          capacity: widget.capacity,
          price: widget.price,
          date: dateString,
          timeSlot: selectedSlot!,
        ),
      ),
    );
  }

  Widget timeCard(String slot) {
    final isSelected = selectedSlot == slot;

    return GestureDetector(
      onTap: () => setState(() => selectedSlot = slot),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEDE7F6) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF8E7CC3) : Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timeSlots[slot]!['label']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(timeSlots[slot]!['time']!),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCE4EC),
        title: const Text(
          "Select Time",
          style: TextStyle(color: Color(0xFF8E7CC3)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF8E7CC3)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                selectedDate == null
                    ? "Select Date"
                    : selectedDate!.toString().split(' ')[0],
              ),
              onTap: pickDate,
            ),

            const SizedBox(height: 16),

            timeCard("morning"),
            timeCard("afternoon"),
            timeCard("evening"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isChecking ? null : proceedNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E7CC3),
                ),
                child: isChecking
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
