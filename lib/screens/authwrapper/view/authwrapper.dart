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
  bool _loadingBusiness = false;
  bool _businessLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = FirebaseAuth.instance.currentUser;
    final businessModel = Provider.of<BusinessModel>(context, listen: false);

    if (user != null && !_businessLoaded && !_loadingBusiness) {
      _loadingBusiness = true;

      businessModel.fetchBusinessId().then((_) {
        if (mounted) {
          setState(() {
            _businessLoaded = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Esperando estado de autenticación
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Usuario autenticado
        if (snapshot.hasData) {
          // Esperando cargar el businessId
          if (!_businessLoaded) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // businessId ya cargado
          return const Dashboard();
        }

        // Usuario no autenticado
        return const Home();
      },
    );
  }
}
