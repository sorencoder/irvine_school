import 'package:flutter/material.dart';
import 'package:ias/ui/screens/students/data/payment_history.dart';
import 'package:ias/ui/screens/students/data/student_data.dart';
import 'package:ias/ui/screens/students/widget/customWidget/fees_payments.dart';

Widget feesCard(
    BuildContext context, StudentData student, ColorScheme colorScheme) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Icon(Icons.payments, size: 35, color: colorScheme.tertiary),
      title: const Text('Fee Payment Due'),
      subtitle: Text('Due Date: ${student.nextFeeDueDate}'),
      trailing: FilledButton.tonal(
        onPressed: () {/* Navigate to fee payment screen */},
        child: const Text('Pay Now'),
      ),
      onTap: () {
        showPaymentHistory(context, mockPaymentHistory);
      },
    ),
  );
}
