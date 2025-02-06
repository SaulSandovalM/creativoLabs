import 'package:creativolabs/core/constants/colors.dart';
import 'package:creativolabs/core/widgets/footer.dart';
import 'package:creativolabs/core/widgets/header.dart';
import 'package:creativolabs/screens/about/view/about.dart';
import 'package:creativolabs/screens/home/view/home.dart';
import 'package:creativolabs/screens/signin/view/signin.dart';
import 'package:creativolabs/screens/signup/view/signup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
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
      ],
    ),
  ],
);
