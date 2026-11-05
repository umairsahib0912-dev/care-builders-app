import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryModel {
  final String id;
  final String projectId;
  final String materialName;
  final double quantity;
  final String unit;
  final double reorderLevel;
  final double pricePerUnit;
  final String? supplierName;
  final DateTime lastUpdated;
  final String updatedBy;
  final DateTime createdAt;

  InventoryModel({
    required this.id,
    required this.projectId,
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.reorderLevel,
    required this.pricePerUnit,
    this.supplierName,
    required this.lastUpdated,
    required this.updatedBy,
    required this.createdAt,
  });

  // Check if stock is low
  bool get isLowStock => quantity <= reorderLevel;

  // Get total value
  double get totalValue => quantity * pricePerUnit;

  // From Firestore
  factory InventoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return InventoryModel(
      id: doc.id,
      projectId: data['projectId'] ?? '',
      materialName: data['materialName'] ?? '',
      quantity: (data['quantity'] ?? 0).toDouble(),
      unit: data['unit'] ?? '',
      reorderLevel: (data['reorderLevel'] ?? 0).toDouble(),
      pricePerUnit: (data['pricePerUnit'] ?? 0).toDouble(),
      supplierName: data['supplierName'],
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
      updatedBy: data['updatedBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'projectId': projectId,
      'materialName': materialName,
      'quantity': quantity,
      'unit': unit,
      'reorderLevel': reorderLevel,
      'pricePerUnit': pricePerUnit,
      'supplierName': supplierName,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'updatedBy': updatedBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // CopyWith
  InventoryModel copyWith({
    String? id,
    String? projectId,
    String? materialName,
    double? quantity,
    String? unit,
    double? reorderLevel,
    double? pricePerUnit,
    String? supplierName,
    DateTime? lastUpdated,
    String? updatedBy,
    DateTime? createdAt,
  }) {
    return InventoryModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      materialName: materialName ?? this.materialName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      supplierName: supplierName ?? this.supplierName,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
