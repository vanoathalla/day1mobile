import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import halaman utama lu
import 'pages/marketplace_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await Supabase.initialize(
    url: 'https://jnampojrlqzvfbsfvuuw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpuYW1wb2pybHF6dmZic2Z2dXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE2ODc5NTIsImV4cCI6MjA4NzI2Mzk1Mn0.kG0k64ixoNPFvaCXzQPN7hiiuJGu6-QrRsdPb-FRWpU',
  );

  runApp(const JokulHapeApp());
}

class JokulHapeApp extends StatelessWidget {
  const JokulHapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jokul Gadget',
      theme: ThemeData(
        useMaterial3: true,
        // Tema Kalcer: Gelap, Kontras Tinggi, Aksen Neon
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF5400), // Electric Orange
          surface: Color(0xFF141414), // Card background
        ),
        // Font Inter nempel di semua teks
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A0A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const MarketplacePage(),
    );
  }
}
