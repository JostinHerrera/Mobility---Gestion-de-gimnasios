import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const kPrimaryIndigo = Color(0xFF4F46E5);
    const kSlate900 = Color(0xFF0F172A);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Mobility GYM',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: kSlate900,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Mi Perfil',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: kSlate900,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Alex Johnson', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                    Text('Miembro Premium', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Nivel'),
            const Text('Intermedio'),
            const SizedBox(height: 16),
            _buildSectionTitle('Racha'),
            const Text('12 Días'),
            const SizedBox(height: 16),
            _buildSectionTitle('Perfil Público'),
            const Text('Visibilidad de rutinas'),
            const SizedBox(height: 24),
            _buildSectionTitle('Datos Físicos', hasAction: true),
            const _KeyValueRow(label: 'Peso', value: '75 kg'),
            const _KeyValueRow(label: 'Altura', value: '178 cm'),
            const _KeyValueRow(label: 'Edad', value: '28 años'),
            const _KeyValueRow(label: 'Objetivo', value: 'Ganancia muscular'),
            const SizedBox(height: 24),
            _buildSectionTitle('Métodos de Pago', hasAction: true),
            const Text('Gestiona tus tarjetas'),
            const SizedBox(height: 24),
            _buildSectionTitle('Notificaciones', hasAction: true),
            const Text('Configura tus avisos'),
            const SizedBox(height: 24),
            _buildSectionTitle('Seguridad', hasAction: true),
            const Text('Contraseña y acceso'),
            const SizedBox(height: 24),
            _buildSectionTitle('Soporte', hasAction: false),
            const Text('Centro de ayuda'),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryIndigo,
                ),
                child: const Text('Upgrade a PRO'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('Ver Planes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text, {bool hasAction = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (hasAction)
          TextButton(
            onPressed: () {},
            child: const Text('Editar'),
          ),
      ],
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  const _KeyValueRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }
}
