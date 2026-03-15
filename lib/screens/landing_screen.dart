import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'login_screen.dart';    // Asegúrate de tener estos archivos creados
import 'register_screen.dart'; // en tu carpeta lib/screens/

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    // Definición de colores del diseño original
    const kPrimaryIndigo = Color(0xFF4F46E5);
    const kSlate500 = Color(0xFF64748B);
    const kSlate900 = Color(0xFF0F172A);
    const kSlate100 = Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            children: [
              // 1. SECCIÓN SUPERIOR: LOGO Y TEXTO (Centrado)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO: w-40 h-40, bg-indigo-600, rounded-[3rem]
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: kPrimaryIndigo,
                        borderRadius: BorderRadius.circular(48), // 3rem
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryIndigo.withAlpha(64),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          )
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.activity,
                          color: Colors.white,
                          size: 80, // w-20 h-20 aproximado
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // TÍTULO: Mobility GYM (font-black, text-4xl)
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: kSlate900,
                          letterSpacing: -1,
                        ),
                        children: const [
                          TextSpan(text: "Mobility "),
                          TextSpan(
                            text: "GYM",
                            style: TextStyle(color: kPrimaryIndigo),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // SUBTÍTULO (text-slate-500, max-w-[280px])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Tu compañero integral para alcanzar tus objetivos físicos.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          color: kSlate500,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. SECCIÓN INFERIOR: BOTONES (rounded-[2rem])
              Column(
                children: [
                  
                  // BOTÓN: Empezar Ahora (Indigo)
                  SizedBox(
                    width: double.infinity,
                    height: 68,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryIndigo,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: kPrimaryIndigo.withAlpha(51),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32), // 2rem
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Empezar Ahora",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(LucideIcons.chevronRight, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // BOTÓN: Crear cuenta (Border-2)
                  SizedBox(
                    width: double.infinity,
                    height: 68,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFEEF2FF), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32), // 2rem
                        ),
                      ),
                      child: Text(
                        "Crear cuenta",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: kPrimaryIndigo,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // INDICADOR INFERIOR: w-1.5 h-8 bg-slate-100
                  Container(
                    width: 6,
                    height: 32,
                    decoration: BoxDecoration(
                      color: kSlate100,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}