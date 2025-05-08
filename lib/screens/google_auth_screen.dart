import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:life_plane_go/services/storage_service.dart';
import 'google_processing_screen.dart';

class GoogleAuthScreen extends StatelessWidget {
  const GoogleAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accounts = ['user1@gmail.com', 'user2@gmail.com', 'another.account@gmail.com'];
    final screenWidth = MediaQuery.of(context).size.width;

    Widget _glassAccountButton(String email) {
      return GestureDetector(
        onTap: () async {
          final storage = StorageService();
          await storage.setIsLoggedIn(true);
          await storage.setUserEmail(email);

          Navigator.push(context, MaterialPageRoute(builder: (_) => const GoogleProcessingScreen()));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: screenWidth * 0.75,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
              ),
              child: Row(
                children: [
                  Image.asset('assets/icons/google_icon.png', width: 24, height: 24),
                  const SizedBox(width: 10),
                  Expanded(child: Text(email, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/clouds_static.png', fit: BoxFit.cover),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Выберите аккаунт Google',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ...accounts.map((email) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _glassAccountButton(email),
                  )),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Назад', style: TextStyle(color: Color(0xFF003366))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
