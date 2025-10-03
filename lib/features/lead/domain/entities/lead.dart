import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

/// Lead entity representing a user's interest in buying a car
class Lead extends Equatable {
  final int? id;
  final int carId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final DateTime createdAt;
  final String carModel;
  final double carValue;
  final bool isSent;

  const Lead({
    this.id,
    required this.carId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.createdAt,
    required this.carModel,
    required this.carValue,
    this.isSent = false,
  });

  @override
  List<Object?> get props => [
    id,
    carId,
    userName,
    userEmail,
    userPhone,
    createdAt,
    carModel,
    carValue,
    isSent,
  ];

  /// Creates a copy of this Lead with the given fields replaced with new values
  Lead copyWith({
    int? id,
    int? carId,
    String? userName,
    String? userEmail,
    String? userPhone,
    DateTime? createdAt,
    String? carModel,
    double? carValue,
    bool? isSent,
  }) {
    return Lead(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      createdAt: createdAt ?? this.createdAt,
      carModel: carModel ?? this.carModel,
      carValue: carValue ?? this.carValue,
      isSent: isSent ?? this.isSent,
    );
  }

  /// Returns formatted creation date
  String get formattedDate {
    return '${createdAt.day.toString().padLeft(2, '0')}/'
      '${createdAt.month.toString().padLeft(2, '0')}/'
      '${createdAt.year}';
  }

  /// Returns formatted car value as currency string
  String get formattedCarValue {
    double display = carValue;
    if (display < 1000) {
      final fractional = display - display.truncate();
      final isInteger = fractional == 0;
      final isHalf = (fractional - 0.5).abs() < 0.0000001;
      if (isInteger || isHalf) {
        display *= 1000;
      }
    }
    return 'R\$ ${NumberFormat("#,##0.00", "pt_BR").format(display)}';
  }
}