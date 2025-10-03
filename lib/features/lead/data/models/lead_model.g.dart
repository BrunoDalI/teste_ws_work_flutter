part of 'lead_model.dart';

LeadModel _$LeadModelFromJson(Map<String, dynamic> json) => LeadModel(
  id: (json['id'] as num?)?.toInt(),
  carId: (json['carId'] as num).toInt(),
  userName: json['userName'] as String,
  userEmail: json['userEmail'] as String,
  userPhone: json['userPhone'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  carModel: json['carModel'] as String,
  carValue: (json['carValue'] as num).toDouble(),
  isSent: json['isSent'] as bool? ?? false,
);

Map<String, dynamic> _$LeadModelToJson(LeadModel instance) => <String, dynamic>{
  'id': instance.id,
  'carId': instance.carId,
  'userName': instance.userName,
  'userEmail': instance.userEmail,
  'userPhone': instance.userPhone,
  'createdAt': instance.createdAt.toIso8601String(),
  'carModel': instance.carModel,
  'carValue': instance.carValue,
  'isSent': instance.isSent,
};
