import 'package:flutter/material.dart';
import 'package:kcgc_app/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    routeSplash();
  }

  Future<void> routeSplash() async {
    await Future.delayed(const Duration(seconds: 3)).then(
      (value) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (value) => const Home()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icon.jpg",
              width: 140,
            ),
            const SizedBox(
              height: 200,
            ),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
