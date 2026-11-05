import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final String projectId;
  final String projectName;
  final String category;
  final double amount;
  final DateTime expenseDate;
  final String paidTo;
  final String billNumber;
  final String paymentMode;
  final String? description;
  final String? receiptUrl;
  final String createdBy;
  final DateTime createdAt;

  ExpenseModel({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.category,
    required this.amount,
    required this.expenseDate,
    required this.paidTo,
    required this.billNumber,
    required this.paymentMode,
    this.description,
    this.receiptUrl,
    required this.createdBy,
    required this.createdAt,
  });

  // From Firestore
  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id,
      projectId: data['projectId'] ?? '',
      projectName: data['projectName'] ?? '',
      category: data['category'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      expenseDate: (data['expenseDate'] as Timestamp).toDate(),
      paidTo: data['paidTo'] ?? '',
      billNumber: data['billNumber'] ?? '',
      paymentMode: data['paymentMode'] ?? '',
      description: data['description'],
      receiptUrl: data['receiptUrl'],
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'projectId': projectId,
      'projectName': projectName,
      'category': category,
      'amount': amount,
      'expenseDate': Timestamp.fromDate(expenseDate),
      'paidTo': paidTo,
      'billNumber': billNumber,
      'paymentMode': paymentMode,
      'description': description,
      'receiptUrl': receiptUrl,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // CopyWith
  ExpenseModel copyWith({
    String? id,
    String? projectId,
    String? projectName,
    String? category,
    double? amount,
    DateTime? expenseDate,
    String? paidTo,
    String? billNumber,
    String? paymentMode,
    String? description,
    String? receiptUrl,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      expenseDate: expenseDate ?? this.expenseDate,
      paidTo: paidTo ?? this.paidTo,
      billNumber: billNumber ?? this.billNumber,
      paymentMode: paymentMode ?? this.paymentMode,
      description: description ?? this.description,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
