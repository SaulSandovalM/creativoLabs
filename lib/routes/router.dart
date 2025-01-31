import 'package:creativolabs/core/constants/colors.dart';
import 'package:creativolabs/core/widgets/footer.dart';
import 'package:creativolabs/screens/home/view/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: CustomColor.navBarBg,
            title: Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Regístrate",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10), // Espaciado
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Color llamativo
                ),
                child: const Text("Iniciar sesión"),
              ),
              const SizedBox(width: 10),
            ],
            elevation: 4,
          ),
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
          builder: (context, state) => const Home(),
        ),
      ],
    ),
  ],
);
