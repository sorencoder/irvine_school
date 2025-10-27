// Placeholder data structure for Payment Record (define this in your data file)
class PaymentRecord {
  final String date;
  final String description;
  final double amount;
  final bool isPaid;

  PaymentRecord(this.date, this.description, this.amount, this.isPaid);
}

// Extend StudentData (or create a mock list) for demonstration
final mockPaymentHistory = [
  PaymentRecord('2025-08-15', 'August Tuition Fee', 2500.00, true),
  PaymentRecord('2025-07-15', 'July Tuition Fee', 2500.00, true),
  PaymentRecord('2025-06-15', 'June Tuition Fee', 2500.00, true),
  PaymentRecord('2025-05-01', 'Annual Enrollment Fee', 5000.00, true),
  PaymentRecord('2025-04-15', 'April Tuition Fee', 2500.00, false), // Due
];
