import 'package:creativolabs/core/constants/colors.dart';
import 'package:creativolabs/core/widgets/site_logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
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
                onSelected: (String result) {
                  if (result == 'signin') {
                    context.go('/signin');
                  } else if (result == 'signup') {
                    context.go('/signup');
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'signin',
                    child: Text('Iniciar sesión'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'signup',
                    child: Text('Registrarse'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
