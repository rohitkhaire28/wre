
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Model for subject data
class Subject {
  String id;
  String name;
  String subjectCode;

  Subject({required this.id, required this.name, required this.subjectCode});
}

class ManageSubjectsScreen extends StatefulWidget {
  const ManageSubjectsScreen({super.key});

  @override
  State<ManageSubjectsScreen> createState() => _ManageSubjectsScreenState();
}

class _ManageSubjectsScreenState extends State<ManageSubjectsScreen> {
  // Dummy data
  final List<Subject> _allSubjects = [
    Subject(id: 'S01', name: 'English', subjectCode: 'ENG101'),
    Subject(id: 'S02', name: 'Mathematics', subjectCode: 'MATH101'),
    Subject(id: 'S03', name: 'Science', subjectCode: 'SCI101'),
    Subject(id: 'S04', name: 'History', subjectCode: 'HIST101'),
  ];

  late List<Subject> _filteredSubjects;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredSubjects = _allSubjects;
    _searchController.addListener(_filterSubjects);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterSubjects() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSubjects = _allSubjects.where((s) {
        return s.name.toLowerCase().contains(query) || s.subjectCode.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _addSubject(Subject subject) {
    setState(() {
      _allSubjects.add(subject);
      _filterSubjects();
    });
  }

  void _updateSubject(Subject updatedSubject) {
    setState(() {
      final index = _allSubjects.indexWhere((s) => s.id == updatedSubject.id);
      if (index != -1) {
        _allSubjects[index] = updatedSubject;
        _filterSubjects();
      }
    });
  }

  void _deleteSubject(String id) {
    setState(() {
      _allSubjects.removeWhere((s) => s.id == id);
      _filterSubjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Subjects', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 4,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _filteredSubjects.isEmpty
                ? _buildEmptyState()
                : _buildSubjectList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSubjectFormDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Subject'),
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
          hintText: 'Search by subject name or code...',
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
            'No subjects found',
            style: GoogleFonts.lato(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 80),
      itemCount: _filteredSubjects.length,
      itemBuilder: (context, index) {
        final subject = _filteredSubjects[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              foregroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.book_outlined),
            ),
            title: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Code: ${subject.subjectCode}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueGrey),
                  onPressed: () => _showSubjectFormDialog(subject: subject),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _showDeleteConfirmationDialog(subject),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(Subject subject) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete ${subject.name}?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
            onPressed: () {
              _deleteSubject(subject.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${subject.name} deleted successfully.'), backgroundColor: Colors.red),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSubjectFormDialog({Subject? subject}) {
    final isEditing = subject != null;
    final nameController = TextEditingController(text: subject?.name ?? '');
    final codeController = TextEditingController(text: subject?.subjectCode ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Subject' : 'Add New Subject'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Subject Name')),
              TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Subject Code')),
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
              final newSubject = Subject(
                id: subject?.id ?? DateTime.now().toIso8601String(),
                name: nameController.text,
                subjectCode: codeController.text,
              );
              
              if (isEditing) {
                _updateSubject(newSubject);
              } else {
                _addSubject(newSubject);
              }

              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  content: Text('Subject ${isEditing ? 'updated' : 'added'} successfully.'),
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
