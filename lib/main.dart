import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/landing_screen.dart'; // <--- IMPORTANTE: Importa la Landing

void main() {
  runApp(const MobilityGymApp());
}

class MobilityGymApp extends StatelessWidget {
  const MobilityGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobility Gym',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          primary: const Color(0xFF4F46E5),
        ),
      ),
      // CAMBIO AQUÍ: Empezamos en LandingScreen
      home: const LandingScreen(),
    );
  }
}
