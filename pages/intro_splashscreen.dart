import 'package:flutter/material.dart';
import 'package:flutter_okr/app_shell.dart';

class IntroSplashScreen extends StatefulWidget {
  const IntroSplashScreen({super.key});

  @override
  State<IntroSplashScreen> createState() => _IntroSplashScreenState();
}

class _IntroSplashScreenState extends State<IntroSplashScreen> {
  double _opacity = 1.0;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _opacity = 0);
    });
  }

  void _goHome() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 500),
        onEnd: () {
          if (_opacity == 0) _goHome();
        },
        child: const Center(
          child: Text(
            'OKRIKA!',
            style: TextStyle(fontSize: 28, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
