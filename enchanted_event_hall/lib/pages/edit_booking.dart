import 'package:flutter/material.dart';
import 'cancel_booking_page.dart';

class EditBookingPage extends StatefulWidget {
  final String hallName;
  final String date;
  final String timeSlot;
  final List<Map<String, dynamic>> addOns;

  const EditBookingPage({
    super.key,
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
  late String selectedTime;
  late List<Map<String, dynamic>> addOnList;

  final List<String> halls = [
    "Grand Ballroom",
    "Dream Forest Majestic Hall",
    "Royal Garden Ballroom",
  ];


  final List<String> timeSlots = [
    "9:00 AM – 1:00 PM",
    "2:00 PM – 6:00 PM",
    "6:00 PM – 11:00 PM", // MUST MATCH SUMMARY
    "7:00 PM – 11:00 PM",
  ];

  @override
  void initState() {
    super.initState();


    selectedTime = widget.timeSlot.replaceAll('-', '–');

    selectedHall = widget.hallName;
    selectedDate = widget.date;
    addOnList = widget.addOns;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFCE4EC),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF8E7CC3)),
        title: const Text(
          "Edit Booking",
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

            _sectionTitle("Event Hall"),
            _dropdownContainer(
              child: DropdownButton<String>(
                value: selectedHall,
                isExpanded: true,
                underline: const SizedBox(),
                items: halls.map((hall) {
                  return DropdownMenuItem(
                      value: hall, child: Text(hall));
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedHall = value!);
                },
              ),
            ),

            _sectionTitle("Date"),
            _dropdownContainer(
              child: GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2030),
                  );

                  if (picked != null) {
                    setState(() {
                      selectedDate =
                      "${picked.day}/${picked.month}/${picked.year}";
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedDate),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),

            _sectionTitle("Time Slot"),
            _dropdownContainer(
              child: DropdownButton<String>(
                value: selectedTime,
                isExpanded: true,
                underline: const SizedBox(),
                items: timeSlots.map((slot) {
                  return DropdownMenuItem(
                      value: slot, child: Text(slot));
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedTime = value!);
                },
              ),
            ),

            _sectionTitle("Add-on Services"),
            _dropdownContainer(
              child: Column(
                children: addOnList.map((item) {
                  return CheckboxListTile(
                    value: item["selected"],
                    activeColor: const Color(0xFF8E7CC3),
                    onChanged: (val) {
                      setState(() => item["selected"] = val!);
                    },
                    title: Text(item["title"]),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF475569),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Save Changes"),
            ),

            const SizedBox(height: 10),

            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CancelBookingPage(
                      bookingNumber: "BKG-2024-001234",
                      customerName: "Sarah Tan Wei Ling",
                      hallName: selectedHall,
                      date: selectedDate,
                      timeSlot: selectedTime,
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Color(0xFF8E7CC3)),
              ),
              child: const Text(
                "Cancel Booking",
                style: TextStyle(color: Color(0xFF8E7CC3)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 6),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );

  Widget _dropdownContainer({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: child,
  );
}
