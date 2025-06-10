import 'package:creativolabs/core/constants/colors.dart';
import 'package:creativolabs/core/widgets/footer.dart';
import 'package:creativolabs/core/widgets/site_logo.dart';
import 'package:creativolabs/screens/about/view/about.dart';
import 'package:creativolabs/screens/authwrapper/view/authwrapper.dart';
import 'package:creativolabs/screens/changepassword/view/change_password.dart';
import 'package:creativolabs/screens/contact/view/contact.dart';
import 'package:creativolabs/screens/customers/view/create_customer.dart';
import 'package:creativolabs/screens/customers/view/customers.dart';
import 'package:creativolabs/screens/customers/view/detail_customer.dart';
import 'package:creativolabs/screens/dashboard/view/dashboard.dart';
import 'package:creativolabs/screens/home/view/home.dart';
import 'package:creativolabs/screens/politics/view/politics.dart';
import 'package:creativolabs/screens/profile/view/profile.dart';
import 'package:creativolabs/screens/resetpassword/view/reset_password.dart';
import 'package:creativolabs/screens/sales/view/create_sale.dart';
import 'package:creativolabs/screens/sales/view/sales.dart';
import 'package:creativolabs/screens/service/view/create_service.dart';
import 'package:creativolabs/screens/service/view/edit_service.dart';
import 'package:creativolabs/screens/service/view/service.dart';
import 'package:creativolabs/screens/signin/view/signin.dart';
import 'package:creativolabs/screens/signup/view/signup.dart';
import 'package:creativolabs/screens/terms/view/terms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final publicRoutes = [
      '/signin',
      '/signup',
      '/home',
      '/about',
      '/contact',
      '/services',
      '/terms',
      '/politics',
      '/reset-password',
      '/change-password',
    ];
    if (user == null && !publicRoutes.contains(state.uri.toString())) {
      return '/home';
    }

    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        final user = FirebaseAuth.instance.currentUser;
        return Scaffold(
          backgroundColor: CustomColor.navBarBg,
          appBar: AppBar(
            backgroundColor: CustomColor.navBarBg,
            elevation: 0,
            leading: user != null
                ? Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  )
                : null,
            title: SizedBox(
              height: 60,
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SiteLogo(
                    onTap: () {
                      context.go('/');
                    },
                  ),
                  Row(
                    children: [
                      if (user != null)
                        Text(
                          DateFormat("dd 'de' MMMM yyyy", 'es')
                              .format(DateTime.now()),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      if (user != null)
                        IconButton(
                          icon: const Icon(Icons.notifications),
                          onPressed: () {
                            showMenu(
                              context: context,
                              position:
                                  const RelativeRect.fromLTRB(100, 60, 0, 0),
                              items: [
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: const Icon(
                                        Icons.notification_important),
                                    title: const Text('Notificación 1'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: const Icon(
                                        Icons.notification_important),
                                    title: const Text('Notificación 2'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: const Icon(
                                        Icons.notification_important),
                                    title: const Text('Notificación 3'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.person),
                        offset: const Offset(0, 50),
                        onSelected: (String result) async {
                          final ctx = context;
                          if (result == 'signin') {
                            ctx.go('/signin');
                          } else if (result == 'signup') {
                            ctx.go('/signup');
                          } else if (result == 'profile') {
                            ctx.go('/profile');
                          } else if (result == 'signout') {
                            await FirebaseAuth.instance.signOut();
                            if (!ctx.mounted) return;
                            ctx.go('/signin');
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          if (user != null) {
                            return <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'profile',
                                child: Text('Perfil'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'signout',
                                child: Text('Cerrar sesión'),
                              ),
                            ];
                          } else {
                            return <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'signin',
                                child: Text('Iniciar sesión'),
                              ),
                            ];
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          drawer: user != null
              ? Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerHeader(
                        child: Text('Menu'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.dashboard,
                          color: GoRouter.of(context)
                                      .routerDelegate
                                      .currentConfiguration
                                      .fullPath ==
                                  '/dashboard'
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          'Inicio',
                          style: TextStyle(
                            color: GoRouter.of(context)
                                        .routerDelegate
                                        .currentConfiguration
                                        .fullPath ==
                                    '/dashboard'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: GoRouter.of(context)
                                .routerDelegate
                                .currentConfiguration
                                .fullPath ==
                            '/dashboard',
                        selectedTileColor: Colors.blue,
                        onTap: () {
                          context.go('/dashboard');
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.attach_money,
                          color: GoRouter.of(context)
                                      .routerDelegate
                                      .currentConfiguration
                                      .fullPath ==
                                  '/sales'
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          'Ordenes',
                          style: TextStyle(
                            color: GoRouter.of(context)
                                        .routerDelegate
                                        .currentConfiguration
                                        .fullPath ==
                                    '/sales'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: GoRouter.of(context)
                                .routerDelegate
                                .currentConfiguration
                                .fullPath ==
                            '/sales',
                        selectedTileColor: Colors.blue,
                        onTap: () {
                          context.go('/sales');
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.receipt,
                          color: GoRouter.of(context)
                                      .routerDelegate
                                      .currentConfiguration
                                      .fullPath ==
                                  '/services'
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          'Servicios',
                          style: TextStyle(
                            color: GoRouter.of(context)
                                        .routerDelegate
                                        .currentConfiguration
                                        .fullPath ==
                                    '/services'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: GoRouter.of(context)
                                .routerDelegate
                                .currentConfiguration
                                .fullPath ==
                            '/services',
                        selectedTileColor: Colors.blue,
                        onTap: () {
                          context.go('/services');
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: GoRouter.of(context)
                                      .routerDelegate
                                      .currentConfiguration
                                      .fullPath ==
                                  '/customers'
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          'Clientes',
                          style: TextStyle(
                            color: GoRouter.of(context)
                                        .routerDelegate
                                        .currentConfiguration
                                        .fullPath ==
                                    '/customers'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: GoRouter.of(context)
                                .routerDelegate
                                .currentConfiguration
                                .fullPath ==
                            '/customers',
                        selectedTileColor: Colors.blue,
                        onTap: () {
                          context.go('/customers');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.trending_up),
                        title: Text(
                          'Finanzas',
                          style: TextStyle(
                            color: GoRouter.of(context)
                                        .routerDelegate
                                        .currentConfiguration
                                        .fullPath ==
                                    '/finanzas'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: GoRouter.of(context)
                                .routerDelegate
                                .currentConfiguration
                                .fullPath ==
                            '/finanzas',
                        selectedTileColor: Colors.grey.shade200,
                        onTap: () {
                          context.go('/finanzas');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.group),
                        title: Text(
                          'Empleados',
                          style: TextStyle(
                            color: GoRouter.of(context)
                                        .routerDelegate
                                        .currentConfiguration
                                        .fullPath ==
                                    '/empleados'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: GoRouter.of(context)
                                .routerDelegate
                                .currentConfiguration
                                .fullPath ==
                            '/empleados',
                        selectedTileColor: Colors.grey.shade200,
                        onTap: () {
                          context.go('/empleados');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: Text(
                          'Configuración',
                          style: TextStyle(
                            color: GoRouter.of(context)
                                        .routerDelegate
                                        .currentConfiguration
                                        .fullPath ==
                                    '/configuracion'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: GoRouter.of(context)
                                .routerDelegate
                                .currentConfiguration
                                .fullPath ==
                            '/configuracion',
                        selectedTileColor: Colors.grey.shade200,
                        onTap: () {
                          context.go('/configuracion');
                        },
                      ),
                    ],
                  ),
                )
              : null,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      child,
                      const Footer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AuthWrapper(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const Home(),
        ),
        GoRoute(
          path: '/signin',
          builder: (context, state) => const SignIn(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignUp(),
        ),
        GoRoute(
          path: '/reset-password',
          builder: (context, state) => const ResetPassword(),
        ),
        GoRoute(
          path: '/change-password',
          builder: (context, state) {
            final oobCode = state.uri.queryParameters['oobCode'];
            if (oobCode == null) {
              return const Center(
                child: Text('Código de recuperación no válido.'),
              );
            }
            return ChangePassword(oobCode: oobCode);
          },
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const About(),
        ),
        GoRoute(
          path: '/terms',
          builder: (context, state) => const Terms(),
        ),
        GoRoute(
          path: '/contact',
          builder: (context, state) => const Contact(),
        ),
        GoRoute(
          path: '/politics',
          builder: (context, state) => const Politics(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const Profile(),
          redirect: (context, state) => _requireAuth(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const Dashboard(),
          redirect: (context, state) => _requireAuth(),
        ),
        GoRoute(
          path: '/sales',
          builder: (context, state) => const Sales(),
          redirect: (context, state) => _requireAuth(),
        ),
        GoRoute(
          path: '/create-sales',
          builder: (context, state) => const CreateSales(),
          redirect: (context, state) => _requireAuth(),
        ),
        GoRoute(
          path: '/services',
          builder: (context, state) => const Service(),
          redirect: (context, state) => _requireAuth(),
        ),
        GoRoute(
          path: '/create-service',
          builder: (context, state) => const CreateService(),
          redirect: (context, state) => _requireAuth(),
        ),
        GoRoute(
          path: '/edit-service/:serviceId',
          name: 'edit-service',
          builder: (context, state) {
            final serviceId = state.pathParameters['serviceId']!;
            return EditService(serviceId: serviceId);
          },
          redirect: (context, state) => _requireAuth(),
        ),
        GoRoute(
          path: '/customers',
          builder: (context, state) => const Customers(),
          redirect: (context, state) => _requireAuth(),
        ),
        GoRoute(
          path: '/create-customer',
          builder: (context, state) => const CreateCustomer(),
          redirect: (context, state) => _requireAuth(),
        ),
        GoRoute(
          path: '/detail-customer/:customerId',
          builder: (context, state) =>
              DetailCustomer(id: state.pathParameters['customerId']!),
          redirect: (context, state) => _requireAuth(),
        ),
      ],
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  ),
);

String? _requireAuth() {
  final user = FirebaseAuth.instance.currentUser;
  return user == null ? '/signin' : null;
}
