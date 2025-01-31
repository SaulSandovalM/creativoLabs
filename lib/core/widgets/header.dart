import 'package:creativolabs/core/constants/nav_items.dart';
import 'package:creativolabs/core/widgets/site_logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: 60,
        width: double.maxFinite,
        child: Row(children: [
          SiteLogo(
            onTap: () {},
          ),
          const Spacer(),
          for (int i = 0; i < navTitles.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: TextButton(
                onPressed: () => context.go(navRoutes[i]),
                child: Text(
                  navTitles[i],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            )
        ]),
      ),
    );
  }
}
