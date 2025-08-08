// app/features/auth/presentation/auth_controller.dart
import 'package:get/get.dart';
import 'package:listatarefa1/app/features/auth/domain/user_entity.dart';

class AuthController extends GetxController {
  Rxn<UserEntity> user = Rxn<UserEntity>();
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  Future<void> loginWithEmail(String email, String password) async {
    _isLoading.value = true;
    try {
      // Implementar login
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    _isLoading.value = true;
    try {
      // Aqui você pode implementar a lógica de cadastro (ex: Firebase Auth)
      // Exemplo temporário:
      user.value = UserEntity(id: '1', email: email);
      Get.offAllNamed('/home');
    } catch (e) {
      // Trate o erro conforme necessário
      Get.snackbar('Erro', 'Falha ao registrar usuário');
    } finally {
      _isLoading.value = false;
    }
  }

  void signOut() {
    user.value = null;
    Get.offAllNamed('/login');
  }

  bool get isLoggedIn => user.value != null;
}
