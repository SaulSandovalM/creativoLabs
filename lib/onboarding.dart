import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          return Row(
            children: [
              if (isWide)
                Expanded(
                  child: Container(
                    color: Colors.black87,
                    child: Center(
                      child: Image.asset(
                        'assets/images/onboardLogo.png',
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: _controller,
                          onPageChanged: (index) {
                            setState(() => isLastPage = index == 2);
                          },
                          children: const [
                            OnboardingPage(
                              image: 'assets/images/onboard1.png',
                              title: 'Impulsa tu negocio',
                              description:
                                  'Bienvenido a CreativoLabs, la plataforma donde tus servicios cobran vida. Conecta con más clientes, gestiona tu trabajo y haz crecer tu negocio.',
                            ),
                            OnboardingPage(
                              image: 'assets/images/onboard2.png',
                              title: 'Organiza y administra',
                              description:
                                  'Controla tus ventas, servicios y clientes desde un panel intuitivo. Toda la información de tu negocio, en un solo lugar.',
                            ),
                            OnboardingPage(
                              image: 'assets/images/onboard3.png',
                              title: 'Llega más lejos',
                              description:
                                  'Publica tus servicios, recibe solicitudes y mantente conectado. Nuestra plataforma te ayuda a llegar justo donde tus clientes te necesitan.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                        effect: const WormEffect(
                          dotColor: Colors.grey,
                          activeDotColor: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => _controller.jumpToPage(2),
                            child: const Text('SALTAR'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (isLastPage) {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('onboarding_seen', true);
                                if (context.mounted) {
                                  context.go('/');
                                }
                              } else {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: Text(isLastPage ? 'COMENZAR' : 'SIGUIENTE'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image, title, description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isWide
          ? Row(
              children: [
                Expanded(child: Image.asset(image)),
                const SizedBox(width: 40),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 16),
                      Text(description,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(image, height: 250),
                const SizedBox(height: 24),
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                Text(description,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center),
              ],
            ),
    );
  }
}
