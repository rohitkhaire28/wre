import 'package:flutter/material.dart';
import 'package:firstdemo/button_styles.dart';

class ManageCoursesScreen extends StatefulWidget {
  const ManageCoursesScreen({super.key});

  @override
  State<ManageCoursesScreen> createState() => _ManageCoursesScreenState();
}

class _ManageCoursesScreenState extends State<ManageCoursesScreen> {
  final List<String> _courses = ['10th Grade Math', 'B.Sc. Physics'];
  final _courseController = TextEditingController();

  void _addCourse() {
    if (_courseController.text.isNotEmpty) {
      setState(() {
        _courses.add(_courseController.text);
        _courseController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a course name.')),
      );
    }
  }

  void _editCourse(int index) {
    _courseController.text = _courses[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Course'),
          content: TextField(
            controller: _courseController,
            decoration: const InputDecoration(labelText: 'Course Name'),
          ),
          actions: <Widget>[
            FilledButton(
              style: ButtonStyles.elevatedButtonStyle(context),
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FilledButton(
              style: ButtonStyles.elevatedButtonStyle(context),
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  _courses[index] = _courseController.text;
                  _courseController.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteCourse(int index) {
    setState(() {
      _courses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Courses'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _courseController,
                    decoration: const InputDecoration(
                      labelText: 'New Course Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  style: ButtonStyles.elevatedButtonStyle(context),
                  onPressed: _addCourse,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];
                return Card(
                  child: ListTile(
                    title: Text(course),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editCourse(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteCourse(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
