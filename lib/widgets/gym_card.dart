import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Definimos un modelo sencillo para los datos del gimnasio
class Gym {
  final String name;
  final String type;
  final String address;
  final String distance;
  final double rating;
  final String imageUrl;

  Gym({
    required this.name,
    required this.type,
    required this.address,
    required this.distance,
    required this.rating,
    required this.imageUrl,
  });
}

class GymCard extends StatelessWidget {
  final Gym gym;
  final VoidCallback? onTap;

  const GymCard({
    super.key, 
    required this.gym,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Colores basados en el diseño original
    const kIndigo = Color(0xFF4F46E5);
    const kSlate400 = Color(0xFF94A3B8);
    const kSlate900 = Color(0xFF0F172A);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 128, // Altura exacta para móviles
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32), // Bordes extra redondeados
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // PARTE IZQUIERDA: IMAGEN + RATING
            Stack(
              children: [
                Hero(
                  tag: 'gym-image-${gym.name}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(32),
                    ),
                    child: Image.network(
                      gym.imageUrl,
                      width: 120,
                      height: 128,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Badge de Rating (Estrellita)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          gym.rating.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: kSlate900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // PARTE DERECHA: INFORMACIÓN
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Títulos
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gym.type.toUpperCase(),
                          style: const TextStyle(
                            color: kIndigo,
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          gym.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kSlate900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(LucideIcons.mapPin, size: 12, color: kSlate400),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                gym.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: kSlate400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Fila inferior: Distancia y Botón de Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            gym.distance,
                            style: const TextStyle(
                              color: kIndigo,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Row(
                          children: [
                            Text(
                              "Detalle",
                              style: TextStyle(
                                fontSize: 10,
                                color: kSlate400,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(LucideIcons.info, size: 14, color: kSlate400),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
