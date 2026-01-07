import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cancel_booking_page.dart';

class EditBookingPage extends StatefulWidget {
  final String bookingId;
  final String hallName;
  final int hallPrice;
  final String date;
  final String timeSlot;
  final List<Map<String, dynamic>> addOns;

  const EditBookingPage({
    super.key,
    required this.bookingId,
    required this.hallName,
    required this.hallPrice,
    required this.date,
    required this.timeSlot,
    required this.addOns,
  });

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  late DateTime selectedDate;
  late String selectedTimeSlot;
  late List<Map<String, dynamic>> selectedAddOns;

  final List<String> timeSlots = ['morning', 'afternoon', 'evening'];

  final List<Map<String, dynamic>> allAddOns = [
    {"id": "sound_system", "name": "Premium Sound System", "price": 800},
    {"id": "lighting", "name": "LED Stage Lighting", "price": 1200},
    {"id": "projector", "name": "Projector & Screen", "price": 500},
    {"id": "floral", "name": "Floral Decoration", "price": 1500},
    {"id": "photography", "name": "Photography", "price": 2000},
    {"id": "catering", "name": "Catering Service", "price": 3500},
    {"id": "table_chair", "name": "Table & Chair Setup", "price": 600},
    {"id": "red_carpet", "name": "Red Carpet & Backdrop", "price": 400},
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.parse(widget.date);
    selectedTimeSlot = widget.timeSlot;
    selectedAddOns = List<Map<String, dynamic>>.from(widget.addOns);
  }

  bool _checked(Map<String, dynamic> addOn) =>
      selectedAddOns.any((a) => a['id'] == addOn['id']);

  double get addOnTotal =>
      selectedAddOns.fold(0.0, (s, a) => s + (a['price'] ?? 0));

  double get subtotal => widget.hallPrice + addOnTotal;
  double get tax => subtotal * 0.06;
  double get total => subtotal + tax;

  Future<void> _save() async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(widget.bookingId)
        .update({
      'bookingDate': selectedDate.toIso8601String().split('T')[0],
      'timeSlot': selectedTimeSlot,
      'addOns': selectedAddOns,
      'addOnTotal': addOnTotal,
      'subtotal': subtotal,
      'tax': tax,
      'totalPrice': total,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    Navigator.pop(context);
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Event Hall"),
            TextFormField(
              initialValue: widget.hallName,
              readOnly: true,
            ),
            const SizedBox(height: 16),
            const Text("Date"),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: Text(selectedDate.toIso8601String().split('T')[0]),
            ),
            const SizedBox(height: 16),
            const Text("Time Slot"),
            DropdownButtonFormField<String>(
              value: selectedTimeSlot,
              items: timeSlots
                  .map((t) =>
                  DropdownMenuItem(value: t, child: Text(t.toUpperCase())))
                  .toList(),
              onChanged: (v) => setState(() => selectedTimeSlot = v!),
            ),
            const SizedBox(height: 20),
            const Text("Add-on Services"),
            ...allAddOns.map((a) => CheckboxListTile(
              value: _checked(a),
              title: Text(a['name']),
              secondary: Text("RM ${a['price']}"),
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    selectedAddOns.add(a);
                  } else {
                    selectedAddOns
                        .removeWhere((x) => x['id'] == a['id']);
                  }
                });
              },
            )),
            const SizedBox(height: 20),
            Text("Total: RM ${total.toStringAsFixed(2)}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: const Text("Save Changes"),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CancelBookingPage(bookingId: widget.bookingId),
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
