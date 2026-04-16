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
      backgroundColor: const Color(0xFFF3F4FF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                        child: SizedBox(
                          height: 170,
                          width: double.infinity,
                          child: Image.network(
                            widget.trainer.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: primary,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.person,
                                    size: 52,
                                    color: Colors.white,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        top: 16,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star,
                            color: primary,
                            size: 20,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -42,
                        left: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 42,
                            backgroundColor: const Color(0xFFF3F4FF),
                            child: ClipOval(
                              child: Image.network(
                                widget.trainer.imageUrl,
                                width: 76,
                                height: 76,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.person,
                                      size: 46,
                                      color: primary,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 54),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.trainer.name,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.trainer.title,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _starRow(widget.trainer.rating),
                            const SizedBox(width: 10),
                            Text(
                              '${widget.trainer.rating} · ${widget.trainer.years} años',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: const Text('Seguir'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _showContactDialog(context),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(
                                    color: primary.withOpacity(0.2),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: const Text('Mensaje'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Información',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _profileInfoTile(
                    label: 'Certificacion',
                    value: '${widget.trainer.certifications}',
                    color: primary,
                  ),
                  _profileInfoTile(
                    label: 'Clientes',
                    value: widget.trainer.clients,
                    color: Colors.teal,
                  ),
                  _profileInfoTile(
                    label: 'Idiomas',
                    value: widget.trainer.languages,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sobre el entrenador',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.trainer.about,
                      style: textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _detailRow(
                      icon: Icons.verified,
                      label: 'Certificaciones',
                      value: '${widget.trainer.certifications} títulos',
                    ),
                    const SizedBox(height: 12),
                    _detailRow(
                      icon: Icons.people,
                      label: 'Clientes',
                      value: widget.trainer.clients,
                    ),
                    const SizedBox(height: 12),
                    _detailRow(
                      icon: Icons.language,
                      label: 'Idiomas',
                      value: widget.trainer.languages,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Historias y programas',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  _programCard(
                    'Fuerza 12 semanas',
                    'Programa progresivo para ganar fuerza y masa muscular.',
                    () => Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 320),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            FadeTransition(
                              opacity: animation,
                              child: const RoutinesScreen(
                                initialCategory: 'Fuerza',
                              ),
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
                  const SizedBox(width: 12),
                  _programCard(
                    'Acondicionamiento HIIT',
                    'Mejora cardiovascular y potencia en 8 semanas.',
                    () => Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 320),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            FadeTransition(
                              opacity: animation,
                              child: const RoutinesScreen(
                                initialCategory: 'Cardio',
                              ),
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
                ],
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Reseñas',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _reviewCard(
                    'María',
                    'Excelente entrenador, noté mejoras en 3 meses.',
                    5,
                  ),
                  const SizedBox(height: 12),
                  _reviewCard(
                    'Juan',
                    'Muy profesional y atento a la técnica.',
                    5,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

Widget _starRow(double value) {
  final stars = List<Widget>.generate(5, (index) {
    final threshold = index + 1;
    if (value >= threshold) {
      return const Icon(Icons.star, color: Color(0xFFFFD54F), size: 16);
    }
    if (value > index && value < threshold) {
      return const Icon(Icons.star_half, color: Color(0xFFFFD54F), size: 16);
    }
    return const Icon(Icons.star_border, color: Color(0xFFFFD54F), size: 16);
  });

  return Row(children: stars);
}

Widget _profileInfoTile({
  required String label,
  required String value,
  required Color color,
}) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _detailRow({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF4F46E5), size: 18),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _programCard(String title, String subtitle, VoidCallback onPressed) {
  return Container(
    width: 260,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            onPressed: onPressed,
            child: const Text('Ver programa'),
          ),
        ),
      ],
    ),
  );
}

Widget _reviewCard(String name, String comment, int rating) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFEEF2FF),
              child: Text(
                name.substring(0, 1),
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF4F46E5),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                _starRow(rating.toDouble()),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          comment,
          style: GoogleFonts.plusJakartaSans(color: Colors.grey[800]),
        ),
      ],
    ),
  );
}
