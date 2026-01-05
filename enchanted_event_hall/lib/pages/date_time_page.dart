import 'package:flutter/material.dart';
import 'add_on_page.dart';


class DateTimePage extends StatefulWidget {
  const DateTimePage({super.key});

  @override
  State<DateTimePage> createState() => _DateTimePageState();
}

class _DateTimePageState extends State<DateTimePage> {
  int? selectedDay;
  String? selectedTime;

  final List<int> fullyBookedDays = [5, 11, 19, 25];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFCE4EC),
        title: const Text(
          "Select Date & Time",
          style: TextStyle(
            color: Color(0xFF8E7CC3),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const Text(
                "Select Date",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF6A4E90),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Choose an available date for your event",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 16),

              _calendar(),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Legend(color: Colors.grey, text: "Fully booked"),
                  SizedBox(width: 18),
                  Legend(color: Colors.black, text: "Selected date"),
                ],
              ),

              const SizedBox(height: 26),

              const Text(
                "Select Time",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF6A4E90),
                ),
              ),

              const SizedBox(height: 4),
              const Text("Choose a time slot", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 18),

              _timeCard("Morning", "9:00 AM – 1:00 PM"),
              _timeCard("Afternoon", "2:00 PM – 6:00 PM"),
              _timeCard("Evening", "7:00 PM – 11:00 PM"),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFF8E7CC3)),
                      ),
                      child: const Text(
                        "Back",
                        style: TextStyle(color: Color(0xFF8E7CC3)),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: (selectedDay != null && selectedTime != null)
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddOnServicesPage(),
                          ),
                        );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E7CC3),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        disabledBackgroundColor: Colors.grey.shade400,
                      ),
                      child: const Text("Next"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _calendar() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.chevron_left),
              Text(
                "November 2025",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A4E90),
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Weekday("Su"),
              Weekday("Mo"),
              Weekday("Tu"),
              Weekday("We"),
              Weekday("Th"),
              Weekday("Fr"),
              Weekday("Sa"),
            ],
          ),

          const SizedBox(height: 10),

          GridView.builder(
            itemCount: 30,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),

            itemBuilder: (context, index) {
              int day = index + 1;
              bool isBooked = fullyBookedDays.contains(day);

              return GestureDetector(
                onTap: isBooked ? null : () => setState(() => selectedDay = day),

                child: Container(
                  margin: const EdgeInsets.all(4),

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedDay == day
                        ? const Color(0xFF6A1B1B) // elegant maroon
                        : Colors.transparent,
                    border: Border.all(
                      color: isBooked ? Colors.grey.shade400 : Colors.transparent,
                    ),
                  ),

                  child: Center(
                    child: Text(
                      "$day",
                      style: TextStyle(
                        color: isBooked
                            ? Colors.grey
                            : selectedDay == day
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: selectedDay == day
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _timeCard(String title, String hours) {
    bool selected = selectedTime == title;

    return GestureDetector(
      onTap: () => setState(() => selectedTime = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 85, // 👈 SAME SIZE FOR ALL BOXES
        width: double.infinity,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF8E7CC3) : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          color: selected ? const Color(0xFFFCE4EC) : Colors.white,
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A4E90),
                ),
              ),
              const SizedBox(height: 4),
              Text(hours, style: const TextStyle(color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}


class Weekday extends StatelessWidget {
  final String day;
  const Weekday(this.day);

  @override
  Widget build(BuildContext context) {
    return Text(
      day,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}


class Legend extends StatelessWidget {
  final Color color;
  final String text;
  const Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}
