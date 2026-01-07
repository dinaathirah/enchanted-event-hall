import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_dashboard.dart';
import 'booking_details_admin.dart';

class ManageBookingsPage extends StatelessWidget {
  const ManageBookingsPage({super.key});

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
          "Manage Bookings",
          style: TextStyle(
            color: Color(0xFF6A4E90),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF6A4E90)),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No bookings found"));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final doc = bookings[index];
              final b = doc.data() as Map<String, dynamic>;
              final status = b['status'];

              final price = (b['totalPrice'] as num).toDouble();

              Color statusColor =
              status == "approved"
                  ? Colors.green
                  : status == "pending"
                  ? Colors.orange
                  : Colors.red;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // HALL NAME + STATUS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          b['hallName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Text("Date: ${b['bookingDate']}"),
                    Text("Time Slot: ${b['timeSlot']}"),

                    const SizedBox(height: 6),
                    Text(
                      "RM ${price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF8E7CC3),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        if (status == 'pending') ...[
                          _actionButton(
                            label: "Approve",
                            color: Colors.green,
                            onTap: () =>
                                _updateStatus(doc.id, 'approved', context),
                          ),
                          const SizedBox(width: 8),
                          _actionButton(
                            label: "Cancel",
                            color: Colors.red,
                            onTap: () =>
                                _updateStatus(doc.id, 'cancelled', context),
                          ),
                        ],
                        const Spacer(),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8E7CC3),
                          ),
                          icon: const Icon(Icons.remove_red_eye, size: 18),
                          label: const Text("View"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingDetailsAdminPage(
                                  booking: b,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  //  UPDATE STATUS
  static Future<void> _updateStatus(
      String bookingId,
      String status,
      BuildContext context,
      ) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({'status': status});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Booking $status")),
    );
  }

  static Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      child: Text(label),
    );
  }
}
