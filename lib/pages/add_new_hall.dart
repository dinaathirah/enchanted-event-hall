import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNewHallPage extends StatefulWidget {
  const AddNewHallPage({super.key});

  @override
  State<AddNewHallPage> createState() => _AddNewHallPageState();
}

class _AddNewHallPageState extends State<AddNewHallPage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController capacityCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();

  bool isLoading = false;

  final Map<String, bool> amenities = {
    "Parking": false,
    "Sound System": false,
    "Air-cond": false,
    "Lighting": false,
    "Stage": false,
    "VIP Area": false,
  };

  Future<void> _saveHall() async {
    if (nameCtrl.text.isEmpty ||
        capacityCtrl.text.isEmpty ||
        priceCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    final selectedAmenities = amenities.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    await FirebaseFirestore.instance.collection('halls').add({
      'name': nameCtrl.text.trim(),
      'capacity': int.parse(capacityCtrl.text),
      'price': int.parse(priceCtrl.text),
      'image': 'assets/halls/grand_ballroom.png', // default image
      'amenities': selectedAmenities,
      'active': true,
      'createdAt': FieldValue.serverTimestamp(),
    });

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Hall added successfully")),
    );

    Navigator.pop(context); // balik ke ManageHallsPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFCE4EC),
        elevation: 0,
        title: const Text(
          "Add New Hall",
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

            _input("Hall Name", nameCtrl),
            _input("Capacity (people)", capacityCtrl, isNumber: true),
            _input("Base Price (RM)", priceCtrl, isNumber: true),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Amenities",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 10),

            ...amenities.keys.map((key) {
              return CheckboxListTile(
                title: Text(key),
                value: amenities[key],
                activeColor: const Color(0xFF8E7CC3),
                onChanged: (val) {
                  setState(() {
                    amenities[key] = val!;
                  });
                },
              );
            }).toList(),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8E7CC3),
                    ),
                    onPressed: isLoading ? null : _saveHall,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save Hall"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
