// app/features/auth/presentation/auth_controller.dart
import 'package:get/get.dart';
import 'package:listatarefa1/app/features/auth/domain/auth_repository.dart';
import 'package:listatarefa1/app/features/auth/domain/user_entity.dart';
import 'package:listatarefa1/app/features/auth/presentation/login_page.dart';
import 'package:listatarefa1/app/features/tasks/presentation/tasks_page.dart';

class AuthController extends GetxController {
  final AuthRepository _repository;

  AuthController({required AuthRepository repository})
      : _repository = repository;

  Rxn<UserEntity> user = Rxn<UserEntity>();
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  Future<void> loginWithEmail(String email, String password) async {
    _isLoading.value = true;
    try {
      final result = await _repository.signIn(email, password);
      if (result != null) {
        user.value = result;
        Get.off(HomePage());
      } else {
        Get.snackbar('Erro', 'Credenciais inválidas');
      }
    } catch (e) {
      Get.snackbar('Erro', 'Falha ao fazer login');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    _isLoading.value = true;
    try {
      final result = await _repository.signUp(email, password);
      if (result != null) {
        user.value = result;
        Get.off(HomePage());
      } else {
        Get.snackbar('Erro', 'Falha ao registrar usuário');
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    user.value = null;
    Get.off(LoginPage());
  }

  bool get isLoggedIn => user.value != null;
}
