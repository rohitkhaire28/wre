
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Model for timetable entry
class TimetableEntry {
  String id;
  String className;
  String day;
  String timeSlot;
  String subject;
  String faculty;

  TimetableEntry({required this.id, required this.className, required this.day, required this.timeSlot, required this.subject, required this.faculty});
}

class ManageTimetableScreen extends StatefulWidget {
  const ManageTimetableScreen({super.key});

  @override
  State<ManageTimetableScreen> createState() => _ManageTimetableScreenState();
}

class _ManageTimetableScreenState extends State<ManageTimetableScreen> {
  // Dummy data
  final List<TimetableEntry> _timetable = [
    TimetableEntry(id: 'T01', className: '10 A', day: 'Monday', timeSlot: '09:00 - 10:00', subject: 'Mathematics', faculty: 'Prof. Sunita Sharma'),
    TimetableEntry(id: 'T02', className: '10 A', day: 'Monday', timeSlot: '10:00 - 11:00', subject: 'Science', faculty: 'Dr. Anil Singh'),
    TimetableEntry(id: 'T03', className: '10 B', day: 'Tuesday', timeSlot: '11:00 - 12:00', subject: 'English', faculty: 'Dr. Ramesh Kumar'),
  ];

  late List<TimetableEntry> _filteredTimetable;
  String? _selectedClass;
  final List<String> _classOptions = ['10 A', '10 B', '11 A (Science)', '12 B (Commerce)'];

  @override
  void initState() {
    super.initState();
    _filteredTimetable = _timetable;
  }

  void _filterTimetable() {
    if (_selectedClass == null) {
      setState(() => _filteredTimetable = _timetable);
    } else {
      setState(() {
        _filteredTimetable = _timetable.where((entry) => entry.className == _selectedClass).toList();
      });
    }
  }

  void _addEntry(TimetableEntry entry) {
    setState(() {
      _timetable.add(entry);
      _filterTimetable();
    });
  }

  void _updateEntry(TimetableEntry updatedEntry) {
    setState(() {
      final index = _timetable.indexWhere((e) => e.id == updatedEntry.id);
      if (index != -1) {
        _timetable[index] = updatedEntry;
        _filterTimetable();
      }
    });
  }

  void _deleteEntry(String id) {
    setState(() {
      _timetable.removeWhere((e) => e.id == id);
      _filterTimetable();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Timetable', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 4,
      ),
      body: Column(
        children: [
          _buildClassFilter(),
          Expanded(
            child: _filteredTimetable.isEmpty
                ? _buildEmptyState()
                : _buildTimetableList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTimetableFormDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Entry'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildClassFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButtonFormField<String>(
        value: _selectedClass,
        hint: const Text('Filter by Class'),
        onChanged: (value) {
          setState(() {
            _selectedClass = value;
            _filterTimetable();
          });
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No timetable entries found',
            style: GoogleFonts.lato(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 80),
      itemCount: _filteredTimetable.length,
      itemBuilder: (context, index) {
        final entry = _filteredTimetable[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: Text('${entry.subject} - ${entry.className}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${entry.day}, ${entry.timeSlot} - ${entry.faculty}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueGrey),
                  onPressed: () => _showTimetableFormDialog(entry: entry),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _showDeleteConfirmationDialog(entry),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(TimetableEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
            onPressed: () {
              _deleteEntry(entry.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Entry deleted successfully.'), backgroundColor: Colors.red),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showTimetableFormDialog({TimetableEntry? entry}) {
    final isEditing = entry != null;
    final classNameController = TextEditingController(text: entry?.className ?? _selectedClass ?? '');
    final dayController = TextEditingController(text: entry?.day ?? '');
    final timeController = TextEditingController(text: entry?.timeSlot ?? '');
    final subjectController = TextEditingController(text: entry?.subject ?? '');
    final facultyController = TextEditingController(text: entry?.faculty ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Entry' : 'Add New Entry'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: classNameController, decoration: const InputDecoration(labelText: 'Class Name')),
              TextField(controller: dayController, decoration: const InputDecoration(labelText: 'Day (e.g., Monday)')),
              TextField(controller: timeController, decoration: const InputDecoration(labelText: 'Time Slot (e.g., 09:00 - 10:00)')),
              TextField(controller: subjectController, decoration: const InputDecoration(labelText: 'Subject')),
              TextField(controller: facultyController, decoration: const InputDecoration(labelText: 'Faculty Name')),
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
              final newEntry = TimetableEntry(
                id: entry?.id ?? DateTime.now().toIso8601String(),
                className: classNameController.text,
                day: dayController.text,
                timeSlot: timeController.text,
                subject: subjectController.text,
                faculty: facultyController.text,
              );
              
              if (isEditing) {
                _updateEntry(newEntry);
              } else {
                _addEntry(newEntry);
              }

              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  content: Text('Timetable entry ${isEditing ? 'updated' : 'added'} successfully.'),
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
