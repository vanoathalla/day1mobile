import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'marketplace_page.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/98c2df5d-16f5-48b8-b125-998823293e50/8DOnpI1VwV.json',
              width: 250,
              height: 250,
              repeat: false,
            ),
            const SizedBox(height: 24),
            const Text('PAYMENT SUCCESS',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3)),
            const SizedBox(height: 60),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5400),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MarketplacePage()),
                  (route) => false),
              child: const Text('BALIK NONGKRONG',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
