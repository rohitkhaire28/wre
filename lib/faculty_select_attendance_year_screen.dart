
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firstdemo/faculty_select_subject_practical_screen.dart';

class FacultySelectAttendanceYearScreen extends StatelessWidget {
  const FacultySelectAttendanceYearScreen({super.key});

  final List<Map<String, dynamic>> years = const [
    {'name': '1st Year', 'icon': Icons.looks_one, 'color': Colors.blueAccent},
    {'name': '2nd Year', 'icon': Icons.looks_two, 'color': Colors.greenAccent},
    {'name': '3rd Year', 'icon': Icons.looks_3, 'color': Colors.orangeAccent},
    {'name': '4th Year', 'icon': Icons.looks_4, 'color': Colors.redAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Year', style: GoogleFonts.lato()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        itemCount: years.length,
        itemBuilder: (context, index) {
          final year = years[index];
          return YearCard(
            name: year['name'],
            icon: year['icon'],
            color: year['color'],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FacultySelectSubjectPracticalScreen(year: year['name']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class YearCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const YearCard({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
