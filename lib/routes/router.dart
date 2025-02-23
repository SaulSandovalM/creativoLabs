import 'package:creativolabs/core/constants/colors.dart';
import 'package:creativolabs/core/widgets/footer.dart';
import 'package:creativolabs/core/widgets/site_logo.dart';
import 'package:creativolabs/screens/about/view/about.dart';
import 'package:creativolabs/screens/authwrapper/view/authwrapper.dart';
import 'package:creativolabs/screens/contact/view/contact.dart';
import 'package:creativolabs/screens/dashboard/view/dashboard.dart';
import 'package:creativolabs/screens/home/view/home.dart';
import 'package:creativolabs/screens/politics/view/politics.dart';
import 'package:creativolabs/screens/profile/view/profile.dart';
import 'package:creativolabs/screens/signin/view/signin.dart';
import 'package:creativolabs/screens/signup/view/signup.dart';
import 'package:creativolabs/screens/terms/view/terms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isAuthPage =
        state.uri.toString() == '/signin' || state.uri.toString() == '/signup';
    if (user == null && !isAuthPage) {
      return '/signin';
    }
    if (user != null && isAuthPage) {
      return '/profile';
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
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.person),
                    offset: const Offset(0, 50),
                    onSelected: (String result) async {
                      final ctx = context;
                      if (result == 'signin') {
                        ctx.go('/signin');
                      } else if (result == 'signup') {
                        ctx.go('/signup');
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
                          const PopupMenuItem<String>(
                            value: 'signup',
                            child: Text('Registrarse'),
                          ),
                        ];
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          drawer:
              user != null // Solo mostrar el Drawer si el usuario está logueado
                  ? Drawer(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          const DrawerHeader(
                            child: Text('Menu'),
                          ),
                          ListTile(
                            title: const Text('Profile'),
                            onTap: () {
                              context.go('/profile');
                            },
                          ),
                          ListTile(
                            title: const Text('Dashboard'),
                            onTap: () {
                              context.go('/dashboard');
                            },
                          ),
                          // Otras opciones del Drawer
                        ],
                      ),
                    )
                  : null, // Si no está logueado, no mostrar el Drawer
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
