import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModel {
  final String id;
  final String projectId;
  final String supplierId;
  final String supplierName;
  final String invoiceNumber;
  final DateTime purchaseDate;
  final List<PurchaseItem> items;
  final double totalAmount;
  final String paymentMode;
  final String? remarks;
  final String createdBy;
  final DateTime createdAt;

  PurchaseModel({
    required this.id,
    required this.projectId,
    required this.supplierId,
    required this.supplierName,
    required this.invoiceNumber,
    required this.purchaseDate,
    required this.items,
    required this.totalAmount,
    required this.paymentMode,
    this.remarks,
    required this.createdBy,
    required this.createdAt,
  });

  // From Firestore
  factory PurchaseModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<PurchaseItem> itemsList = [];
    if (data['items'] != null) {
      itemsList = (data['items'] as List)
          .map((item) => PurchaseItem.fromMap(item))
          .toList();
    }

    return PurchaseModel(
      id: doc.id,
      projectId: data['projectId'] ?? '',
      supplierId: data['supplierId'] ?? '',
      supplierName: data['supplierName'] ?? '',
      invoiceNumber: data['invoiceNumber'] ?? '',
      purchaseDate: (data['purchaseDate'] as Timestamp).toDate(),
      items: itemsList,
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      paymentMode: data['paymentMode'] ?? '',
      remarks: data['remarks'],
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'projectId': projectId,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'invoiceNumber': invoiceNumber,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'paymentMode': paymentMode,
      'remarks': remarks,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class PurchaseItem {
  final String materialName;
  final double quantity;
  final String unit;
  final double pricePerUnit;
  final double totalPrice;

  PurchaseItem({
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    required this.totalPrice,
  });

  factory PurchaseItem.fromMap(Map<String, dynamic> map) {
    return PurchaseItem(
      materialName: map['materialName'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? '',
      pricePerUnit: (map['pricePerUnit'] ?? 0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'materialName': materialName,
      'quantity': quantity,
      'unit': unit,
      'pricePerUnit': pricePerUnit,
      'totalPrice': totalPrice,
    };
  }
}
