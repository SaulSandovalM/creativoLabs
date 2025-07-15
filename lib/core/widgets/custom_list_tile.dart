import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomListTile extends StatelessWidget {
  final String route;
  final String text;
  final IconData? icon;

  const CustomListTile({
    super.key,
    required this.route,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
                    route
                ? Colors.white
                : Colors.black,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: GoRouter.of(context)
                      .routerDelegate
                      .currentConfiguration
                      .fullPath ==
                  route
              ? Colors.white
              : Colors.black,
        ),
      ),
      selected: GoRouterState.of(context).uri.path == route,
      selectedTileColor: Colors.blue,
      onTap: () => context.go(route),
    );
  }
}
