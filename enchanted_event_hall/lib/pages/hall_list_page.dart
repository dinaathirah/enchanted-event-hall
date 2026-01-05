import 'package:flutter/material.dart';
import 'hall_detail_page.dart';

class HallListPage extends StatefulWidget {
  const HallListPage({super.key});

  @override
  State<HallListPage> createState() => _HallListPageState();
}

class _HallListPageState extends State<HallListPage> {
  String searchQuery = "";
  bool sortAscending = true;
  bool favouriteOnly = false;

  final List<Map<String, dynamic>> halls = [
    {
      "name": "The Gem Grand Hall",
      "capacity": 350,
      "price": 3500,
      "image": "assets/halls/the_gem_grand_hall.png",
      "isFav": false,
    },
    {
      "name": "Crystal Symphony Hall",
      "capacity": 300,
      "price": 4200,
      "image": "assets/halls/crystal_symphony_hall.png",
      "isFav": true,
    },
    {
      "name": "Royal Garden Ballroom",
      "capacity": 280,
      "price": 3000,
      "image": "assets/halls/royal_garden_ballroom.png",
      "isFav": false,
    },
    {
      "name": "Dream Forest Majestic Hall",
      "capacity": 250,
      "price": 2700,
      "image": "assets/halls/dream_forest_majestic_hall.png",
      "isFav": true,
    },
    {
      "name": "Luxe Grand Hall",
      "capacity": 450,
      "price": 4500,
      "image": "assets/halls/luxe_grand_hall.png",
      "isFav": false,
    },
    {
      "name": "Aurora Majestic Hall",
      "capacity": 220,
      "price": 3200,
      "image": "assets/halls/aurora_majestic_hall.png",
      "isFav": false,
    },
    {
      "name": "Ocean Crystal Hall",
      "capacity": 260,
      "price": 3300,
      "image": "assets/halls/ocean_crystal_hall.png",
      "isFav": false,
    },
    {
      "name": "Magica Snowfall Hall",
      "capacity": 320,
      "price": 3800,
      "image": "assets/halls/magica_snowfall_hall.png",
      "isFav": false,
    },
    {
      "name": "Golden Flora Hall",
      "capacity": 400,
      "price": 4000,
      "image": "assets/halls/golden_flora_hall.png",
      "isFav": false,
    },
    {
      "name": "Enchanted Grand Hall",
      "capacity": 400,
      "price": 4800,
      "image": "assets/halls/enchanted_grand_hall.png",
      "isFav": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredHalls = halls
        .where((hall) =>
        hall["name"].toLowerCase().contains(searchQuery.toLowerCase()))
        .where((hall) => favouriteOnly ? hall["isFav"] == true : true)
        .toList();

    filteredHalls.sort((a, b) => sortAscending
        ? a["price"].compareTo(b["price"])
        : b["price"].compareTo(a["price"]));

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

            Row(
              children: [
                _filterButton("Price ↑", () => setState(() => sortAscending = true)),
                const SizedBox(width: 8),
                _filterButton("Price ↓", () => setState(() => sortAscending = false)),
                const SizedBox(width: 8),
                _filterButton(
                  "♡ Favourite",
                      () => setState(() => favouriteOnly = !favouriteOnly),
                  active: favouriteOnly,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              "${filteredHalls.length} halls found",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: filteredHalls.length,
                itemBuilder: (context, index) {
                  final hall = filteredHalls[index];
                  return _hallCard(context, hall);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(String text, VoidCallback onTap, {bool active = false}) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: active ? const Color(0xFF8E7CC3) : Colors.white,
          foregroundColor: active ? Colors.white : const Color(0xFF6A4E90),
          side: const BorderSide(color: Color(0xFF8E7CC3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _hallCard(BuildContext context, Map<String, dynamic> hall) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [

          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(hall["image"]),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hall["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        hall["isFav"] ? Icons.favorite : Icons.favorite_border,
                        color: Colors.pinkAccent,
                      ),
                      onPressed: () {
                        setState(() => hall["isFav"] = !hall["isFav"]);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 6),
                Text("Capacity: ${hall["capacity"]} pax"),
                const SizedBox(height: 4),
                Text("RM ${hall["price"]} / day"),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HallDetailPage(
                            name: hall["name"],
                            capacity: hall["capacity"],
                            price: hall["price"],
                            image: hall["image"],
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
