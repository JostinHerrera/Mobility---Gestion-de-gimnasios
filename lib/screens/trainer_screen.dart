import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_models.dart';
import 'chat_screen.dart';
import 'routines_screen.dart';

// Clase que representa los datos de un entrenador
class Trainer {
  final String name;
  final String title;
  final double rating;
  final int years;
  final int certifications;
  final String clients;
  final String languages;
  final String about;
  final String imageUrl; // URL de la imagen de perfil

  const Trainer({
    required this.name,
    required this.title,
    required this.rating,
    required this.years,
    required this.certifications,
    required this.clients,
    required this.languages,
    required this.about,
    required this.imageUrl,
  });
}

// Pantalla que muestra los detalles de un entrenador
class TrainerScreen extends StatefulWidget {
  final Trainer trainer;
  const TrainerScreen({required this.trainer, super.key});

  @override
  State<TrainerScreen> createState() => _TrainerScreenState();
}

class _TrainerScreenState extends State<TrainerScreen> {
  // Función que muestra el diálogo de contacto con opciones para llamar o enviar mensaje
  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Contactar al Entrenador'),
        content: const Text('¿Cómo deseas contactar al entrenador?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Llamando al entrenador...')),
              );
            },
            child: const Text('Llamar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Crear un chat simulado para el entrenador
              final mockChat = Chat(
                name: widget.trainer.name,
                avatarUrl:
                    widget.trainer.imageUrl, // Usar la imagen del entrenador
                lastMessage: 'Hola, ¿en qué puedo ayudarte?',
                lastMessageTime: DateTime.now(),
                messages: [
                  Message(
                    text:
                        'Hola, soy ${widget.trainer.name}. ¿En qué puedo ayudarte?',
                    isMine: false,
                    time: DateTime.now().subtract(const Duration(minutes: 5)),
                  ),
                ],
                isOnline: true,
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatScreen(chat: mockChat)),
              );
            },
            child: const Text('Enviar Mensaje'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4F46E5);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      Theme.of(context).textTheme,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
        title: Text(
          widget.trainer.name,
          style: textTheme.titleLarge?.copyWith(
            color: const Color(0xFF0F172A),
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF8FAFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con información básica del entrenador
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        widget.trainer.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.person, size: 46, color: primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trainer.name,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.trainer.title,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _starRow(widget.trainer.rating),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.trainer.rating}',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '· ${widget.trainer.years} años experiencia',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Información rápida en chips
            Row(
              children: [
                _infoChip(
                  'Certificación',
                  '${widget.trainer.certifications}',
                  primary,
                ),
                const SizedBox(width: 8),
                _infoChip('Clientes', widget.trainer.clients, Colors.teal),
                const SizedBox(width: 8),
                _infoChip('Idiomas', widget.trainer.languages, Colors.orange),
              ],
            ),

            const SizedBox(height: 18),

            // Botón para reservar cita
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showContactDialog(context),
                icon: const Icon(Icons.calendar_today),
                label: const Text('Reservar'),
              ),
            ),

            const SizedBox(height: 18),

            // Sección sobre el entrenador
            Text(
              'Sobre el entrenador',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(widget.trainer.about, style: textTheme.bodyMedium),
            ),

            const SizedBox(height: 18),

            // Programas destacados
            Text(
              'Programas destacados',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            _programCard(
              'Fuerza 12 semanas',
              'Programa progresivo para ganar fuerza y masa muscular.',
              () => Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 320),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      FadeTransition(
                        opacity: animation,
                        child: const RoutinesScreen(initialCategory: 'Fuerza'),
                      ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        final curved = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                        );
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(curved),
                          child: child,
                        );
                      },
                ),
              ),
            ),
            _programCard(
              'Acondicionamiento HIIT',
              'Mejora cardiovascular y potencia en 8 semanas.',
              () => Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 320),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      FadeTransition(
                        opacity: animation,
                        child: const RoutinesScreen(initialCategory: 'Cardio'),
                      ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        final curved = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                        );
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(curved),
                          child: child,
                        );
                      },
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Reseñas (placeholder)
            Text(
              'Reseñas',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('María: Excelente entrenador, noté mejoras en 3 meses.'),
                  SizedBox(height: 8),
                  Text('Juan: Muy profesional y atento a la técnica.'),
                ],
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

// Función que crea una fila de estrellas (hardcoded a 5 estrellas completas)
Widget _starRow(double value) {
  return Row(
    children: const [
      Icon(Icons.star, color: Color(0xFFFFD54F), size: 16),
      Icon(Icons.star, color: Color(0xFFFFD54F), size: 16),
      Icon(Icons.star, color: Color(0xFFFFD54F), size: 16),
      Icon(Icons.star, color: Color(0xFFFFD54F), size: 16),
      Icon(Icons.star_half, color: Color(0xFFFFD54F), size: 16),
    ],
  );
}

// Widget que crea un chip de información con icono, etiqueta y valor
Widget _infoChip(String label, String value, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withAlpha(31),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.check, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ],
    ),
  );
}

// Widget que crea una tarjeta para un programa con título, subtítulo y botón
Widget _programCard(String title, String subtitle, VoidCallback onPressed) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: onPressed, child: const Text('Ver programa')),
          ],
        ),
      ],
    ),
  );
}
