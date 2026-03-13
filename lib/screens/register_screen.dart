import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    const kPrimaryIndigo = Color(0xFF4F46E5);
    const kSlate900 = Color(0xFF0F172A);
    const kSlate500 = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: kSlate900),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Crea tu cuenta",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: kSlate900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Únete a la comunidad de Mobility GYM hoy mismo.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: kSlate500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),

            // Campos de entrada
            _buildInputField(
              controller: _nameController,
              label: "Nombre completo",
              hint: "Juan Pérez",
              icon: LucideIcons.user,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _emailController,
              label: "Correo electrónico",
              hint: "ejemplo@correo.com",
              icon: LucideIcons.mail,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _passwordController,
              label: "Contraseña",
              hint: "••••••••",
              icon: LucideIcons.lock,
              isPassword: true,
              obscureText: _obscurePassword,
              toggleObscure: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            
            const SizedBox(height: 40),

            // Botón de Registro
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica de registro
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryIndigo,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  "Registrarse",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- LO QUE PEDISTE: ENLACE A LOGIN ---
            Center(
              child: GestureDetector(
                onTap: () {
                  // Navegar a la pantalla de Login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      color: kSlate500,
                      fontWeight: FontWeight.w500,
                    ),
                    children: const [
                      TextSpan(text: "¿Ya tienes cuenta? "),
                      TextSpan(
                        text: "Inicia Sesión",
                        style: TextStyle(
                          color: kPrimaryIndigo,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para los inputs (reutilizable)
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: isPassword ? obscureText : false,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: const Color(0xFF4F46E5)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                        obscureText ? LucideIcons.eyeOff : LucideIcons.eye,
                        color: const Color(0xFF4F46E5)),
                    onPressed: toggleObscure,
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFF1F5F9), width: 1),
            ),
          ),
        ),      ],
    );
  }
}