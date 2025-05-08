import 'dart:ui';
import 'package:flutter/material.dart';
import 'main_screen.dart';

class GoogleProcessingScreen extends StatefulWidget {
  const GoogleProcessingScreen({super.key});

  @override
  State<GoogleProcessingScreen> createState() => _GoogleProcessingScreenState();
}

class _GoogleProcessingScreenState extends State<GoogleProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    });
  }

  Widget _glassBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            ),
            child: const Text(
              'Назад',
              style: TextStyle(color: Color(0xFF003366), fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/clouds_static.png', fit: BoxFit.cover),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Color(0xFF003366)),
                const SizedBox(height: 20),
                const Text(
                  'Обработка входа через Google...',
                  style: TextStyle(color: Color(0xFF003366), fontSize: 18),
                ),
                const SizedBox(height: 40),
                _glassBackButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
