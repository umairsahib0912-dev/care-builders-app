import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String id;
  final String projectId;
  final String labourId;
  final String labourName;
  final DateTime date;
  final String status; // Present, Absent, Half Day
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? checkInLocation;
  final String? checkOutLocation;
  final String? remarks;
  final String markedBy;
  final DateTime createdAt;

  AttendanceModel({
    required this.id,
    required this.projectId,
    required this.labourId,
    required this.labourName,
    required this.date,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLocation,
    this.checkOutLocation,
    this.remarks,
    required this.markedBy,
    required this.createdAt,
  });

  // From Firestore
  factory AttendanceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AttendanceModel(
      id: doc.id,
      projectId: data['projectId'] ?? '',
      labourId: data['labourId'] ?? '',
      labourName: data['labourName'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      status: data['status'] ?? 'Absent',
      checkInTime: data['checkInTime'] != null
          ? (data['checkInTime'] as Timestamp).toDate()
          : null,
      checkOutTime: data['checkOutTime'] != null
          ? (data['checkOutTime'] as Timestamp).toDate()
          : null,
      checkInLocation: data['checkInLocation'],
      checkOutLocation: data['checkOutLocation'],
      remarks: data['remarks'],
      markedBy: data['markedBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'projectId': projectId,
      'labourId': labourId,
      'labourName': labourName,
      'date': Timestamp.fromDate(date),
      'status': status,
      'checkInTime': checkInTime != null ? Timestamp.fromDate(checkInTime!) : null,
      'checkOutTime': checkOutTime != null ? Timestamp.fromDate(checkOutTime!) : null,
      'checkInLocation': checkInLocation,
      'checkOutLocation': checkOutLocation,
      'remarks': remarks,
      'markedBy': markedBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // CopyWith
  AttendanceModel copyWith({
    String? id,
    String? projectId,
    String? labourId,
    String? labourName,
    DateTime? date,
    String? status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? checkInLocation,
    String? checkOutLocation,
    String? remarks,
    String? markedBy,
    DateTime? createdAt,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      labourId: labourId ?? this.labourId,
      labourName: labourName ?? this.labourName,
      date: date ?? this.date,
      status: status ?? this.status,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      checkInLocation: checkInLocation ?? this.checkInLocation,
      checkOutLocation: checkOutLocation ?? this.checkOutLocation,
      remarks: remarks ?? this.remarks,
      markedBy: markedBy ?? this.markedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
