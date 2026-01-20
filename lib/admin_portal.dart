
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firstdemo/main.dart';
import 'package:firstdemo/branch_selection_screen.dart';
import 'package:firstdemo/parent_branch_selection_screen.dart';
import 'package:firstdemo/faculty_branch_selection_screen.dart';
import 'package:firstdemo/class_branch_selection_screen.dart';
import 'package:firstdemo/subject_branch_selection_screen.dart';
import 'package:firstdemo/manage_timetable_page.dart';
import 'package:firstdemo/send_notice_page.dart';
import 'package:firstdemo/manage_events_page.dart';
import 'package:firstdemo/fee_branch_selection_screen.dart';
import 'package:firstdemo/reports_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with TickerProviderStateMixin {
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
      5, // For overview + 4 sections
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
        title: Text('Admin Dashboard', style: GoogleFonts.lato()),
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
                title: 'User Management',
                items: [
                  {'icon': Icons.person_add_alt_1, 'label': 'Manage Students', 'color': Colors.blue.shade800, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BranchSelectionScreen()))},
                  {'icon': Icons.group_add, 'label': 'Manage Faculty', 'color': Colors.green.shade700, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FacultyBranchSelectionScreen()))},
                  {'icon': Icons.family_restroom, 'label': 'Manage Parents', 'color': Colors.orange.shade700, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ParentBranchSelectionScreen()))}
                ],
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimations[2],
              child: _buildDashboardSection(
                title: 'Academics',
                items: [
                  {'icon': Icons.class_, 'label': 'Manage Classes', 'color': Colors.orange.shade800, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ClassBranchSelectionScreen()))},
                  {'icon': Icons.subject, 'label': 'Manage Subjects', 'color': Colors.purple.shade700, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectBranchSelectionScreen()))},
                  {'icon': Icons.schedule, 'label': 'Manage Timetable', 'color': Colors.red.shade700, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageTimetablePage()))}
                ],
              ),
            ),
             const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimations[3],
              child: _buildDashboardSection(
                title: 'Communication',
                items: [
                  {'icon': Icons.send, 'label': 'Send Notices', 'color': Colors.pink.shade700, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SendNoticePage()))},
                  {'icon': Icons.event, 'label': 'Manage Events', 'color': Colors.lightBlue.shade700, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageEventsPage()))}
                ],
              ),
            ),
             const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimations[4],
              child: _buildDashboardSection(
                title: 'Finance',
                items: [
                  {'icon': Icons.payment, 'label': 'Fee Management', 'color': Colors.teal.shade700, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FeeBranchSelectionScreen()))},
                  {'icon': Icons.receipt_long, 'label': 'Reports', 'color': Colors.brown.shade700, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsPage()))}
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
            Text('Welcome, Admin!', style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Here is a summary of the college.', style: GoogleFonts.lato(fontSize: 16, color: Colors.white.withOpacity(0.9))),
             const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _DashboardStat(count: '1,200', label: 'Students', icon: Icons.school),
                _DashboardStat(count: '80', label: 'Faculty', icon: Icons.people),
              ],
            )
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
class _DashboardStat extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;

  const _DashboardStat({required this.count, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(count, style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(label, style: GoogleFonts.lato(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ],
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: GoogleFonts.lato()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('This is the $title screen.', style: GoogleFonts.lato(fontSize: 18)),
      ),
    );
  }
}
