// app/features/auth/data/auth_repository_impl.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:listatarefa1/app/features/auth/domain/auth_repository.dart';
import 'package:listatarefa1/app/features/auth/domain/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final user = credential.user;
    if (user != null) {
      return UserEntity(id: user.uid, email: user.email ?? '');
    }
    return null;
  }

  @override
  Future<UserEntity?> signUp(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = credential.user;
    if (user != null) {
      return UserEntity(id: user.uid, email: user.email ?? '');
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      return UserEntity(id: user.uid, email: user.email ?? '');
    }
    return null;
  }
}