import 'package:creativolabs/core/constants/colors.dart';
import 'package:creativolabs/core/widgets/footer.dart';
import 'package:creativolabs/core/widgets/header.dart';
import 'package:creativolabs/screens/about/view/about.dart';
import 'package:creativolabs/screens/authwrapper/view/authwrapper.dart';
import 'package:creativolabs/screens/contact/view/contact.dart';
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
        return Scaffold(
          backgroundColor: CustomColor.navBarBg,
          body: Column(
            children: [
              const Header(),
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
