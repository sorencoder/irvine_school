import 'package:flutter/material.dart';
import 'package:ias/screens/students/data/payment_history.dart';
// import 'package:ias/screens/students/student_dashboad.dart';

// Assuming StudentData is available or imported

// ------------------- The Pop-up Function -------------------

void showPaymentHistory(
    BuildContext context, List<PaymentRecord> paymentHistory) {
  final colorScheme = Theme.of(context).colorScheme;

  // Calculate total paid and total due for a summary
  final double totalPaid = paymentHistory
      .where((p) => p.isPaid)
      .fold(0.0, (sum, item) => sum + item.amount);
  final double totalDue = paymentHistory
      .where((p) => !p.isPaid)
      .fold(0.0, (sum, item) => sum + item.amount);

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        // Material 3 styling for shape and color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(
          'Payment History',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Content uses SizedBox and SingleChildScrollView for Material 3 structure and scrolling
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Summary Section
                buildSummaryRow(context, 'Total Paid:',
                    '₹${totalPaid.toStringAsFixed(2)}', colorScheme.primary),
                const SizedBox(height: 8),
                buildSummaryRow(context, 'Total Due:',
                    '₹${totalDue.toStringAsFixed(2)}', colorScheme.error),
                const Divider(height: 30),

                Text(
                  'Recent Transactions:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),

                // 2. Transaction History List
                ...paymentHistory.map((record) {
                  return buildPaymentTile(context, record, colorScheme);
                }).toList(),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('CLOSE', style: TextStyle(color: colorScheme.primary)),
          ),
        ],
      );
    },
  );
}

// ------------------- Helper Widgets -------------------

Widget buildSummaryRow(
    BuildContext context, String label, String value, Color color) {
  final colorScheme = Theme.of(context).colorScheme;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(color: colorScheme.onSurfaceVariant)),
      Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );
}

Widget buildPaymentTile(
    BuildContext context, PaymentRecord record, ColorScheme colorScheme) {
  final statusColor = record.isPaid ? colorScheme.primary : colorScheme.error;
  final statusText = record.isPaid ? 'Paid' : 'Due';

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(record.date,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 4),
            Text(statusText,
                style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(width: 16),

        // Description and Amount
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(record.description,
                  style: TextStyle(color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 4),
              Text('₹${record.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface)),
            ],
          ),
        ),
      ],
    ),
  );
}
