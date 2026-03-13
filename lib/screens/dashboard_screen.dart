import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'map_screen.dart';
import '../widgets/gym_card.dart'; // Asegúrate de tener este archivo creado

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Estado para los filtros
  String _activeFilter = "Todos";
  final List<String> _categories = [
    "Todos",
    "Gimnasio",
    "Box",
    "Yoga",
    "Estudio",
  ];

  // Datos de ejemplo (Mock Data)
  final List<Gym> _allGyms = [
    Gym(
      name: "Iron Temple Gym",
      type: "Gimnasio",
      address: "Calle Principal 123, Madrid",
      distance: "1.2 km",
      rating: 4.8,
      imageUrl: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48",
    ),
    Gym(
      name: "CrossFit Alpha",
      type: "Box",
      address: "Avenida Central 45, Barcelona",
      distance: "2.5 km",
      rating: 4.9,
      imageUrl: "https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5",
    ),
    Gym(
      name: "Zen Yoga Studio",
      type: "Yoga",
      address: "Plaza del Sol 12, Valencia",
      distance: "0.8 km",
      rating: 4.7,
      imageUrl: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b",
    ),
  ];

  void _openGoogleMaps() {
    // Obtener lista filtrada de gimnasios
    final filteredGyms = _activeFilter == "Todos"
        ? _allGyms
        : _allGyms.where((g) => g.type == _activeFilter).toList();
    
    // Navegar a la pantalla del mapa
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(gyms: filteredGyms),
      ),
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
            // 1. HEADER Y BUSCADOR
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // logo encabezado centrado
                  Center(
                    child: Text(
                      "Mobility GYM",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                      ),
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
                          color: Colors.black.withOpacity(0.03),
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

            // 2. BOTÓN PARA ABRIR MAPA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ElevatedButton(
                onPressed: _openGoogleMaps,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
                              color: kPrimaryIndigo.withOpacity(0.2),
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
                      // Acción al tocar la tarjeta
                      print("Seleccionado: ${filteredGyms[index].name}");
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
