import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_dashboard.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  String searchQuery = "";

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
          "Manage Users",
          style: TextStyle(
            color: Color(0xFF6A4E90),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _searchBar(),
            const SizedBox(height: 16),

            //SER STATS
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final users = snapshot.data!.docs;
                final totalUsers = users.length;
                final totalAdmins =
                    users.where((u) => u['role'] == 'admin').length;

                return Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        Icons.person,
                        "Total Users",
                        "$totalUsers",
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryCard(
                        Icons.shield,
                        "Total Admins",
                        "$totalAdmins",
                        Colors.purple,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "All Users",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // USER LIST
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No users found"),
                    );
                  }

                  var users = snapshot.data!.docs;

                  // SEARCH FILTER
                  users = users.where((u) {
                    final name =
                    (u['name'] ?? '').toString().toLowerCase();
                    final email =
                    (u['email'] ?? '').toString().toLowerCase();

                    return name.contains(searchQuery) ||
                        email.contains(searchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return _userCard(users[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        onChanged: (val) =>
            setState(() => searchQuery = val.toLowerCase()),
        decoration: const InputDecoration(
          icon: Icon(Icons.search),
          hintText: "Search by name or email...",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _summaryCard(
      IconData icon,
      String label,
      String value,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey)),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _userCard(QueryDocumentSnapshot user) {
    final bool isAdmin = user['role'] == 'admin';

    final joinedDate = user['createdAt'] != null
        ? (user['createdAt'] as Timestamp)
        .toDate()
        .toString()
        .split(' ')[0]
        : '-';

    final String name =
    (user['name'] ?? 'User').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
            const Color(0xFF8E7CC3).withOpacity(0.15),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : "?",
              style: const TextStyle(
                color: Color(0xFF6A4E90),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isAdmin
                            ? Colors.purple.withOpacity(0.15)
                            : Colors.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isAdmin ? "Admin" : "User",
                        style: TextStyle(
                          fontSize: 12,
                          color: isAdmin
                              ? Colors.purple
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  user['email'],
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Joined",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                joinedDate,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
