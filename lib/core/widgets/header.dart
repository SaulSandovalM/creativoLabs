import 'package:creativolabs/core/constants/colors.dart';
import 'package:creativolabs/core/widgets/site_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Material(
      child: Container(
        color: CustomColor.navBarBg,
        child: SizedBox(
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
    );
  }
}
