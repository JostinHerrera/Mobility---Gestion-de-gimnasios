import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'map_screen.dart';
import 'login_screen.dart';
import 'trainers_list_screen.dart';
import 'trainer_screen.dart';
import 'gym_profile_screen.dart';
import '../widgets/gym_card.dart';

// Pantalla principal del dashboard con lista de gimnasios
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  // Estado para filtros de categorías
  String _activeFilter = "Todos";
  final List<String> _categories = [
    "Todos",
    "Gimnasio",
    "Box",
    "Yoga",
    "Estudio",
  ];

  late AnimationController _logoPulseController;
  late Animation<double> _logoPulseAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador para la animación de pulso del logo
    _logoPulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Animación de pulso sutil (de 1.0 a 1.05)
    _logoPulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _logoPulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _logoPulseController.dispose();
    super.dispose();
  }

  // Datos mock de gimnasios
  final List<Gym> _allGyms = [
    Gym(
      name: "Iron Temple Gym",
      type: "Gimnasio",
      address: "Calle Principal 123, Madrid",
      distance: "1.2 km",
      rating: 4.8,
      imageUrl: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48",
      description:
          "Centro completo con área de pesas libres, sala de cardio y clases funcionales en grupo.",
      price: "Desde €35/mes",
      schedule:
          "Lun - Vie: 06:00 - 22:00\nSáb: 08:00 - 20:00\nDom: 09:00 - 17:00",
      trainers: [
        const Trainer(
          name: 'Cristian López',
          title: 'Entrenador personal · Fuerza',
          rating: 4.9,
          years: 8,
          certifications: 4,
          clients: '120+',
          languages: 'ES, EN',
          about: 'Especialista en fuerza y acondicionamiento.',
          imageUrl:
              'https://okdiario.com/img/vida-sana/2015/01/Chris-Hemsworth.jpg',
        ),
        const Trainer(
          name: 'Lucía Márquez',
          title: 'Entrenadora funcional',
          rating: 4.7,
          years: 5,
          certifications: 3,
          clients: '90+',
          languages: 'ES',
          about: 'Clases energéticas para mejorar resistencia y movilidad.',
          imageUrl:
              'https://okdiario.com/img/vida-sana/2015/01/Paula-Butrague%C3%B1o.jpg',
        ),
      ],
    ),
    Gym(
      name: "CrossFit Alpha",
      type: "Box",
      address: "Avenida Central 45, Barcelona",
      distance: "2.5 km",
      rating: 4.9,
      imageUrl: "https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5",
      description:
          "Box de CrossFit con entrenamientos de alta intensidad y coaching personalizado.",
      price: "Desde €40/mes",
      schedule: "Lun - Vie: 06:30 - 21:30\nSáb: 08:00 - 18:00\nDom: Cerrado",
      trainers: [
        const Trainer(
          name: 'Ángel Silva',
          title: 'Coach CrossFit',
          rating: 4.9,
          years: 6,
          certifications: 5,
          clients: '110+',
          languages: 'ES, EN',
          about: 'Foco en fuerza, técnica y resultados rápidos.',
          imageUrl:
              'https://okdiario.com/img/vida-sana/2015/01/Henry-Cavill.jpg',
        ),
        const Trainer(
          name: 'Sara Núñez',
          title: 'Coach de movimientos olímpicos',
          rating: 4.8,
          years: 7,
          certifications: 4,
          clients: '100+',
          languages: 'ES',
          about: 'Especializada en levantamiento olímpico y movilidad.',
          imageUrl:
              'https://okdiario.com/img/vida-sana/2015/01/Paula-Butrague%C3%B1o.jpg',
        ),
      ],
    ),
    Gym(
      name: "Zen Yoga Studio",
      type: "Yoga",
      address: "Plaza del Sol 12, Valencia",
      distance: "0.8 km",
      rating: 4.7,
      imageUrl: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b",
      description:
          "Estudio tranquilo para clases de yoga, pilates y meditación guiada.",
      price: "Desde €30/mes",
      schedule:
          "Lun - Vie: 07:00 - 20:00\nSáb: 08:00 - 16:00\nDom: 09:00 - 14:00",
      trainers: [
        const Trainer(
          name: 'Marta Díaz',
          title: 'Instructora de yoga',
          rating: 4.8,
          years: 9,
          certifications: 5,
          clients: '140+',
          languages: 'ES',
          about: 'Clases suaves y avanzadas para cuerpo y mente.',
          imageUrl:
              'https://okdiario.com/img/vida-sana/2015/01/Paula-Butrague%C3%B1o.jpg',
        ),
        const Trainer(
          name: 'Daniel Rubio',
          title: 'Profesor de pilates',
          rating: 4.6,
          years: 5,
          certifications: 3,
          clients: '70+',
          languages: 'ES, EN',
          about: 'Centrada en la postura, movilidades y control corporal.',
          imageUrl:
              'https://okdiario.com/img/vida-sana/2015/01/Chris-Hemsworth.jpg',
        ),
      ],
    ),
  ];

  // Función para abrir el mapa con gimnasios filtrados
  void _openGoogleMaps() {
    // Obtener lista filtrada de gimnasios
    final filteredGyms = _activeFilter == "Todos"
        ? _allGyms
        : _allGyms.where((g) => g.type == _activeFilter).toList();

    // Navegar a la pantalla del mapa
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen(gyms: filteredGyms)),
    );
  }

  // Función para abrir el diálogo de notificaciones
  void _openNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const NotificationsViewDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Colores del tema
    const kPrimaryIndigo = Color(0xFF4F46E5);
    const kBackgroundSlate = Color(0xFFF8FAFC);

    // Filtrar la lista según la categoría seleccionada
    final filteredGyms = _activeFilter == "Todos"
        ? _allGyms
        : _allGyms.where((g) => g.type == _activeFilter).toList();

    return Scaffold(
      backgroundColor: kBackgroundSlate,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: notificaciones y botón de logout
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _openNotifications(context),
                    icon: const Icon(
                      Icons.notifications,
                      color: Color(0xFF4F46E5),
                    ),
                    tooltip: 'Notificaciones',
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Cerrar sesión'),
                          content: const Text(
                            '¿Estás seguro que deseas cerrar sesión?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Cerrar sesión'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.logout, color: Color(0xFF4F46E5)),
                    tooltip: 'Cerrar sesión',
                  ),
                ],
              ),
            ),
            // 1. HEADER Y BUSCADOR
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // logo encabezado centrado con animación sutil
                  Center(
                    child: AnimatedBuilder(
                      animation: _logoPulseController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoPulseAnimation.value,
                          child: Text(
                            "Mobility GYM",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Barra de búsqueda
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(8),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Buscar gimnasios...",
                        hintStyle: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          LucideIcons.search,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. BOTÓN PARA ABRIR MAPA y botón pequeño de Entrenadores al lado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _openGoogleMaps,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.map, color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Ver Mapa',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TrainersListScreen(),
                        ),
                      ),
                      icon: const Icon(
                        Icons.group,
                        size: 18,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      label: Text(
                        'Entrenadores',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w900,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. FILTROS HORIZONTALES
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final bool isActive = _activeFilter == category;
                  return GestureDetector(
                    onTap: () => setState(() => _activeFilter = category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isActive ? kPrimaryIndigo : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isActive
                              ? kPrimaryIndigo
                              : const Color(0xFFF1F5F9),
                        ),
                        boxShadow: [
                          if (isActive)
                            BoxShadow(
                              color: kPrimaryIndigo.withAlpha(51),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : const Color(0xFF64748B),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // 4. LISTA DE GIMNASIOS
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: filteredGyms.length,
                itemBuilder: (context, index) {
                  return GymCard(
                    gym: filteredGyms[index],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              GymProfileScreen(gym: filteredGyms[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Diálogo para ver notificaciones
class NotificationsViewDialog extends StatelessWidget {
  const NotificationsViewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos mock de notificaciones
    final notifications = [
      {
        'title': 'Nueva rutina disponible',
        'message': 'Rutina de fuerza avanzada',
        'time': 'Hace 2 horas',
      },
      {
        'title': 'Cita confirmada',
        'message': 'Tu cita con el entrenador está programada para mañana',
        'time': 'Hace 5 horas',
      },
      {
        'title': 'Actualización de app',
        'message': 'Nueva versión disponible con mejoras',
        'time': 'Hace 1 día',
      },
      {
        'title': 'Recordatorio',
        'message': 'No olvides completar tu rutina de hoy',
        'time': 'Hace 2 días',
      },
    ];

    return AlertDialog(
      title: const Text('Notificaciones'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notif = notifications[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: Color(0xFF4F46E5),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notif['title']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notif['message']!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      notif['time']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
