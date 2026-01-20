
import 'package:firstdemo/achievements_page.dart';
import 'package:firstdemo/assignments_page.dart';
import 'package:firstdemo/attendance_page.dart';
import 'package:firstdemo/chat_page.dart';
import 'package:firstdemo/events_notices_page.dart';
import 'package:firstdemo/marks_progress_page.dart';
import 'package:firstdemo/student_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firstdemo/main.dart';
import 'package:firstdemo/parent_fee_status_screen.dart';
import 'package:firstdemo/new_attendance_page.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> with TickerProviderStateMixin {
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
      4, // For student info card + 3 sections
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
        title: Text('Parent Dashboard', style: GoogleFonts.lato()),
        backgroundColor: const Color(0xFF3F51B5), // Indigo
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
            SlideTransition(position: _slideAnimations[0], child: _buildStudentInfoCard()),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimations[1],
              child: _buildDashboardSection(
                title: 'Academics',
                items: [
                  {'icon': Icons.assessment_outlined, 'label': 'Marks & Progress', 'color': Colors.orange.shade800, 'page': const MarksProgressPage()},
                  {'icon': Icons.assignment_outlined, 'label': 'Assignments', 'color': Colors.purple.shade700, 'page': const AssignmentsPage()},
                  {'icon': Icons.event_available, 'label': 'Attendance', 'color': Colors.green.shade700, 'page': const NewAttendancePage()},
                ],
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimations[2],
              child: _buildDashboardSection(
                title: 'Communication',
                items: [
                  {'icon': Icons.chat_bubble_outline, 'label': 'Chat with Teachers', 'color': Colors.pink.shade700, 'page': const ChatPage()},
                  {'icon': Icons.campaign_outlined, 'label': 'Events & Notices', 'color': Colors.teal.shade700, 'page': const EventsNoticesPage()},
                ],
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimations[3],
              child: _buildDashboardSection(
                title: 'General',
                items: [
                  {'icon': Icons.person_outline, 'label': 'User Profile', 'color': Colors.blue.shade800, 'page': const StudentProfilePage()},
                  {'icon': Icons.payment_outlined, 'label': 'Fee Status & Payments', 'color': Colors.lightBlue.shade700, 'page': const ParentFeeStatusScreen()},
                  {'icon': Icons.emoji_events_outlined, 'label': 'Achievements', 'color': Colors.amber.shade800, 'page': const AchievementsPage()},
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentInfoCard() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withAlpha(51),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [const Color(0xFF3F51B5), Colors.indigo.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white.withAlpha(230),
              child: const Icon(Icons.person, size: 40, color: Color(0xFF3F51B5)),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ramesh Suresh', style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Class: 10th A | Roll No: 25', style: GoogleFonts.lato(fontSize: 15, color: Colors.white.withAlpha(230)), softWrap: true),
                ],
              ),
            ),
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
          shadowColor: Colors.black.withAlpha(26),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: items.map((item) {
              return _buildDashboardTile(
                icon: item['icon'],
                label: item['label'],
                color: item['color'],
                isFirst: items.first == item,
                isLast: items.last == item,
                onTap: () {
                  if (item.containsKey('page')) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => item['page']),
                    );
                  } else {
                    print('Tapped on ${item['label']}');
                  }
                },
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
                backgroundColor: color.withAlpha(26),
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
