import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeModel {
  final String id;
  final String projectId;
  final String projectName;
  final double amount;
  final DateTime paymentDate;
  final String paymentMode;
  final String receiptNumber;
  final String? remarks;
  final String receivedBy;
  final DateTime createdAt;

  IncomeModel({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.amount,
    required this.paymentDate,
    required this.paymentMode,
    required this.receiptNumber,
    this.remarks,
    required this.receivedBy,
    required this.createdAt,
  });

  // From Firestore
  factory IncomeModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return IncomeModel(
      id: doc.id,
      projectId: data['projectId'] ?? '',
      projectName: data['projectName'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      paymentDate: (data['paymentDate'] as Timestamp).toDate(),
      paymentMode: data['paymentMode'] ?? '',
      receiptNumber: data['receiptNumber'] ?? '',
      remarks: data['remarks'],
      receivedBy: data['receivedBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'projectId': projectId,
      'projectName': projectName,
      'amount': amount,
      'paymentDate': Timestamp.fromDate(paymentDate),
      'paymentMode': paymentMode,
      'receiptNumber': receiptNumber,
      'remarks': remarks,
      'receivedBy': receivedBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // CopyWith
  IncomeModel copyWith({
    String? id,
    String? projectId,
    String? projectName,
    double? amount,
    DateTime? paymentDate,
    String? paymentMode,
    String? receiptNumber,
    String? remarks,
    String? receivedBy,
    DateTime? createdAt,
  }) {
    return IncomeModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentMode: paymentMode ?? this.paymentMode,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      remarks: remarks ?? this.remarks,
      receivedBy: receivedBy ?? this.receivedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
