import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hall_detail_page.dart';

class HallListPage extends StatefulWidget {
  const HallListPage({super.key});

  @override
  State<HallListPage> createState() => _HallListPageState();
}

class _HallListPageState extends State<HallListPage> {
  String searchQuery = "";
  bool sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCE4EC),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Find Your Perfect Hall",
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

            // SEARCH
            TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search halls...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // SORT BUTTONS
            Row(
              children: [
                _filterButton(
                  "Price ↑",
                      () => setState(() => sortAscending = true),
                ),
                const SizedBox(width: 8),
                _filterButton(
                  "Price ↓",
                      () => setState(() => sortAscending = false),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // FIRESTORE LIST
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('halls')
                    .where('active', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No halls available'));
                  }

                  List<QueryDocumentSnapshot> halls = snapshot.data!.docs;

                  // SEARCH FILTER
                  halls = halls.where((hall) {
                    return hall['name']
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                  }).toList();

                  // SORT
                  halls.sort((a, b) => sortAscending
                      ? a['price'].compareTo(b['price'])
                      : b['price'].compareTo(a['price']));

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${halls.length} halls found",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      Expanded(
                        child: ListView.builder(
                          itemCount: halls.length,
                          itemBuilder: (context, index) {
                            final hall = halls[index];

                            return _stripHallCard(context, hall);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FILTER BUTTON UI
  Widget _filterButton(String text, VoidCallback onTap) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF6A4E90),
          side: const BorderSide(color: Color(0xFF8E7CC3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  // HALL CARD UI (FIRESTORE)
  Widget _stripHallCard(BuildContext context, QueryDocumentSnapshot hall) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [

          // IMAGE
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(hall['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  hall['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),
                Text("Capacity: ${hall['capacity']} pax"),
                const SizedBox(height: 4),
                Text("RM ${hall['price']} / day"),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HallDetailPage(
                            hallId: hall.id,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8E7CC3),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text("Book Now"),
                  ),
                ),

                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    "Tap to view details",
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
