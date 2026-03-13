import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/gym_card.dart';

class MapScreen extends StatefulWidget {
  final List<Gym> gyms;
  const MapScreen({super.key, required this.gyms});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Color get kPrimaryIndigo => const Color(0xFF4F46E5);
  Color get kSlate50 => const Color(0xFFF8FAFC);
  Color get kSlate900 => const Color(0xFF0F172A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gimnasios Cercanos'),
        backgroundColor: kPrimaryIndigo,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Fondo del mapa visual
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(18.9420, -70.4090),
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: _buildMapMarkers()),
            ],
          ),
          // Markers posicionados

          // Panel de lista de gimnasios
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Gimnasios encontrados (${widget.gyms.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.gyms.length,
                      itemBuilder: (context, index) {
                        final gym = widget.gyms[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 280,
                          child: _buildGymCard(gym),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Marker> _buildMapMarkers() {
    final baseLat = 18.9420;
    final baseLng = -70.4090;

    return widget.gyms.asMap().entries.map((entry) {
      final index = entry.key;
      final gym = entry.value;

      // desplazamientos pequeños para separar los marcadores
      final latOffset = 0.002 * index;
      final lngOffset = 0.002 * index;

      return Marker(
        width: 120,
        height: 60,
        point: LatLng(baseLat + latOffset, baseLng + lngOffset),
        child: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${gym.name} - ${gym.distance}')),
            );
          },
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: kPrimaryIndigo,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryIndigo.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: kPrimaryIndigo,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  gym.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildGymCard(Gym gym) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kPrimaryIndigo.withValues(alpha: 0.05),
              kPrimaryIndigo.withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kPrimaryIndigo.withValues(alpha: 0.2)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gym.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              gym.type,
              style: TextStyle(
                fontSize: 11,
                color: kSlate900.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${gym.rating}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  gym.distance,
                  style: TextStyle(
                    fontSize: 11,
                    color: kPrimaryIndigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              gym.address,
              style: TextStyle(
                fontSize: 10,
                color: kSlate900.withValues(alpha: 0.5),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
