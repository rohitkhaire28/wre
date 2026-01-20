
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firstdemo/main.dart';
import 'package:firstdemo/faculty_select_year_screen.dart';
import 'package:firstdemo/faculty_select_attendance_year_screen.dart';
import 'package:firstdemo/faculty_select_assignment_subject_screen.dart';
import 'package:firstdemo/faculty_chat_with_parents_screen.dart';
import 'package:firstdemo/faculty_enter_marks_screen.dart';

class FacultyDashboard extends StatefulWidget {
  const FacultyDashboard({super.key});

  @override
  State<FacultyDashboard> createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimations = List.generate(
      4, // For overview + 3 sections
      (index) => Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(index * 0.2, (index + 1) * 0.25, curve: Curves.easeOut),
      )),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty Dashboard', style: GoogleFonts.lato()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFF5F7FA), const Color(0xFFE9EBEE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          children: [
            SlideTransition(position: _slideAnimations[0], child: _buildWelcomeCard()),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimations[1],
              child: _buildDashboardSection(
                title: 'Academics',
                items: [
                  {'icon': Icons.group_outlined, 'label': 'My Students', 'color': Colors.blue.shade800, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => FacultySelectYearScreen()))},
                  {'icon': Icons.check_circle_outline, 'label': 'Take Attendance', 'color': Colors.green.shade700, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FacultySelectAttendanceYearScreen()))},
                  {'icon': Icons.assignment_outlined, 'label': 'Manage Assignments', 'color': Colors.orange.shade800, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FacultySelectAssignmentSubjectScreen()))},
                  {'icon': Icons.edit_note_outlined, 'label': 'Enter Marks', 'color': Colors.purple.shade700, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FacultyEnterMarksScreen()))},
                ],
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimations[2],
              child: _buildDashboardSection(
                title: 'Communication',
                items: [
                  {'icon': Icons.chat_bubble_outline, 'label': 'Chat with Parents', 'color': Colors.pink.shade700, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FacultyChatWithParentsScreen()))},
                  {'icon': Icons.campaign_outlined, 'label': 'Post Notice', 'color': Colors.lightBlue.shade700, 'onTap': () => print('Tapped Post Notice')},
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.primary, Colors.indigo.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, Dr. Ramesh!', style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Here are your tasks for today.', style: GoogleFonts.lato(fontSize: 16, color: Colors.white.withOpacity(0.9))),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardSection({required String title, required List<Map<String, dynamic>> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(title, style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
        ),
        Card(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: items.map((item) {
              return _buildDashboardTile(
                icon: item['icon'],
                label: item['label'],
                color: item['color'],
                isFirst: items.first == item,
                isLast: items.last == item,
                onTap: item['onTap'],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardTile({
    required IconData icon,
    required String label,
    required Color color,
    bool isFirst = false,
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(12) : Radius.zero,
          bottom: isLast ? const Radius.circular(12) : Radius.zero,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(12) : Radius.zero,
          bottom: isLast ? const Radius.circular(12) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(label, style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600))),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
