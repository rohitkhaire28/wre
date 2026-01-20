
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Model for Fee data
class Fee {
  String title;
  double amount;
  DateTime dueDate;
  bool isPaid;
  String? paymentId;

  Fee({
    required this.title,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
    this.paymentId,
  });
}

class ParentFeeStatusScreen extends StatefulWidget {
  const ParentFeeStatusScreen({super.key});

  @override
  State<ParentFeeStatusScreen> createState() => _ParentFeeStatusScreenState();
}

class _ParentFeeStatusScreenState extends State<ParentFeeStatusScreen> {
  // Dummy Data for a student. In a real app, this would be fetched from a server.
  final List<Fee> _fees = [
    Fee(
      title: 'College Fee (2024-2025)',
      amount: 85000.00,
      dueDate: DateTime(2024, 8, 1),
      isPaid: true,
      paymentId: 'TXN123456789',
    ),
    Fee(
      title: 'Exam Fee (Semester 1)',
      amount: 2500.00,
      dueDate: DateTime(2024, 9, 15),
      isPaid: false,
    ),
    Fee(
      title: 'Backlog Fee (Maths-II)',
      amount: 750.00,
      dueDate: DateTime(2024, 9, 10),
      isPaid: false,
    ),
    Fee(
      title: 'Bus Fee (Annual)',
      amount: 15000.00,
      dueDate: DateTime(2024, 7, 20),
      isPaid: true,
      paymentId: 'TXN987654321',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fee Status & Payments', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 4,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: _fees.length,
        itemBuilder: (context, index) {
          return _buildFeeCard(_fees[index]);
        },
      ),
    );
  }

  Widget _buildFeeCard(Fee fee) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final dateFormat = DateFormat('dd MMM, yyyy');

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: fee.isPaid ? Colors.green.shade200 : Colors.red.shade200,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    fee.title,
                    style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildStatusChip(fee.isPaid),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Amount: ${currencyFormat.format(fee.amount)}',
              style: GoogleFonts.lato(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              'Due Date: ${dateFormat.format(fee.dueDate)}',
              style: GoogleFonts.lato(fontSize: 16, color: Colors.black54),
            ),
            if (fee.isPaid && fee.paymentId != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Payment ID: ${fee.paymentId}',
                  style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isPaid) {
    return Chip(
      label: Text(isPaid ? 'PAID' : 'UNPAID'),
      backgroundColor: isPaid ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
      labelStyle: TextStyle(
        color: isPaid ? Colors.green.shade800 : Colors.red.shade800,
        fontWeight: FontWeight.bold,
      ),
      side: BorderSide(color: isPaid ? Colors.green.shade300 : Colors.red.shade300),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
