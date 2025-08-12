// app/features/auth/domain/user_entity.dart
class UserEntity {
  UserEntity({
    required this.id,
    required this.email,
    this.name,
  });

  final String id;
  final String email;
  final String? name;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ name.hashCode;
}
