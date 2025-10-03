import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/lead.dart';

part 'lead_model.g.dart';

/// Data model for Lead entity
@JsonSerializable()
class LeadModel extends Lead {
  const LeadModel({
    super.id,
    required super.carId,
    required super.userName,
    required super.userEmail,
    required super.userPhone,
    required super.createdAt,
    required super.carModel,
    required super.carValue,
    super.isSent = false,
  });

  /// Creates a LeadModel from JSON map
  factory LeadModel.fromJson(Map<String, dynamic> json) => _$LeadModelFromJson(json);

  /// Converts LeadModel to JSON map
  Map<String, dynamic> toJson() => _$LeadModelToJson(this);

  /// Creates a LeadModel from Lead entity
  factory LeadModel.fromEntity(Lead lead) {
    return LeadModel(
      id: lead.id,
      carId: lead.carId,
      userName: lead.userName,
      userEmail: lead.userEmail,
      userPhone: lead.userPhone,
      createdAt: lead.createdAt,
      carModel: lead.carModel,
      carValue: lead.carValue,
      isSent: lead.isSent,
    );
  }

  /// Converts LeadModel to Lead entity
  Lead toEntity() {
    return Lead(
      id: id,
      carId: carId,
      userName: userName,
      userEmail: userEmail,
      userPhone: userPhone,
      createdAt: createdAt,
      carModel: carModel,
      carValue: carValue,
      isSent: isSent,
    );
  }

  /// Creates a LeadModel from SQLite map
  factory LeadModel.fromMap(Map<String, dynamic> map) {
    return LeadModel(
      id: map['id'] as int?,
      carId: map['carId'] as int,
      userName: map['userName'] as String,
      userEmail: map['userEmail'] as String,
      userPhone: map['userPhone'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      carModel: map['carModel'] as String,
      carValue: map['carValue'] as double,
      isSent: (map['isSent'] as int?) == 1,
    );
  }

  /// Converts LeadModel to SQLite map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'carId': carId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'carModel': carModel,
      'carValue': carValue,
      'isSent': isSent ? 1 : 0,
    };
  }
}