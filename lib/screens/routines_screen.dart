import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Pantalla de rutinas con diseño profesional y contenido completo
class RoutinesScreen extends StatefulWidget {
  final String initialCategory;

  const RoutinesScreen({super.key, this.initialCategory = 'Todas'});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  late String _selectedCategory;
  bool _isGridView = false;
  final List<String> _categories = [
    'Todas',
    'Fuerza',
    'Cardio',
    'Flexibilidad',
    'Pérdida de peso',
    'Ganancia muscular',
  ];

  // Datos de rutinas de ejemplo
  final List<Routine> _allRoutines = [
    Routine(
      title: 'Fuerza Superior Completa',
      category: 'Fuerza',
      duration: '45 min',
      difficulty: 'Intermedio',
      exercises: 8,
      description:
          'Rutina enfocada en pecho, espalda y hombros para desarrollar fuerza superior.',
      imageUrl: 'assets/images/rut.PNG',
    ),
    Routine(
      title: 'Cardio HIIT Intenso',
      category: 'Cardio',
      duration: '30 min',
      difficulty: 'Avanzado',
      exercises: 6,
      description:
          'Entrenamiento de alta intensidad para quemar grasa y mejorar resistencia cardiovascular.',
      imageUrl: 'assets/images/cardio_intenso.png',
    ),
    Routine(
      title: 'Yoga para Principiantes',
      category: 'Flexibilidad',
      duration: '20 min',
      difficulty: 'Principiante',
      exercises: 10,
      description:
          'Secuencia básica de yoga para mejorar flexibilidad y reducir estrés.',
      imageUrl: 'assets/images/yoga.png',
    ),
    Routine(
      title: 'Pérdida de Peso Express',
      category: 'Pérdida de peso',
      duration: '40 min',
      difficulty: 'Intermedio',
      exercises: 7,
      description:
          'Combinación de cardio y fuerza para maximizar la quema de calorías.',
      imageUrl: 'assets/images/perdida_peso.png',
    ),
    Routine(
      title: 'Ganancia Muscular Full Body',
      category: 'Ganancia muscular',
      duration: '60 min',
      difficulty: 'Avanzado',
      exercises: 12,
      description:
          'Rutina completa para ganar masa muscular en todo el cuerpo.',
      imageUrl: 'assets/images/ganancia_muscular.png',
    ),
    Routine(
      title: 'Estiramiento Diario',
      category: 'Flexibilidad',
      duration: '15 min',
      difficulty: 'Principiante',
      exercises: 8,
      description:
          'Rutina de estiramiento para mantener la movilidad y prevenir lesiones.',
      imageUrl:
          'https://images.unsplash.com/photo-1549576490-b0b4831ef60a?w=600&h=400&fit=crop',
    ),
    Routine(
      title: 'Entrenamiento de Piernas',
      category: 'Fuerza',
      duration: '50 min',
      difficulty: 'Avanzado',
      exercises: 10,
      description:
          'Rutina intensiva para piernas y glúteos con ejercicios compuestos.',
      imageUrl: 'assets/images/entrenam_piernas.png',
    ),
    Routine(
      title: 'Pilates Completo',
      category: 'Flexibilidad',
      duration: '35 min',
      difficulty: 'Intermedio',
      exercises: 9,
      description:
          'Ejercicios de pilates para fortalecer core y mejorar postura.',
      imageUrl:
          'https://images.unsplash.com/photo-1575052814086-f385e2e2ad1b?w=600&h=400&fit=crop',
    ),
    Routine(
      title: 'Boxeo Cardiovascular',
      category: 'Cardio',
      duration: '45 min',
      difficulty: 'Avanzado',
      exercises: 8,
      description:
          'Entrenamiento de boxeo para quemar calorías y mejorar coordinación.',
      imageUrl: 'assets/images/boxeo.png',
    ),
    Routine(
      title: 'Espalda Fuerte',
      category: 'Fuerza',
      duration: '40 min',
      difficulty: 'Intermedio',
      exercises: 9,
      description:
          'Rutina especializada para construir una espalda fuerte y resistente.',
      imageUrl: 'assets/images/espalda.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories.contains(widget.initialCategory)
        ? widget.initialCategory
        : 'Todas';
  }

  List<Routine> get _filteredRoutines {
    if (_selectedCategory == 'Todas') return _allRoutines;
    return _allRoutines
        .where((routine) => routine.category == _selectedCategory)
        .toList();
  }

  // Método para mostrar el diálogo de ejercicios
  void _showExercisesDialog(BuildContext context, Routine routine) {
    final exercises = routine.getExercises();
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      Theme.of(context).textTheme,
    );

    // Responsive sizing for dialog
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;
    final dialogWidth = isMobile ? screenSize.width * 0.9 : 500.0;
    final titleFontSize = isMobile ? 18.0 : 20.0;
    final exerciseFontSize = isMobile ? 14.0 : 16.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Ejercicios de ${routine.title}',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF4F46E5),
              fontSize: titleFontSize,
            ),
          ),
          content: SizedBox(
            width: dialogWidth,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 10 : 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagen del ejercicio
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            image: _buildImageProvider(exercise['imageUrl']!),
                            width: double.infinity,
                            height: isMobile ? 120 : 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: isMobile ? 120 : 150,
                                color: const Color(0xFFEBEEF5),
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey,
                                  size: 36,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          exercise['name']!,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: exerciseFontSize,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _InfoChip(
                              icon: Icons.repeat,
                              text: '${exercise['sets']} sets',
                              isCompact: isMobile,
                            ),
                            SizedBox(width: isMobile ? 8 : 12),
                            _InfoChip(
                              icon: Icons.fitness_center,
                              text: exercise['reps']!,
                              isCompact: isMobile,
                            ),
                            SizedBox(width: isMobile ? 8 : 12),
                            _InfoChip(
                              icon: Icons.timer,
                              text: exercise['rest']!,
                              isCompact: isMobile,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cerrar',
                style: TextStyle(
                  color: const Color(0xFF4F46E5),
                  fontSize: isMobile ? 14 : 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const kPrimaryIndigo = Color(0xFF4F46E5);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      Theme.of(context).textTheme,
    );

    // Responsive utilities
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1200;

    // Responsive padding and sizing
    final horizontalPadding = isMobile
        ? 16.0
        : isTablet
        ? 24.0
        : 32.0;
    final verticalPadding = isMobile ? 16.0 : 24.0;
    final filterHeight = isMobile ? 66.0 : 72.0;
    final titleFontSize = isMobile
        ? 24.0
        : isTablet
        ? 28.0
        : 32.0;
    final subtitleFontSize = isMobile ? 14.0 : 16.0;
    final sectionTitleFontSize = isMobile ? 18.0 : 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con botón de regreso
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                verticalPadding,
                horizontalPadding,
                verticalPadding * 0.67,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botón de regreso
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(8),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFF4F46E5),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mis Rutinas',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: titleFontSize,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Entrena de manera inteligente y alcanza tus objetivos',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: subtitleFontSize,
                    ),
                  ),
                ],
              ),
            ),

            // Barra de búsqueda
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar rutinas...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: isMobile ? 14 : 16,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: isMobile ? 14 : 16,
                      horizontal: horizontalPadding,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Filtros horizontales
            SizedBox(
              height: filterHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding - 4,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = category),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        height: isMobile ? 40 : 44,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 14 : 18,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? kPrimaryIndigo : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSelected
                                ? kPrimaryIndigo
                                : Colors.grey[200]!,
                            width: 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: kPrimaryIndigo.withAlpha(28),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              category,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                fontSize: isMobile ? 12 : 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isSelected ? 26 : 0,
                              height: 3,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Lista de rutinas
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedCategory == 'Todas'
                        ? 'Rutinas disponibles'
                        : 'Rutinas de $_selectedCategory',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: sectionTitleFontSize,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(() => _isGridView = false),
                        icon: Icon(
                          Icons.list,
                          color: !_isGridView ? kPrimaryIndigo : Colors.grey,
                        ),
                        tooltip: 'Vista de lista',
                      ),
                      IconButton(
                        onPressed: () => setState(() => _isGridView = true),
                        icon: Icon(
                          Icons.grid_view,
                          color: _isGridView ? kPrimaryIndigo : Colors.grey,
                        ),
                        tooltip: 'Vista de cuadrícula',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Lista / Cuadrícula
            Expanded(
              child: _isGridView
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: GridView.builder(
                        itemCount: _filteredRoutines.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile
                              ? 2
                              : isTablet
                              ? 2
                              : 3,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          mainAxisExtent: isMobile
                              ? 260
                              : isTablet
                              ? 286
                              : 304,
                        ),
                        itemBuilder: (context, index) {
                          final routine = _filteredRoutines[index];
                          return _RoutineGridCard(
                            routine: routine,
                            onPressed: () =>
                                _showExercisesDialog(context, routine),
                          );
                        },
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      itemCount: _filteredRoutines.length,
                      itemBuilder: (context, index) {
                        return _RoutineCard(
                          routine: _filteredRoutines[index],
                          onPressed: () => _showExercisesDialog(
                            context,
                            _filteredRoutines[index],
                          ),
                          isMobile: isMobile,
                          isTablet: isTablet,
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

// Modelo de datos para rutina
class Routine {
  final String title;
  final String category;
  final String duration;
  final String difficulty;
  final int exercises;
  final String description;
  final String imageUrl;

  const Routine({
    required this.title,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.exercises,
    required this.description,
    required this.imageUrl,
  });

  // Método para obtener ejercicios de ejemplo según la rutina
  List<Map<String, String>> getExercises() {
    switch (title) {
      case 'Fuerza Superior Completa':
        return [
          {
            'name': 'Press de banca',
            'sets': '4',
            'reps': '8-10',
            'rest': '90s',
            'imageUrl': 'assets/images/press_banca.png',
          },
          {
            'name': 'Dominadas',
            'sets': '3',
            'reps': '6-8',
            'rest': '120s',
            'imageUrl': 'assets/images/dominadas.png',
          },
          {
            'name': 'Press militar',
            'sets': '4',
            'reps': '8-10',
            'rest': '90s',
            'imageUrl': 'assets/images/press_militar.png',
          },
          {
            'name': 'Remo con barra',
            'sets': '3',
            'reps': '8-10',
            'rest': '90s',
            'imageUrl': 'assets/images/remo_con_barra.png',
          },
          {
            'name': 'Elevaciones laterales',
            'sets': '3',
            'reps': '12-15',
            'rest': '60s',
            'imageUrl': 'assets/images/elevaciones.png',
          },
          {
            'name': 'Fondos en paralelas',
            'sets': '3',
            'reps': '10-12',
            'rest': '90s',
            'imageUrl': 'assets/images/fondos_paralelos.png',
          },
          {
            'name': 'Curl de bíceps',
            'sets': '3',
            'reps': '10-12',
            'rest': '60s',
            'imageUrl': 'assets/images/curl_biceps.png',
          },
          {
            'name': 'Extensiones de tríceps',
            'sets': '3',
            'reps': '10-12',
            'rest': '60s',
            'imageUrl': 'assets/images/extensiones_triceps.png',
          },
        ];
      case 'Cardio HIIT Intenso':
        return [
          {
            'name': 'Burpees',
            'sets': '4',
            'reps': '30s',
            'rest': '30s',
            'imageUrl': 'assets/images/burpees.png',
          },
          {
            'name': 'Mountain climbers',
            'sets': '4',
            'reps': '45s',
            'rest': '30s',
            'imageUrl': 'assets/images/mountain_climbers.png',
          },
          {
            'name': 'Saltos de tijera',
            'sets': '4',
            'reps': '30s',
            'rest': '30s',
            'imageUrl': 'assets/images/saltos_tijera.png',
          },
          {
            'name': 'Plank jacks',
            'sets': '4',
            'reps': '45s',
            'rest': '30s',
            'imageUrl': 'assets/images/plank_jacks.png',
          },
          {
            'name': 'High knees',
            'sets': '4',
            'reps': '30s',
            'rest': '30s',
            'imageUrl': 'assets/images/high_knees.png',
          },
          {
            'name': 'Push-up jacks',
            'sets': '4',
            'reps': '45s',
            'rest': '30s',
            'imageUrl': 'assets/images/pushup_jacks.png',
          },
        ];
      case 'Yoga para Principiantes':
        return [
          {
            'name': 'Saludo al sol',
            'sets': '3',
            'reps': '5 rondas',
            'rest': '30s',
            'imageUrl': 'assets/images/saludo_sol.png',
          },
          {
            'name': 'Postura del árbol',
            'sets': '2',
            'reps': '30s cada lado',
            'rest': '15s',
            'imageUrl': 'assets/images/postura_arbol.png',
          },
          {
            'name': 'Postura del perro',
            'sets': '3',
            'reps': '45s',
            'rest': '30s',
            'imageUrl': 'assets/images/postura_perro.png',
          },
          {
            'name': 'Postura del niño',
            'sets': '2',
            'reps': '60s',
            'rest': '30s',
            'imageUrl': 'assets/images/postura_niño.png',
          },
          {
            'name': 'Postura del guerrero I',
            'sets': '2',
            'reps': '30s cada lado',
            'rest': '15s',
            'imageUrl': 'assets/images/postura_guerrero.png',
          },
          {
            'name': 'Postura del puente',
            'sets': '2',
            'reps': '45s',
            'rest': '30s',
            'imageUrl': 'assets/images/postura_puente.png',
          },
          {
            'name': 'Respiración profunda',
            'sets': '1',
            'reps': '2 min',
            'rest': '0s',
            'imageUrl': 'assets/images/respiracion_profunda.png',
          },
          {
            'name': 'Relajación final',
            'sets': '1',
            'reps': '3 min',
            'rest': '0s',
            'imageUrl': 'assets/images/relajacion_final.png',
          },
        ];
      case 'Pérdida de Peso Express':
        return [
          {
            'name': 'Sentadillas',
            'sets': '3',
            'reps': '15',
            'rest': '45s',
            'imageUrl': 'assets/images/sentadillas.png',
          },
          {
            'name': 'Push-ups',
            'sets': '3',
            'reps': '12',
            'rest': '60s',
            'imageUrl': 'assets/images/push_ups.png',
          },
          {
            'name': 'Saltos de cuerda',
            'sets': '4',
            'reps': '2 min',
            'rest': '30s',
            'imageUrl': 'assets/images/saltos_cuerda.png',
          },
          {
            'name': 'Planks',
            'sets': '3',
            'reps': '45s',
            'rest': '60s',
            'imageUrl': 'assets/images/planks.png',
          },
          {
            'name': 'Burpees',
            'sets': '3',
            'reps': '10',
            'rest': '60s',
            'imageUrl': 'assets/images/burpees.png',
          },
          {
            'name': 'Mountain climbers',
            'sets': '3',
            'reps': '30s',
            'rest': '45s',
            'imageUrl': 'assets/images/mountain_climbers.png',
          },
          {
            'name': 'Russian twists',
            'sets': '3',
            'reps': '20',
            'rest': '45s',
            'imageUrl': 'assets/images/russian_twists.png',
          },
        ];
      case 'Ganancia Muscular Full Body':
        return [
          {
            'name': 'Sentadillas con barra',
            'sets': '4',
            'reps': '6-8',
            'rest': '180s',
            'imageUrl': 'assets/images/sentadillas_barra.png',
          },
          {
            'name': 'Press de banca',
            'sets': '4',
            'reps': '6-8',
            'rest': '150s',
            'imageUrl': 'assets/images/press_banca.png',
          },
          {
            'name': 'Peso muerto',
            'sets': '3',
            'reps': '6-8',
            'rest': '180s',
            'imageUrl': 'assets/images/peso_muerto.png',
          },
          {
            'name': 'Press militar',
            'sets': '3',
            'reps': '8-10',
            'rest': '120s',
            'imageUrl': 'assets/images/press_militar.png',
          },
          {
            'name': 'Remo con barra',
            'sets': '3',
            'reps': '8-10',
            'rest': '120s',
            'imageUrl': 'assets/images/remo_con_barra.png',
          },
          {
            'name': 'Flexiones',
            'sets': '3',
            'reps': '10-12',
            'rest': '90s',
            'imageUrl': 'assets/images/push_ups.png',
          },
          {
            'name': 'Curl de bíceps',
            'sets': '3',
            'reps': '10-12',
            'rest': '90s',
            'imageUrl': 'assets/images/curl_biceps.png',
          },
          {
            'name': 'Extensiones de tríceps',
            'sets': '3',
            'reps': '10-12',
            'rest': '90s',
            'imageUrl': 'assets/images/extensiones_triceps.png',
          },
          {
            'name': 'Elevaciones de hombros',
            'sets': '3',
            'reps': '12-15',
            'rest': '60s',
            'imageUrl': 'assets/images/elevaciones.png',
          },
          {
            'name': 'Abdominales',
            'sets': '3',
            'reps': '15-20',
            'rest': '60s',
            'imageUrl': 'assets/images/abdominales.png',
          },
          {
            'name': 'Fondos de piernas',
            'sets': '3',
            'reps': '12-15',
            'rest': '90s',
            'imageUrl': 'assets/images/fondos_piernas.png',
          },
          {
            'name': 'Pull-ups asistidas',
            'sets': '3',
            'reps': '8-10',
            'rest': '120s',
            'imageUrl': 'assets/images/dominada.png',
          },
        ];
      case 'Estiramiento Diario':
        return [
          {
            'name': 'Estiramiento de cuello',
            'sets': '2',
            'reps': '30s cada lado',
            'rest': '10s',
            'imageUrl': 'assets/images/estiramiento_cuello.png',
          },
          {
            'name': 'Estiramiento de hombros',
            'sets': '2',
            'reps': '30s cada lado',
            'rest': '10s',
            'imageUrl': 'assets/images/estiramiento_hombros.png',
          },
          {
            'name': 'Estiramiento de brazos',
            'sets': '2',
            'reps': '30s cada brazo',
            'rest': '10s',
            'imageUrl': 'assets/images/estiramiento_brazos.png',
          },
          {
            'name': 'Estiramiento de espalda',
            'sets': '2',
            'reps': '45s',
            'rest': '15s',
            'imageUrl': 'assets/images/saludo_sol.png',
          },
          {
            'name': 'Estiramiento de caderas',
            'sets': '2',
            'reps': '30s cada lado',
            'rest': '10s',
            'imageUrl': 'assets/images/estiramiento_cadera.png',
          },
          {
            'name': 'Estiramiento de cuádriceps',
            'sets': '2',
            'reps': '30s cada pierna',
            'rest': '10s',
            'imageUrl': 'assets/images/estiramiento_cuadriceps.png',
          },
          {
            'name': 'Estiramiento de isquiotibiales',
            'sets': '2',
            'reps': '30s cada pierna',
            'rest': '10s',
            'imageUrl': 'assets/images/estiramiento_isquiotibiales.png',
          },
          {
            'name': 'Estiramiento de pantorrillas',
            'sets': '2',
            'reps': '30s cada pierna',
            'rest': '10s',
            'imageUrl': 'assets/images/estiramiento_pantorrillas.png',
          },
        ];
      default:
        return [
          {
            'name': 'Ejercicio 1',
            'sets': '3',
            'reps': '10',
            'rest': '60s',
            'imageUrl':
                'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop',
          },
          {
            'name': 'Ejercicio 2',
            'sets': '3',
            'reps': '10',
            'rest': '60s',
            'imageUrl':
                'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop',
          },
          {
            'name': 'Ejercicio 3',
            'sets': '3',
            'reps': '10',
            'rest': '60s',
            'imageUrl':
                'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop',
          },
        ];
    }
  }
}

ImageProvider<Object> _buildImageProvider(String imageUrl) {
  return imageUrl.startsWith('http')
      ? NetworkImage(imageUrl)
      : AssetImage(imageUrl);
}

// Widget para tarjeta de rutina normal (vertical)
class _RoutineCard extends StatelessWidget {
  final Routine routine;
  final VoidCallback onPressed;
  final bool isMobile;
  final bool isTablet;

  const _RoutineCard({
    required this.routine,
    required this.onPressed,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      Theme.of(context).textTheme,
    );

    // Responsive sizing
    final imageSize = isMobile
        ? 70.0
        : isTablet
        ? 80.0
        : 90.0;
    final titleFontSize = isMobile
        ? 13.0
        : isTablet
        ? 15.0
        : 16.0;
    final descriptionFontSize = isMobile
        ? 11.0
        : isTablet
        ? 12.0
        : 13.0;
    final padding = isMobile
        ? 10.0
        : isTablet
        ? 14.0
        : 16.0;
    final marginBottom = isMobile ? 10.0 : 14.0;

    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          children: [
            // Imagen
            Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: _buildImageProvider(routine.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: isMobile ? 12 : 16),
            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routine.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: titleFontSize,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    routine.description,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: descriptionFontSize,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.timer,
                        text: routine.duration,
                        isCompact: isMobile,
                      ),
                      SizedBox(width: isMobile ? 6 : 8),
                      _InfoChip(
                        icon: Icons.fitness_center,
                        text: '${routine.exercises}',
                        isCompact: isMobile,
                      ),
                      SizedBox(width: isMobile ? 6 : 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 6 : 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(
                            routine.difficulty,
                          ).withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          routine.difficulty,
                          style: TextStyle(
                            color: _getDifficultyColor(routine.difficulty),
                            fontSize: isMobile ? 10 : 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: isMobile ? 12 : 16),
            // Botón
            IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.list, color: Color(0xFF4F46E5)),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4FF),
                padding: EdgeInsets.all(isMobile ? 8 : 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'principiante':
        return Colors.green;
      case 'intermedio':
        return Colors.orange;
      case 'avanzado':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

// Widget para tarjeta de rutina en cuadrícula
class _RoutineGridCard extends StatelessWidget {
  final Routine routine;
  final VoidCallback onPressed;

  const _RoutineGridCard({required this.routine, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      Theme.of(context).textTheme,
    );

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(32),
              blurRadius: 18,
              spreadRadius: 1.5,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image(
                image: _buildImageProvider(routine.imageUrl),
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    width: double.infinity,
                    color: const Color(0xFFEBEEF5),
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                      size: 36,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routine.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    routine.description,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.timer,
                            text: routine.duration,
                            isCompact: true,
                          ),
                          const SizedBox(width: 6),
                          _InfoChip(
                            icon: Icons.fitness_center,
                            text: '${routine.exercises} ej.',
                            isCompact: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(
                            routine.difficulty,
                          ).withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          routine.difficulty,
                          style: TextStyle(
                            color: _getDifficultyColor(routine.difficulty),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
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
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'principiante':
        return Colors.green;
      case 'intermedio':
        return Colors.orange;
      case 'avanzado':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

// Widget para chips de información
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isCompact;

  const _InfoChip({
    required this.icon,
    required this.text,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = isCompact ? 14.0 : 16.0;
    final fontSize = isCompact ? 10.0 : 12.0;
    final spacing = isCompact ? 2.0 : 4.0;

    return Row(
      children: [
        Icon(icon, size: iconSize, color: Colors.grey[500]),
        SizedBox(width: spacing),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: fontSize,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
