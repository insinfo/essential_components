import 'package:essential_components/src/fluent_validation/text_validation.dart';
import 'package:essential_components/src/handlers/exceptions/bad_request_exception.dart';
import 'package:test/test.dart';

import '../builders/user_builder.dart';

void main() {
  group('Tests o método _withCustomMessageError', () {
    setUp(() {});

    test('validate() is true', () {
      var response = TextValidation.init().validate();
      expect(response, isTrue);
    });
  });

  group('Testa método isNull', () {
    setUp(() {});

    test('Valida se o valor é nulo e retorna com sucesso', () {
      // Cenário
      var user = UserBuilder.oneUser().now();

      // Ação
      var result =
          TextValidation.init().whereValueIs(user.name).isNull().validate();

      // Resultado esperado
      expect(result, isTrue);
    });

    test(
        'Valida se o valor é nulo e lança uma exceção com mensagem customizada',
        () {
      var user = UserBuilder.oneUser().nameIsNull().now();

      expect(
          () => TextValidation.init()
              .whereValueIs(user.name)
              .whereMessageErrorIs('O nome do usuário é nulo')
              .isNull()
              .validate(),
          throwsA(TypeMatcher<BadRequestException>()));
    });

    test(
        'Valida se o valor é nulo e lança uma exceção com mensagem de erro padrão',
        () {
      var user = UserBuilder.oneUser().nameIsNull().now();

      expect(
          () =>
              TextValidation.init().whereValueIs(user.name).isNull().validate(),
          throwsA(TypeMatcher<BadRequestException>()));
    });

    test(
        'Valida se o valor é nulo e lança uma exceção com mensagem de erro de campo vazio',
        () {
      var user = UserBuilder.oneUser().nameIsNull().now();

      expect(
          () => TextValidation.init()
              .whereValueIs(user.name)
              .whereMessageErrorIs('')
              .isNull()
              .validate(),
          throwsA(TypeMatcher<BadRequestException>()));
    });
  });

  group('Testa método WhereValueIs', () {
    test('Test return value with success', () {
      var user = UserBuilder.oneUser().now();

      var result = TextValidation.init().whereValueIs(user.name);

      var actualValue = result.value;
      var expectedValue = user.name;

      expect(actualValue == expectedValue, isTrue);
    });
  });
}
