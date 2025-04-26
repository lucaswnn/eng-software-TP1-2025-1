import 'package:diary_fit/services/client_auth.dart';

class AppStrings {
  const AppStrings._();

  static const String appName = 'Diary Fit';
  static const String loginLabel = 'usuário';
  static const String passwordLabel = 'senha';
  static const String confirmPasswordLabel = 'confirmar senha';
  static const String invalidLoginMessage =
      'Por favor, insira um usuário válido';
  static const String invalidPasswordMessage =
      'Por favor, insira uma senha válida';
  static const String invalidConfirmPasswordMessage = 'As senhas não coincidem';
  static const String registerButton = 'Novo por aqui? Cadastre-se!';
  static const String registerTitle = 'Cadastro';
  static const String registerTypeLabel = 'Tipo de conta';
  static const String successRegisterMessage = 'Cadastro feito com sucesso!';

  static const String pageNotFoundError = 'ops...\nPágina não encontrada';

  static const String genericServerError =
      'Ops... parece que o servidor está fora do ar\nTente novamente mais tarde';

  static const String loginButton = 'Entrar';

  static const _clientTypeMap = {
    ClientType.trainer: 'Educador físico',
    ClientType.nutritionist: 'Nutricionista',
    ClientType.patient: 'Paciente',
  };

  static String get patientLabel => _clientTypeMap[ClientType.patient]!;

  static String get trainerLabel => _clientTypeMap[ClientType.trainer]!;

  static String get nutritionistLabel =>
      _clientTypeMap[ClientType.nutritionist]!;
}
