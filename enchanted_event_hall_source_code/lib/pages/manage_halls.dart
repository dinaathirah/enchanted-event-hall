import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_dashboard.dart';
import 'add_new_hall.dart';

class ManageHallsPage extends StatelessWidget {
  const ManageHallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFCE4EC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminDashboardPage(),
              ),
            );
          },
        ),
        title: const Text(
          "Manage Halls",
          style: TextStyle(
            color: Color(0xFF6A4E90),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF6A4E90)),
      ),

      //ADD HALL
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF8E7CC3),
        icon: const Icon(Icons.add),
        label: const Text("Add New Hall"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddNewHallPage(),
            ),
          );
        },
      ),

      //FIRESTORE STREAM
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('halls')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No halls found"));
          }

          final halls = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: halls.length,
            itemBuilder: (context, index) {
              final hall = halls[index];
              return _hallCard(hall);
            },
          );
        },
      ),
    );
  }

  Widget _hallCard(QueryDocumentSnapshot hall) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(hall['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  hall['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              Switch(
                value: hall['active'],
                activeColor: const Color(0xFF8E7CC3),
                onChanged: (val) {
                  FirebaseFirestore.instance
                      .collection('halls')
                      .doc(hall.id)
                      .update({'active': val});
                },
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.people, size: 18),
              const SizedBox(width: 6),
              Text("${hall['capacity']} people"),
              const SizedBox(width: 20),
              const Icon(Icons.attach_money, size: 18),
              const SizedBox(width: 6),
              Text("RM ${hall['price']}"),
            ],
          ),
        ],
      ),
    );
  }
}
