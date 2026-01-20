import 'package:flutter/material.dart';

class EditStudentScreen extends StatefulWidget {
  final String studentName;

  const EditStudentScreen({super.key, required this.studentName});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  // Dummy data for student progress
  final Map<String, String> _studentProgress = {
    'Marks': 'A',
    'Attendance': '95%',
    'Assignments': '5/5',
    'Important Updates': 'None',
    'Projects': 'Completed',
    'Sports': 'Basketball team captain',
    'Achievements': 'Won the science fair',
    'Timetable': 'View',
    'Class Schedule': 'View',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.studentName}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListView.builder(
        itemCount: _studentProgress.length,
        itemBuilder: (context, index) {
          final title = _studentProgress.keys.elementAt(index);
          final value = _studentProgress.values.elementAt(index);
          return Card(
            child: ListTile(
              title: Text(title),
              subtitle: Text(value),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: Implement editing functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Editing $title coming soon!')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
