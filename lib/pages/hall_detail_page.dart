import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'date_time_page.dart';

class HallDetailPage extends StatelessWidget {
  final String hallId;

  const HallDetailPage({
    super.key,
    required this.hallId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCE4EC),
        elevation: 1,
        title: const Text(
          "Hall Details",
          style: TextStyle(
            color: Color(0xFF8E7CC3),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF8E7CC3)),
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('halls')
            .doc(hallId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final hall = snapshot.data!.data() as Map<String, dynamic>;
          final List amenities = hall['amenities'] ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // IMAGE
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                    image: DecorationImage(
                      image: AssetImage(hall['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // NAME
                Text(
                  hall['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color(0xFF6A4E90),
                  ),
                ),

                const SizedBox(height: 10),
                Text("Capacity: ${hall['capacity']} pax"),
                const SizedBox(height: 4),
                Text("RM ${hall['price']} / day"),

                const SizedBox(height: 24),

                // DESCRIPTION
                const Text(
                  "Description",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hall['description'] ?? "No description available.",
                  style: const TextStyle(color: Colors.black87),
                ),

                const SizedBox(height: 24),

                // AMENITIES
                const Text(
                  "Amenities",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: amenities.map<Widget>((item) {
                    return Chip(
                      label: Text(item),
                      backgroundColor:
                      const Color(0xFF8E7CC3).withOpacity(0.15),
                      labelStyle:
                      const TextStyle(color: Color(0xFF6A4E90)),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // BOOK BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DateTimePage(
                            hallId: hallId,
                            hallName: hall['name'],
                            capacity: hall['capacity'],
                            price: hall['price'],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8E7CC3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Book Now"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
