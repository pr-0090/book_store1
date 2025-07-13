import 'package:book_store/features/auth/domain/entity/user_entity.dart';
import 'package:book_store/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_mock.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late RegisterUserUseCase usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();

    // Register fallback value for AuthEntity, if needed by mocktail
    registerFallbackValue(UserEntity(username: '', email: '', password: ''));

    usecase = RegisterUserUseCase(userRepository: mockAuthRepository);
  });

  test(
    '✅ should call registerUser and return Right(void) when registration succeeds',
    () async {
      // Arrange
      const params = RegisterUserParams(
        name: 'preeti',
        email: 'preeti@example.com',
        password: 'password123',
      );

      when(
        () => mockAuthRepository.registerUser(any()),
      ).thenAnswer((_) async => const Right(null)); // success with void result

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.registerUser(any())).called(1);
    },
  );
}
