// app/features/auth/presentation/controller/auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/features/auth/domain/auth_repository.dart';
import 'package:listatarefa1/app/features/auth/domain/user_entity.dart';
import 'package:listatarefa1/app/features/auth/presentation/pages/login/login_page.dart';
import 'package:listatarefa1/app/features/tasks/presentation/tasks_page.dart';

class AuthController extends GetxController {
  final AuthRepository _repository;
  final void Function(String title, String message)? onError;

  AuthController({
    required AuthRepository repository,
    this.onError,
  }) : _repository = repository;

  final Rxn<UserEntity> person = Rxn<UserEntity>();
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => person.value != null;
    final Rx<User?> _user = Rx<User?>(null);
  User? get user => _user.value;
 @override
  void onInit() {
  
    FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) {
      _user.value = firebaseUser;
    });
    super.onInit();
  }
  void _showError(String message) {
    if (Get.testMode && onError != null) {
      onError!("Erro", message);
      return;
    }

    Get.snackbar(
      'Erro',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  Future<void> loginWithEmail(String email, String password) async {
    _isLoading.value = true;
    try {
      final result = await _repository.signIn(email, password);
      if (result != null) {
        person.value = result;
        Get.off(() => HomePage());
      } else {
        _showError('Credenciais inválidas');
      }
    } catch (e) {
      _showError('Falha ao fazer login');
      debugPrint('Login error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    _isLoading.value = true;
    try {
      final result = await _repository.signUp(name, email, password);
      if (result != null) {
        person.value = UserEntity(id: result.id, email: result.email, name: name);
        Get.off(() => HomePage());
      } else {
        _showError('Falha ao registrar usuário');
      }
    } catch (e) {
      _showError('Erro inesperado ao registrar');
      debugPrint('SignUp error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    person.value = null;
    Get.off(() => LoginPage());
  }
}
