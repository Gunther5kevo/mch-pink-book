// lib/domain/models/patient.dart  ← UI model
class Patient {
  final String id;
  final String name;
  final String type; // 'mother' | 'child'
  final String? avatarUrl;
  final String? phone;

  const Patient({
    required this.id,
    required this.name,
    required this.type,
    this.avatarUrl,
    this.phone,
  });
}