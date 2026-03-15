import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Trainer {
  final String name;
  final String title;
  final double rating;
  final int years;
  final int certifications;
  final String clients;
  final String languages;
  final String about;

  const Trainer({required this.name, required this.title, required this.rating, required this.years, required this.certifications, required this.clients, required this.languages, required this.about});
}

class TrainerScreen extends StatelessWidget {
  final Trainer trainer;
  const TrainerScreen({required this.trainer, super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4F46E5);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(Theme.of(context).textTheme);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
        title: Text(trainer.name, style: textTheme.titleLarge?.copyWith(color: const Color(0xFF0F172A), fontWeight: FontWeight.w900)),
      ),
      backgroundColor: const Color(0xFFF8FAFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 12, offset: const Offset(0,6))]),
              child: Row(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(color: const Color(0xFFF3F4FF), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.person, size: 46, color: primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trainer.name, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 6),
                        Text(trainer.title, style: textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _starRow(trainer.rating),
                            const SizedBox(width: 8),
                            Text('${trainer.rating}', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(width: 8),
                            Text('· ${trainer.years} años experiencia', style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Quick info
            Row(
              children: [
                _infoChip('Certificaciones', '${trainer.certifications}', primary),
                const SizedBox(width: 8),
                _infoChip('Clientes', trainer.clients, Colors.teal),
                const SizedBox(width: 8),
                _infoChip('Idiomas', trainer.languages, Colors.orange),
              ],
            ),

            const SizedBox(height: 18),

            // Contact actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Mensaje'),
                    style: ElevatedButton.styleFrom(backgroundColor: primary),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Reservar'),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // About
            Text('Sobre el entrenador', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Text(trainer.about, style: textTheme.bodyMedium),
            ),

            const SizedBox(height: 18),

            // Programs
            Text('Programas destacados', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            _programCard('Fuerza 12 semanas', 'Programa progresivo para ganar fuerza y masa muscular.'),
            _programCard('Acondicionamiento HIIT', 'Mejora cardiovascular y potencia en 8 semanas.'),

            const SizedBox(height: 18),

            // Schedule / Reviews placeholders
            Text('Reseñas', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('María: Excelente entrenador, noté mejoras en 3 meses.'),
                SizedBox(height: 8),
                Text('Juan: Muy profesional y atento a la técnica.'),
              ]),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

Widget _starRow(double value) {
  return Row(children: const [Icon(Icons.star, color: Color(0xFFFFD54F), size: 16), Icon(Icons.star, color: Color(0xFFFFD54F), size: 16), Icon(Icons.star, color: Color(0xFFFFD54F), size: 16), Icon(Icons.star, color: Color(0xFFFFD54F), size: 16), Icon(Icons.star_half, color: Color(0xFFFFD54F), size: 16)]);
}

Widget _infoChip(String label, String value, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withAlpha(31), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.check, color: color, size: 16)),
      const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey)), Text(value, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800))])
    ]),
  );
}

Widget _programCard(String title, String subtitle) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      Text(subtitle, style: GoogleFonts.plusJakartaSans(color: Colors.grey[700])),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [TextButton(onPressed: () {}, child: const Text('Ver programa'))])
    ]),
  );
}
