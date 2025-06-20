import 'package:creativolabs/providers/business_model.dart';
import 'package:creativolabs/screens/dashboard/view/dashboard.dart';
import 'package:creativolabs/screens/home/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _initCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = FirebaseAuth.instance.currentUser;
    final businessModel = Provider.of<BusinessModel>(context, listen: false);
    if (!_initCalled && user != null && businessModel.businessId == null) {
      _initCalled = true;
      businessModel.fetchBusinessId();
    }
  }

  @override
  Widget build(BuildContext context) {
    final businessModel = context.watch<BusinessModel>();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          if (businessModel.isLoading || businessModel.businessId == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return const Dashboard();
        }
        return const Home();
      },
    );
  }
}
