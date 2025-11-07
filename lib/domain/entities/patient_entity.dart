// lib/domain/entities/patient_entity.dart
import 'package:mch_pink_book/core/constants/app_constants.dart';
import 'package:mch_pink_book/domain/entities/user_entity.dart';

class Patient {
  final String id;
  final String name;
  final String type;          // 'mother' or 'child'
  final String? phone;
  final String? photoUrl;
  final String? motherId;     // only for children
  final String? nationalId;   // optional – used in search

  const Patient({
    required this.id,
    required this.name,
    required this.type,
    this.phone,
    this.photoUrl,
    this.motherId,
    this.nationalId,
  });

  factory Patient.fromUser(UserEntity user) {
    return Patient(
      id: user.id,
      name: user.fullName,
      type: user.role == UserRole.mother ? 'mother' : 'child',
      phone: user.phoneE164,
      photoUrl: user.photoUrl,
      motherId: null,
      nationalId: user.nationalId,
    );
  }

  // -----------------------------------------------------------------
  // Helper used by the provider for fast search
  // -----------------------------------------------------------------
  bool matches(String query) {
    final q = query.toLowerCase();
    return name.toLowerCase().contains(q) ||
        id.toLowerCase().contains(q) ||
        phone?.contains(q) == true ||
        nationalId?.contains(q) == true;
  }
}