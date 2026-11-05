import 'package:cloud_firestore/cloud_firestore.dart';

class LabourModel {
  final String id;
  final String workerName;
  final String phoneNumber;
  final String jobRole;
  final double dailyWage;
  final String address;
  final String? photoUrl;
  final DateTime joinDate;
  final bool isActive;
  final String createdBy;
  final DateTime createdAt;

  LabourModel({
    required this.id,
    required this.workerName,
    required this.phoneNumber,
    required this.jobRole,
    required this.dailyWage,
    required this.address,
    this.photoUrl,
    required this.joinDate,
    this.isActive = true,
    required this.createdBy,
    required this.createdAt,
  });

  // From Firestore
  factory LabourModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LabourModel(
      id: doc.id,
      workerName: data['workerName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      jobRole: data['jobRole'] ?? '',
      dailyWage: (data['dailyWage'] ?? 0).toDouble(),
      address: data['address'] ?? '',
      photoUrl: data['photoUrl'],
      joinDate: (data['joinDate'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'workerName': workerName,
      'phoneNumber': phoneNumber,
      'jobRole': jobRole,
      'dailyWage': dailyWage,
      'address': address,
      'photoUrl': photoUrl,
      'joinDate': Timestamp.fromDate(joinDate),
      'isActive': isActive,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // CopyWith
  LabourModel copyWith({
    String? id,
    String? workerName,
    String? phoneNumber,
    String? jobRole,
    double? dailyWage,
    String? address,
    String? photoUrl,
    DateTime? joinDate,
    bool? isActive,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return LabourModel(
      id: id ?? this.id,
      workerName: workerName ?? this.workerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      jobRole: jobRole ?? this.jobRole,
      dailyWage: dailyWage ?? this.dailyWage,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      joinDate: joinDate ?? this.joinDate,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
