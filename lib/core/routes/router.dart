import 'package:go_router/go_router.dart';

import '../../presentation/pages/contacts/contacts_page.dart';

/// Маршруты приложения
abstract class AppRouterNames {
  static const String contacts = 'contacts';
}

/// Маршрутизатор приложения
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRouterNames.contacts,
        builder: (context, state) => const ContactsPage(),
      ),
    ],
  );
}
