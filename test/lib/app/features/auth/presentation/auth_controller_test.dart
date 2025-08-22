// test/lib/app/features/auth/presentation/auth_controller_test.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:listatarefa1/app/features/auth/domain/auth_repository.dart';
import 'package:listatarefa1/app/features/auth/domain/user_entity.dart';
import 'package:listatarefa1/app/features/auth/presentation/controller/auth_controller.dart';

// Mock do repositório
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthController controller;
  late MockAuthRepository mockRepository;

  final mockUser = UserEntity(id: '1', email: 'selma@email.com', name: 'Selma');

  setUp(() {
    Get.testMode = true;
    mockRepository = MockAuthRepository();
    controller = AuthController(
      repository: mockRepository,
      onError: (_, msg) => debugPrint("Erro capturado: $msg"),
    );
  });

  group('AuthController', () {
    test('signUp atualiza user quando sucesso', () async {
      when(() => mockRepository.signUp('Selma', 'selma@email.com', 'senha123'))
          .thenAnswer((_) async => mockUser);

      await controller.signUp('Selma', 'selma@email.com', 'senha123');

      expect(controller.person.value, equals(mockUser));
      expect(controller.isLoading, isFalse);
    });

    test('signUp não atualiza user quando falha', () async {
      when(() => mockRepository.signUp(any(), any(), any()))
          .thenAnswer((_) async => null);

      await controller.signUp('Selma', 'selma@email.com', 'senha123');

      expect(controller.person.value, isNull);
      expect(controller.isLoading, isFalse);
    });

    test('loginWithEmail atualiza user quando sucesso', () async {
      when(() => mockRepository.signIn('selma@email.com', 'senha123'))
          .thenAnswer((_) async => mockUser);

      await controller.loginWithEmail('selma@email.com', 'senha123');

      expect(controller.person.value, equals(mockUser));
      expect(controller.isLoading, isFalse);
    });

    test('loginWithEmail não atualiza user quando falha', () async {
      when(() => mockRepository.signIn(any(), any()))
          .thenAnswer((_) async => null);

      await controller.loginWithEmail('selma@email.com', 'senha123');

      expect(controller.person.value, isNull);
      expect(controller.isLoading, isFalse);
    });

    test('signOut limpa user', () async {
      controller.person.value = mockUser;

      when(() => mockRepository.signOut()).thenAnswer((_) async {});

      await controller.signOut();

      expect(controller.person.value, isNull);
    });
  });
}
