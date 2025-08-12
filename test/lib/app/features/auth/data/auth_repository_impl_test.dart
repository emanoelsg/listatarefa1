// test/lib/app/features/auth/data/auth_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:listatarefa1/app/features/auth/data/auth_repository_impl.dart';
import 'package:listatarefa1/app/features/auth/domain/user_entity.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockAuth;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    repository = AuthRepositoryImpl(auth: mockAuth);
  });

  test('signIn deve retornar UserEntity quando login for bem-sucedido',
      () async {
    final mockCredential = MockUserCredential();
    final mockUser = MockUser();

    when(() => mockAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => mockCredential);

    when(() => mockCredential.user).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('123');
    when(() => mockUser.email).thenReturn('selma@example.com');

    final result = await repository.signIn('selma@example.com', '123456');

    expect(result, isA<UserEntity>());
    expect(result?.id, '123');
    expect(result?.email, 'selma@example.com');
  });
}
