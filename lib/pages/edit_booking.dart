import 'package:flutter/material.dart';

class EditBookingPage extends StatefulWidget {
  final String hallName;
  final int hallPrice;
  final String date;
  final String timeSlot;
  final List<Map<String, dynamic>> addOns;

  const EditBookingPage({
    super.key,
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
    {"id": "sound", "name": "Premium Sound System", "price": 800},
    {"id": "lighting", "name": "LED Stage Lighting", "price": 1200},
    {"id": "projector", "name": "Projector & Screen", "price": 500},
    {"id": "floral", "name": "Floral Decoration", "price": 1500},
    {"id": "photo", "name": "Photography", "price": 2000},
    {"id": "catering", "name": "Catering Service", "price": 3500},
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.parse(widget.date);
    selectedTimeSlot = widget.timeSlot;
    selectedAddOns = List<Map<String, dynamic>>.from(widget.addOns);
  }

  bool _isChecked(Map<String, dynamic> addOn) =>
      selectedAddOns.any((a) => a['id'] == addOn['id']);

  void _saveChanges() {
    Navigator.pop(context, {
      'date': selectedDate.toIso8601String().split('T')[0],
      'timeSlot': selectedTimeSlot,
      'addOns': selectedAddOns,
    });
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
            /// HALL (READ ONLY)
            const Text("Event Hall"),
            const SizedBox(height: 6),
            TextFormField(
              initialValue: widget.hallName,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// DATE
            const Text("Date"),
            const SizedBox(height: 6),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() => selectedDate = picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                Text(selectedDate.toIso8601String().split('T')[0]),
              ),
            ),

            const SizedBox(height: 20),

            /// TIME SLOT
            const Text("Time Slot"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedTimeSlot,
              items: timeSlots
                  .map(
                    (t) => DropdownMenuItem(
                  value: t,
                  child: Text(t.toUpperCase()),
                ),
              )
                  .toList(),
              onChanged: (v) => setState(() => selectedTimeSlot = v!),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            /// ADD-ON SERVICES
            const Text("Add-on Services"),
            const SizedBox(height: 8),

            ...allAddOns.map(
                  (a) => CheckboxListTile(
                value: _isChecked(a),
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
              ),
            ),

            const SizedBox(height: 30),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: const Text("Save Changes"),
              ),
            ),

            const SizedBox(height: 12),

            /// BACK / DISCARD
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
