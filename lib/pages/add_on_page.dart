import 'package:flutter/material.dart';
import 'booking_summary.dart';

class AddOnServicesPage extends StatefulWidget {
  final String hallId;
  final String hallName;
  final int capacity;
  final int price;
  final String date;
  final String timeSlot;

  const AddOnServicesPage({
    super.key,
    required this.hallId,
    required this.hallName,
    required this.capacity,
    required this.price,
    required this.date,
    required this.timeSlot,
  });

  @override
  State<AddOnServicesPage> createState() => _AddOnServicesPageState();
}

class _AddOnServicesPageState extends State<AddOnServicesPage> {
  final List<Map<String, dynamic>> addOns = [
    {
      "title": "Premium Sound System",
      "price": 800.00,
      "desc": "Professional audio equipment with speakers and microphones",
      "selected": false,
    },
    {
      "title": "LED Stage Lighting",
      "price": 1200.00,
      "desc": "Dynamic LED lights with multiple color options",
      "selected": false,
    },
    {
      "title": "Projector & Screen",
      "price": 500.00,
      "desc": "HD projector with 10ft screen for presentations",
      "selected": false,
    },
    {
      "title": "Floral Decoration Package",
      "price": 1500.00,
      "desc": "Beautiful floral arrangements and centerpieces",
      "selected": false,
    },
    {
      "title": "Professional Photography",
      "price": 2000.00,
      "desc": "Full event coverage with professional photographer",
      "selected": false,
    },
    {
      "title": "Catering Service",
      "price": 3500.00,
      "desc": "Buffet-style catering for up to 100 guests",
      "selected": false,
    },
    {
      "title": "Table & Chair Setup",
      "price": 600.00,
      "desc": "Premium table and chair setup",
      "selected": false,
    },
    {
      "title": "Red Carpet & Backdrop",
      "price": 400.00,
      "desc": "Photo backdrop with red carpet entrance",
      "selected": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double total = addOns
        .where((s) => s["selected"] == true)
        .fold(0.0, (sum, s) => sum + s["price"]);

    int selectedCount = addOns.where((s) => s["selected"] == true).length;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCE4EC),
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF8E7CC3)),
        title: const Text(
          "Add-on Services",
          style: TextStyle(
            color: Color(0xFF8E7CC3),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Select additional services for your event",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),

            /// LIST OF ADD-ONS
            Expanded(
              child: ListView.builder(
                itemCount: addOns.length,
                itemBuilder: (context, index) {
                  final item = addOns[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: item["selected"],
                          activeColor: const Color(0xFF8E7CC3),
                          onChanged: (val) {
                            setState(() => item["selected"] = val!);
                          },
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6A4E90),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item["desc"],
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "RM ${item["price"].toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6A4E90),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            /// SUMMARY
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  _summary("Selected Services", "$selectedCount"),
                  const SizedBox(height: 6),
                  _summary("Total Amount", "RM ${total.toStringAsFixed(2)}"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// ▶ CONTINUE WITH SELECTED ADD-ONS
            ElevatedButton(
              onPressed: () {
                final selectedServices =
                addOns.where((s) => s["selected"] == true).toList();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingSummaryPage(
                      hallId: widget.hallId,
                      hallName: widget.hallName,
                      capacity: widget.capacity,
                      hallPrice: widget.price,
                      date: widget.date,
                      timeSlot: widget.timeSlot,
                      selectedAddOns: selectedServices,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8E7CC3),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Continue to Summary"),
            ),

            const SizedBox(height: 8),

            /// ⏭ SKIP ADD-ONS (FIXED)
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingSummaryPage(
                      hallId: widget.hallId,
                      hallName: widget.hallName,
                      capacity: widget.capacity,
                      hallPrice: widget.price,
                      date: widget.date,
                      timeSlot: widget.timeSlot,
                      selectedAddOns: const [], // ⬅️ EMPTY ADD-ONS
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF8E7CC3)),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text(
                "Skip Add-ons",
                style: TextStyle(color: Color(0xFF8E7CC3)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
