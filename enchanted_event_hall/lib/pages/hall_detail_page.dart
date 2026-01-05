import 'package:flutter/material.dart';
import 'date_time_page.dart'; // IMPORTANT: update path if needed

class HallDetailPage extends StatelessWidget {
  final String name;
  final int capacity;
  final int price;
  final String image;

  const HallDetailPage({
    super.key,
    required this.name,
    required this.capacity,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6), // pastel background

      appBar: AppBar(
        backgroundColor: const Color(0xFFFCE4EC), // pastel pink
        elevation: 1,
        title: const Text(
          "Hall Details",
          style: TextStyle(
            color: Color(0xFF8E7CC3),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(0xFF8E7CC3),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // HALL IMAGE
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 18),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF6A4E90),
                  ),
                ),
                const Icon(Icons.favorite_border, color: Colors.grey),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.people_alt, size: 18, color: Colors.black54),
                const SizedBox(width: 6),
                Text("Capacity: $capacity pax"),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.attach_money, size: 18, color: Colors.black54),
                const SizedBox(width: 6),
                Text("RM $price / day"),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),

            const Text(
              "A beautifully designed event hall suitable for weddings, "
                  "receptions, corporate events, and private celebrations.",
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 20),

            const Text(
              "Amenities",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            Row(
              children: const [
                Icon(Icons.local_parking, size: 18),
                SizedBox(width: 6),
                Text("Parking"),

                SizedBox(width: 25),
                Icon(Icons.speaker, size: 18),
                SizedBox(width: 6),
                Text("Sound System"),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: const [
                Icon(Icons.ac_unit, size: 18),
                SizedBox(width: 6),
                Text("Air-cond"),

                SizedBox(width: 45),
                Icon(Icons.wb_incandescent, size: 18),
                SizedBox(width: 6),
                Text("Lighting"),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: const [
                Icon(Icons.theaters, size: 18),
                SizedBox(width: 6),
                Text("Stage"),

                SizedBox(width: 65),
                Icon(Icons.workspace_premium, size: 18),
                SizedBox(width: 6),
                Text("VIP Area"),
              ],
            ),

            const SizedBox(height: 30),


            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DateTimePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E7CC3), // pastel purple
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Book Now"),
              ),
            ),

            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Tap to continue booking",
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
    );
  }
}

