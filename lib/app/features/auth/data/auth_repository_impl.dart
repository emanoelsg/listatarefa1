// app/features/auth/data/auth_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:listatarefa1/app/features/auth/domain/auth_repository.dart';
import 'package:listatarefa1/app/features/auth/domain/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserEntity?> signUp(String name, String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userId = credential.user?.uid;
    if (userId == null) return null;

    await _firestore.collection('users').doc(userId).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return UserEntity(id: userId, email: email, name: name);
  }

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userId = credential.user?.uid;
    if (userId == null) return null;

    final doc = await _firestore.collection('users').doc(userId).get();
    final data = doc.data();
    if (data == null) return null;

    return UserEntity(id: userId, email: email, name: data['name'] ?? '');
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data();
    if (data == null) return null;

    return UserEntity(
        id: user.uid, email: user.email ?? '', name: data['name'] ?? '');
  }
}
