
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// A simple model for student data
class Student {
  String id;
  String name;
  String studentClass;
  String rollNumber;

  Student({required this.id, required this.name, required this.studentClass, required this.rollNumber});
}

class ManageStudentScreen extends StatefulWidget {
  const ManageStudentScreen({super.key});

  @override
  State<ManageStudentScreen> createState() => _ManageStudentScreenState();
}

class _ManageStudentScreenState extends State<ManageStudentScreen> {
  // Dummy data - in a real app, this would come from a database or API
  final List<Student> _allStudents = [
    Student(id: 'S001', name: 'Aarav Sharma', studentClass: '10 A', rollNumber: '1'),
    Student(id: 'S002', name: 'Vivaan Singh', studentClass: '10 B', rollNumber: '2'),
    Student(id: 'S003', name: 'Aditya Kumar', studentClass: '9 A', rollNumber: '3'),
    Student(id: 'S004', name: 'Diya Gupta', studentClass: '9 B', rollNumber: '4'),
    Student(id: 'S005', name: 'Ishaan Patel', studentClass: '11 A (Science)', rollNumber: '5'),
    Student(id: 'S006', name: 'Priya Mehta', studentClass: '12 B (Commerce)', rollNumber: '6'),
    Student(id: 'S007', name: 'Rohan Joshi', studentClass: '10 A', rollNumber: '7'),
  ];

  late List<Student> _filteredStudents;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredStudents = _allStudents;
    _searchController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = _allStudents.where((student) {
        return student.name.toLowerCase().contains(query) ||
               student.studentClass.toLowerCase().contains(query) ||
               student.rollNumber.toLowerCase().contains(query);
      }).toList();
    });
  }
  
  void _addStudent(Student student) {
    setState(() {
      _allStudents.add(student);
      _filterStudents();
    });
  }
  
  void _updateStudent(Student updatedStudent) {
    setState(() {
      final index = _allStudents.indexWhere((s) => s.id == updatedStudent.id);
      if (index != -1) {
        _allStudents[index] = updatedStudent;
        _filterStudents();
      }
    });
  }

  void _deleteStudent(String id) {
    setState(() {
      _allStudents.removeWhere((student) => student.id == id);
      _filterStudents();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Students', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 4,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _filteredStudents.isEmpty
                ? _buildEmptyState()
                : _buildStudentList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showStudentFormDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Student'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by name, class, or roll number...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No students found',
            style: GoogleFonts.lato(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 80), // Space for FAB
      itemCount: _filteredStudents.length,
      itemBuilder: (context, index) {
        final student = _filteredStudents[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              foregroundColor: Theme.of(context).colorScheme.primary,
              child: Text(student.name[0], style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Class: ${student.studentClass} | Roll No: ${student.rollNumber}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueGrey),
                  onPressed: () => _showStudentFormDialog(student: student),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _showDeleteConfirmationDialog(student),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
            onPressed: () {
              _deleteStudent(student.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${student.name} deleted successfully.'), backgroundColor: Colors.red),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showStudentFormDialog({Student? student}) {
    final isEditing = student != null;
    final nameController = TextEditingController(text: student?.name ?? '');
    final classController = TextEditingController(text: student?.studentClass ?? '');
    final rollNoController = TextEditingController(text: student?.rollNumber ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Student' : 'Add New Student'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name')),
              TextField(controller: classController, decoration: const InputDecoration(labelText: 'Class')),
              TextField(controller: rollNoController, decoration: const InputDecoration(labelText: 'Roll Number')),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FilledButton(
            child: Text(isEditing ? 'Update' : 'Add'),
            onPressed: () {
              final newStudent = Student(
                id: student?.id ?? DateTime.now().toIso8601String(), // Generate a unique ID for new students
                name: nameController.text,
                studentClass: classController.text,
                rollNumber: rollNoController.text,
              );
              
              if (isEditing) {
                _updateStudent(newStudent);
              } else {
                _addStudent(newStudent);
              }

              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  content: Text('Student ${isEditing ? 'updated' : 'added'} successfully.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
