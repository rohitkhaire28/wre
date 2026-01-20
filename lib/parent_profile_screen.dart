import 'package:flutter/material.dart';
import 'package:firstdemo/student_profile_screen.dart'; // To navigate to the student's full profile

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  // Dummy Data for the parent profile
  final Map<String, dynamic> parentProfile = const {
    'profilePictureUrl': '', // Placeholder for URL
    'fullName': 'John Wonderland',
    'email': 'john.w@email.com',
    'phoneNumber': '+1-098-765-4321',
  };

  final Map<String, dynamic> childProfile = const {
    'fullName': 'Alice Wonderland',
    'studentId': 'SW-101',
    'currentClass': 'Final Year - Section A',
    'profilePictureUrl': '', // Placeholder
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildParentProfileHeader(context),
            const SizedBox(height: 24),
            _buildChildProfileCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildParentProfileHeader(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          parentProfile['fullName'],
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          parentProfile['email'],
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          parentProfile['phoneNumber'],
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildChildProfileCard(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Linked Student',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),
            ListTile(
              leading: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person_outline, color: Colors.white, size: 30),
              ),
              title: Text(childProfile['fullName'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('ID: ${childProfile['studentId']}\nClass: ${childProfile['currentClass']}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to the full student profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
