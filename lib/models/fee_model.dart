/// Fee model for individual fee entries
class Fee {
  const Fee({
    required this.id,
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  final String id;
  final String description;
  final double amount;
  final DateTime dueDate;
  final String status; // 'paid', 'pending', 'overdue'

  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      id: json['id']?.toString() ?? '',
      description: "Semester ${json['semester']?.toString() ?? ''}",
      amount: _parseDouble(json['total_amount']),
      dueDate: DateTime.tryParse(json['due_date']?.toString() ??
              json['dueDate']?.toString() ??
              '') ??
          DateTime.now(),
      status: json['status']?.toString() ?? 'pending',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

/// Fee summary model for overall fee status
class FeeSummary {
  const FeeSummary({
    required this.totalAmount,
    required this.paidAmount,
    required this.pendingAmount,
  });

  final double totalAmount;
  final double paidAmount;
  final double pendingAmount;

  factory FeeSummary.fromJson(Map<String, dynamic> json) {
    return FeeSummary(
      totalAmount:
          _parseDouble(json['total_due']) + _parseDouble(json['total_paid']),
      paidAmount: _parseDouble(json['total_paid']),
      pendingAmount: _parseDouble(json['total_due']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
