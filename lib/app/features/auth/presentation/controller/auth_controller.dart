// app/features/auth/presentation/controller/auth_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/features/auth/domain/auth_repository.dart';
import 'package:listatarefa1/app/features/auth/domain/user_entity.dart';
import 'package:listatarefa1/app/features/auth/presentation/pages/login/login_page.dart';
import 'package:listatarefa1/app/features/tasks/presentation/pages/tasks_page.dart';

class AuthController extends GetxController {
  final AuthRepository _repository;
  final void Function(String title, String message)? onError;

  AuthController({
    required AuthRepository repository,
    this.onError,
  }) : _repository = repository;

  final Rxn<UserEntity> person = Rxn<UserEntity>();
  final RxBool _isLoading = false.obs;
  final Rx<User?> _user = Rx<User?>(null);

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  bool get isLoggedIn => person.value != null;
  User? get user => _user.value;

  @override
  void onInit() {
    super.onInit();

    FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) {
      _user.value = firebaseUser;

      if (firebaseUser != null) {
        Get.offAll(() => HomePage(userId: firebaseUser.uid));
      } else {
        Get.offAll(() => const LoginPage());
      }
    });
  }

  
  Future<void> signUp(String name, String email, String password) async {
  try {
    isLoading = true;

    final result = await _repository.signUp(name, email, password);
    if (result != null) {
      person.value = result;
      Get.offAll(() => HomePage(userId: result.id));
    } else {
      _showError('Falha ao criar conta');
    }
  } catch (e) {
    final errorMessage = e is FirebaseAuthException
        ? e.message ?? 'Erro desconhecido'
        : e.toString();
    _showError(errorMessage);
  } finally {
    isLoading = false;
  }
}

  Future<void> loginWithEmail(String email, String password) async {
    isLoading = true;
    try {
      final result = await _repository.signIn(email, password);
      if (result != null) {
        person.value = result;
        Get.offAll(() => HomePage(userId: result.id));
      } else {
        _showError('Credenciais inválidas');
      }
    } catch (e) {
      _showError('Falha ao fazer login');
      debugPrint('Login error: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    person.value = null;
    Get.off(() => const LoginPage());
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
      duration: const Duration(seconds: 3),
    );
  }
}