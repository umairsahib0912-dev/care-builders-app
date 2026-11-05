import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String projectName;
  final String clientName;
  final String clientContact;
  final String siteLocation;
  final double budget;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String description;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProjectModel({
    required this.id,
    required this.projectName,
    required this.clientName,
    required this.clientContact,
    required this.siteLocation,
    required this.budget,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  // From Firestore
  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProjectModel(
      id: doc.id,
      projectName: data['projectName'] ?? '',
      clientName: data['clientName'] ?? '',
      clientContact: data['clientContact'] ?? '',
      siteLocation: data['siteLocation'] ?? '',
      budget: (data['budget'] ?? 0).toDouble(),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'Planned',
      description: data['description'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'projectName': projectName,
      'clientName': clientName,
      'clientContact': clientContact,
      'siteLocation': siteLocation,
      'budget': budget,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status,
      'description': description,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // CopyWith
  ProjectModel copyWith({
    String? id,
    String? projectName,
    String? clientName,
    String? clientContact,
    String? siteLocation,
    double? budget,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? description,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      clientName: clientName ?? this.clientName,
      clientContact: clientContact ?? this.clientContact,
      siteLocation: siteLocation ?? this.siteLocation,
      budget: budget ?? this.budget,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
