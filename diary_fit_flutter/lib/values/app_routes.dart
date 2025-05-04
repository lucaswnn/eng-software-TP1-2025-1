// Flutter app routes
class AppRoutes {
  const AppRoutes._(); // Private constructor to prevent instantiation
  // TODO: colocar rotas para tela da lista de clientes e dados gerais do cliente atual
  // (no caso de usuários profissionais)
  static const String login = '/login';
  static const String register = '/login/registro';
  static const String home = '/home';
  static const String anamnesis = '/home/anamnese';
  static const String associatedProfessionals = '/home/profissionais';
  static const String logout = '/home/logout/';
  static const String clientList = '/home/clientes';
  static const String addClient = '/home/adicionar_cliente';
  static const String addFoodMenu = '/home/adicionar_cardapio';
}
