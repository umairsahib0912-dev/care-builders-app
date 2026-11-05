import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierModel {
  final String id;
  final String supplierName;
  final String contactPerson;
  final String phoneNumber;
  final String email;
  final String address;
  final String materialType;
  final double totalPurchaseAmount;
  final DateTime createdAt;
  final String createdBy;

  SupplierModel({
    required this.id,
    required this.supplierName,
    required this.contactPerson,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.materialType,
    this.totalPurchaseAmount = 0.0,
    required this.createdAt,
    required this.createdBy,
  });

  // From Firestore
  factory SupplierModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SupplierModel(
      id: doc.id,
      supplierName: data['supplierName'] ?? '',
      contactPerson: data['contactPerson'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      materialType: data['materialType'] ?? '',
      totalPurchaseAmount: (data['totalPurchaseAmount'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'supplierName': supplierName,
      'contactPerson': contactPerson,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'materialType': materialType,
      'totalPurchaseAmount': totalPurchaseAmount,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }

  // CopyWith
  SupplierModel copyWith({
    String? id,
    String? supplierName,
    String? contactPerson,
    String? phoneNumber,
    String? email,
    String? address,
    String? materialType,
    double? totalPurchaseAmount,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      supplierName: supplierName ?? this.supplierName,
      contactPerson: contactPerson ?? this.contactPerson,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      materialType: materialType ?? this.materialType,
      totalPurchaseAmount: totalPurchaseAmount ?? this.totalPurchaseAmount,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
