
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Model for student attendance data
class StudentAttendance {
  String studentId;
  String name;
  bool isPresent;

  StudentAttendance({required this.studentId, required this.name, this.isPresent = true});
}

class TakeAttendanceScreen extends StatefulWidget {
  const TakeAttendanceScreen({super.key});

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  String? _selectedClass;
  final List<String> _classOptions = ['10 A', '10 B', '11 A (Science)'];
  List<StudentAttendance> _attendanceList = [];
  bool _isClassSelected = false;

  // Dummy student data for different classes
  final Map<String, List<StudentAttendance>> _classStudents = {
    '10 A': [
      StudentAttendance(studentId: 'S001', name: 'Aarav Sharma'),
      StudentAttendance(studentId: 'S002', name: 'Vivaan Singh'),
      StudentAttendance(studentId: 'S007', name: 'Rohan Joshi'),
    ],
    '10 B': [
      StudentAttendance(studentId: 'S003', name: 'Aditya Kumar'),
      StudentAttendance(studentId: 'S004', name: 'Diya Gupta'),
    ],
     '11 A (Science)': [
      StudentAttendance(studentId: 'S005', name: 'Ishaan Patel'),
    ],
  };

  void _loadStudentsForClass(String className) {
    setState(() {
      _attendanceList = _classStudents[className] ?? [];
      _isClassSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Attendance', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 4,
      ),
      body: Column(
        children: [
          _buildClassSelector(),
          if (_isClassSelected)
            Expanded(
              child: _attendanceList.isEmpty
                  ? _buildEmptyState('No students found for this class.')
                  : _buildAttendanceList(),
            )
          else
            Expanded(child: _buildEmptyState('Please select a class to take attendance.')),
        ],
      ),
      bottomNavigationBar: _isClassSelected && _attendanceList.isNotEmpty ? _buildSubmitButton() : null,
    );
  }

  Widget _buildClassSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButtonFormField<String>(
        value: _selectedClass,
        hint: const Text('Select a Class'),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedClass = value;
              _loadStudentsForClass(value);
            });
          }
        },
        items: _classOptions.map((String className) {
          return DropdownMenuItem<String>(
            value: className,
            child: Text(className),
          );
        }).toList(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.class_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 80),
      itemCount: _attendanceList.length,
      itemBuilder: (context, index) {
        final student = _attendanceList[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: CheckboxListTile(
            title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            value: student.isPresent,
            onChanged: (bool? value) {
              setState(() {
                student.isPresent = value ?? false;
              });
            },
            activeColor: Theme.of(context).colorScheme.primary,
            secondary: CircleAvatar(
              child: Text(student.name[0]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FilledButton.icon(
        icon: const Icon(Icons.check),
        label: const Text('Submit Attendance'),
        onPressed: () {
          // In a real app, you would save this data to your backend.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Attendance submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        },
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
