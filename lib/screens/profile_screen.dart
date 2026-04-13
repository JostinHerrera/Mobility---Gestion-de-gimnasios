import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main_navigation.dart';
import 'trainers_list_screen.dart';
import 'login_screen.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../firebase_options.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Pantalla de perfil del usuario con configuración y datos físicos
class ProfileScreen extends StatefulWidget {
  final bool openEditor;
  final bool initialPublic;
  const ProfileScreen({
    super.key,
    this.openEditor = false,
    this.initialPublic = true,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    // Cargar datos una sola vez cuando se crea la pantalla
    _loadProfileDataOnce();

    if (widget.openEditor) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openEditPhysical(context);
      });
    }
  }

  // Cargar datos una sola vez y actualizar el estado
  Future<void> _loadProfileDataOnce() async {
    final data = await _getProfileData();
    if (!mounted) return;

    if (data != null) {
      setState(() {
        name =
            data['name'] as String? ??
            FirebaseAuth.instance.currentUser?.displayName ??
            'Usuario';
        weight = (data['weight'] as num?)?.toDouble() ?? 75.0;
        height = (data['height'] as num?)?.toInt() ?? 178;
        birthDate =
            _parseDate(
              data['birthDate'] as String? ?? data['birth_date'] as String?,
            ) ??
            DateTime(1996, 1, 1);
        gender = data['gender'] as String? ?? 'Masculino';
        bodyType =
            data['bodyType'] as String? ??
            data['body_type'] as String? ??
            'Ectomorfo';
        objective = data['objective'] as String? ?? 'Ganancia muscular';
        _publicProfile =
            data['publicProfile'] as bool? ??
            data['public_profile'] as bool? ??
            true;
        _planType =
            data['planType'] as String? ??
            data['plan_type'] as String? ??
            'Premium';
        _profileImagePath =
            data['profileImagePath'] as String? ??
            data['profile_image_path'] as String?;
        _profileImageUrl =
            data['profileImageUrl'] as String? ??
            data['profile_image_url'] as String?;
      });
    } else {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          name = user.displayName ?? 'Usuario';
          _publicProfile = true;
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _getProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      final idToken = await user.getIdToken();
      final projectId = DefaultFirebaseOptions.currentPlatform.projectId;

      final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/profiles/${user.uid}',
      );

      final resp = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final json = jsonDecode(resp.body);
        final fields = json['fields'] as Map<String, dynamic>?;

        if (fields == null) return null;

        Map<String, dynamic> data = {};

        fields.forEach((key, value) {
          if (value.containsKey('stringValue')) {
            data[key] = value['stringValue'];
          } else if (value.containsKey('doubleValue')) {
            data[key] = (value['doubleValue'] as num).toDouble();
          } else if (value.containsKey('integerValue')) {
            data[key] = int.tryParse(value['integerValue'].toString());
          } else if (value.containsKey('booleanValue')) {
            data[key] = value['booleanValue'];
          }
        });

        return data;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Variables de estado para el perfil público y datos físicos
  String name = 'Usuario';
  bool _publicProfile = true;
  double weight = 75.0;
  int height = 178;
  DateTime birthDate = DateTime(1996, 1, 1);
  String gender = 'Masculino';
  String bodyType = 'Ectomorfo';
  String objective = 'Ganancia muscular';
  String _planType = 'Premium'; // 'Free' o 'Premium'
  String? _profileImagePath; // Ruta de la imagen de perfil local
  String? _profileImageUrl; // URL de la imagen de perfil en Firebase Storage
  Uint8List? _profileImageBytes; // Bytes de imagen para web

  // Variable cached para la edad
  int _cachedAge = 28;

  // Timer para debounce del guardado automático
  Timer? _saveTimer;

  // Getter para calcular la edad (usando cache)
  int get age {
    // Recalcular solo si la fecha cambió significativamente
    final now = DateTime.now();
    int calculatedAge = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      calculatedAge--;
    }

    // Actualizar cache si cambió
    if (calculatedAge != _cachedAge) {
      _cachedAge = calculatedAge;
    }

    return _cachedAge;
  }

  // Método con debounce para guardar el perfil
  void _debouncedSaveProfile() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 1000), () {
      _saveProfileToFirebase();
    });
  }

  @override
  Widget build(BuildContext context) {
    const kPrimaryIndigo = Color(0xFF4F46E5);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      Theme.of(context).textTheme,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF4F46E5)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ...existing code...
              const Divider(),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainNavigation(initialIndex: 0),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.fitness_center),
                title: const Text('Rutinas'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainNavigation(initialIndex: 1),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Chat'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainNavigation(initialIndex: 2),
                    ),
                  );
                },
              ),

              const Spacer(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.exit_to_app,
                    color: Color(0xFFDC2626),
                  ),
                ),
                title: Text(
                  'Cerrar Sesión',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFDC2626),
                  ),
                ),
                onTap: () async {
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
                  if (!mounted) return;
                  if (confirmed == true) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mi Perfil',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  ElevatedButton.icon(
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
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Header card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: const Color(0xFFF3F4FF),
                          backgroundImage:
                              _profileImageUrl != null &&
                                      _profileImageUrl!.isNotEmpty
                                  ? NetworkImage(_profileImageUrl!)
                                  : _profileImageBytes != null
                                      ? MemoryImage(_profileImageBytes!) as ImageProvider
                                      : null,
                          child:
                              (_profileImageUrl == null ||
                                      _profileImageUrl!.isEmpty) &&
                                  _profileImageBytes == null
                              ? Icon(
                                  Icons.person,
                                  size: 36,
                                  color: kPrimaryIndigo,
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: _pickProfileImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: kPrimaryIndigo,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _planType == 'Pro'
                          ? 'MIEMBRO PRO'
                          : _planType == 'FREE'
                          ? 'MIEMBRO PREMIUM'
                          : 'MIEMBRO FREE',
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),

                    const Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _smallInfo('Nivel', 'Intermedio', kPrimaryIndigo),
                        _smallInfo('Racha', '12 Días', Colors.green),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Public profile toggle
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    'Perfil Público',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: const Text('Visibilidad de perfil'),
                  value: _publicProfile,
                  activeThumbColor: kPrimaryIndigo,
                  onChanged: (v) {
                    setState(() => _publicProfile = v);
                    _debouncedSaveProfile();
                  },
                ),
              ),

              const SizedBox(height: 18),

              // Datos Físicos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Datos Físicos',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _openEditPhysical(context),
                    child: const Text('Editar'),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 237, 237, 237),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _PhysCard(
                          icon: Icons.monitor_weight,
                          label: 'Peso',
                          value: '$weight kg',
                        ),
                        _PhysCard(
                          icon: Icons.height,
                          label: 'Altura',
                          value: '$height cm',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _PhysCard(
                          icon: Icons.cake,
                          label: 'Edad',
                          value: '$age años',
                        ),

                        _PhysCard(
                          icon: Icons.person,
                          label: 'Sexo',
                          value: gender,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _PhysCard(
                          icon: Icons.fitness_center,
                          label: 'Tipo de cuerpo',
                          value: bodyType,
                        ),

                        _PhysCard(
                          icon: Icons.flag,
                          label: 'Objetivo',
                          value: objective,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // List of settings
              _buildListTile(
                context,
                icon: Icons.payment,
                title: 'Métodos de Pago',
                subtitle: 'Gestiona tus tarjetas',
                onTap: () => _openPaymentMethods(context),
              ),
              _buildListTile(
                context,
                icon: Icons.notifications,
                title: 'Notificaciones',
                subtitle: 'Configura tus avisos',
                onTap: () => _openNotifications(context),
              ),
              _buildListTile(
                context,
                icon: Icons.shield,
                title: 'Seguridad',
                subtitle: 'Contraseña y acceso',
                onTap: () => _openSecurity(context),
              ),
              _buildListTile(
                context,
                icon: Icons.help_outline,
                title: 'Soporte',
                subtitle: 'Centro de ayuda',
                onTap: () => _openSupport(context),
              ),

              const SizedBox(height: 18),

              // Cerrar sesión (ListTile rojo)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () async {
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
                    if (!mounted) return;
                    if (confirmed == true) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.exit_to_app,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  title: Text(
                    'Cerrar Sesión',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                ),
              ),

              // Upgrade card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF4F46E5)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.flash_on, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Upgrade a PRO',
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Desbloquea rutinas exclusivas y seguimiento 24/7 con IA.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => _openPlans(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: kPrimaryIndigo,
                        ),
                        child: const Text('Ver Planes'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    super.dispose();
  }

  // Método para seleccionar imagen desde el explorador
  Future<void> _pickProfileImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null) {
        final file = result.files.single;
        final bytes = file.bytes;

        if (bytes != null) {
          setState(() {
            _profileImageBytes = bytes;
            _profileImagePath = null;
          });
          await _saveProfileImageToFirebase(
            imageBytes: bytes,
            fileName: file.name,
          );
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No se pudo leer la imagen seleccionada.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Método para guardar imagen en Firebase Storage
  Future<void> _saveProfileImageToFirebase({
    Uint8List? imageBytes,
    String? fileName,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      if (imageBytes == null) {
        throw Exception('No se proporcionó archivo de imagen válido.');
      }

      final extension = fileName?.split('.').last ?? 'jpg';
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.$extension');

      final uploadTask = storageRef.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/$extension'),
      );

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _profileImageUrl = downloadUrl;
        _profileImagePath = null;
        _profileImageBytes = null;
      });

      await _saveProfileToFirebase();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Imagen de perfil actualizada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al subir imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Método para cambiar el plan
  void _changePlan(String newPlan) {
    setState(() {
      _planType = newPlan;
    });
    _saveProfileToFirebase(); // Guardar el cambio en Firebase
  }

  // Helper para parsear fechas
  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  // Función para guardar datos en Firebase
  Future<void> _saveProfileToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final idToken = await user.getIdToken();
      final projectId = DefaultFirebaseOptions.currentPlatform.projectId;

      final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/profiles/${user.uid}',
      );

      final body = {
        'fields': {
          'id': {'stringValue': user.uid},
          'name': {'stringValue': name},
          'weight': {'doubleValue': weight},
          'height': {'integerValue': height.toString()},
          'birthDate': {'stringValue': birthDate.toIso8601String()},
          'gender': {'stringValue': gender},
          'bodyType': {'stringValue': bodyType},
          'objective': {'stringValue': objective},
          'publicProfile': {'booleanValue': _publicProfile},
          'planType': {'stringValue': _planType},
          'profileImagePath': {'stringValue': _profileImagePath ?? ''},
          'profileImageUrl': {'stringValue': _profileImageUrl ?? ''},
        },
      };

      final resp = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (mounted && resp.statusCode >= 200 && resp.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cambios guardados correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Función para abrir el diálogo de edición de datos físicos
  void _openEditPhysical(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => EditPhysicalDialog(
        initialWeight: weight,
        initialHeight: height,
        initialBirthDate: birthDate,
        initialGender: gender,
        initialBodyType: bodyType,
        initialObjective: objective,
        onSave:
            (
              newWeight,
              newHeight,
              newBirthDate,
              newGender,
              newBodyType,
              newObjective,
            ) async {
              setState(() {
                weight = newWeight;
                height = newHeight;
                birthDate = newBirthDate;
                gender = newGender;
                bodyType = newBodyType;
                objective = newObjective;
              });
              Navigator.of(ctx).pop();

              // Guardar en Firebase después de actualizar la UI
              await _saveProfileToFirebase();
            },
      ),
    );
  }

  // Función para abrir el diálogo de métodos de pago
  void _openPaymentMethods(BuildContext context) {
    showDialog(context: context, builder: (ctx) => const PaymentMethodDialog());
  }

  // Función para abrir el diálogo de notificaciones
  void _openNotifications(BuildContext context) {
    showDialog(context: context, builder: (ctx) => const NotificationsDialog());
  }

  // Función para abrir el diálogo de seguridad
  void _openSecurity(BuildContext context) {
    showDialog(context: context, builder: (ctx) => const SecurityDialog());
  }

  // Función para abrir el diálogo de soporte
  void _openSupport(BuildContext context) {
    showDialog(context: context, builder: (ctx) => const SupportDialog());
  }

  // Función para abrir el diálogo de planes
  void _openPlans(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => PlansDialog(onPaymentSuccess: _changePlan),
    );
  }
}

// Widget para mostrar información pequeña en columnas (nivel, racha)
Widget _smallInfo(String title, String value, Color color) {
  return Column(
    children: [
      Text(
        title,
        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey),
      ),
      const SizedBox(height: 6),
      Text(
        value,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    ],
  );
}

// Widget para tarjetas de datos físicos
class _PhysCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _PhysCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF6B7280)),
            const SizedBox(height: 8),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildListTile(
  BuildContext context, {
  required IconData icon,
  required String title,
  String? subtitle,
  VoidCallback? onTap,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF4F46E5)),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Pantalla: $title')),
    );
  }
}

// Diálogo para editar datos físicos del usuario
class EditPhysicalDialog extends StatefulWidget {
  final double initialWeight;
  final int initialHeight;
  final DateTime initialBirthDate;
  final String initialGender;
  final String initialBodyType;
  final String initialObjective;
  final Function(double, int, DateTime, String, String, String) onSave;

  const EditPhysicalDialog({
    required this.initialWeight,
    required this.initialHeight,
    required this.initialBirthDate,
    required this.initialGender,
    required this.initialBodyType,
    required this.initialObjective,
    required this.onSave,
    super.key,
  });

  @override
  State<EditPhysicalDialog> createState() => _EditPhysicalDialogState();
}

class _EditPhysicalDialogState extends State<EditPhysicalDialog> {
  late TextEditingController weightController;
  late TextEditingController heightController;
  late DateTime selectedDate;
  late String selectedGender;
  late String selectedBodyType;
  late String selectedObjective;

  final List<String> genderOptions = ['Masculino', 'Femenino'];
  final List<String> bodyTypeOptions = ['Ectomorfo', 'Mesomorfo', 'Endomorfo'];
  final List<String> objectiveOptions = [
    'Ganancia muscular',
    'Pérdida de peso',
    'Mantenimiento',
  ];

  @override
  void initState() {
    super.initState();
    weightController = TextEditingController(
      text: widget.initialWeight.toString(),
    );
    heightController = TextEditingController(
      text: widget.initialHeight.toString(),
    );
    selectedDate = widget.initialBirthDate;
    selectedGender = widget.initialGender;
    selectedBodyType = widget.initialBodyType;
    selectedObjective = widget.initialObjective;
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  // Función para seleccionar fecha de nacimiento
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Datos Físicos'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: heightController,
              decoration: const InputDecoration(labelText: 'Altura (cm)'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Fecha de nacimiento: ${selectedDate.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Seleccionar'),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              initialValue: selectedGender,
              decoration: const InputDecoration(labelText: 'Sexo'),
              items: genderOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: selectedBodyType,
              decoration: const InputDecoration(labelText: 'Tipo de cuerpo'),
              items: bodyTypeOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedBodyType = newValue!;
                });
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: selectedObjective,
              decoration: const InputDecoration(labelText: 'Objetivo'),
              items: objectiveOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedObjective = newValue!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final double weight =
                double.tryParse(weightController.text) ?? widget.initialWeight;
            final int height =
                int.tryParse(heightController.text) ?? widget.initialHeight;
            widget.onSave(
              weight,
              height,
              selectedDate,
              selectedGender,
              selectedBodyType,
              selectedObjective,
            );
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

// Diálogo para configurar notificaciones
class NotificationsDialog extends StatefulWidget {
  const NotificationsDialog({super.key});

  @override
  State<NotificationsDialog> createState() => _NotificationsDialogState();
}

class _NotificationsDialogState extends State<NotificationsDialog> {
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool smsNotifications = false;
  bool reminderNotifications = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Configurar Notificaciones'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Notificaciones Push'),
              subtitle: const Text('Recibe notificaciones en la app'),
              value: pushNotifications,
              onChanged: (value) => setState(() => pushNotifications = value),
            ),
            SwitchListTile(
              title: const Text('Notificaciones por Email'),
              subtitle: const Text('Recibe actualizaciones por correo'),
              value: emailNotifications,
              onChanged: (value) => setState(() => emailNotifications = value),
            ),
            SwitchListTile(
              title: const Text('Notificaciones SMS'),
              subtitle: const Text('Recibe alertas por mensaje de texto'),
              value: smsNotifications,
              onChanged: (value) => setState(() => smsNotifications = value),
            ),
            SwitchListTile(
              title: const Text('Recordatorios'),
              subtitle: const Text('Recibe recordatorios de rutinas y citas'),
              value: reminderNotifications,
              onChanged: (value) =>
                  setState(() => reminderNotifications = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            // Here you would save the settings
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Configuración guardada')),
            );
            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

// Diálogo para configuración de seguridad
class SecurityDialog extends StatefulWidget {
  const SecurityDialog({super.key});

  @override
  State<SecurityDialog> createState() => _SecurityDialogState();
}

class _SecurityDialogState extends State<SecurityDialog> {
  bool twoFactorAuth = false;
  bool biometricLogin = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seguridad'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Cambiar Contraseña'),
              subtitle: const Text('Actualiza tu contraseña'),
              onTap: () {
                // Navigate to change password screen
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Funcionalidad de cambio de contraseña (simulada)',
                    ),
                  ),
                );
              },
            ),
            SwitchListTile(
              title: const Text('Autenticación de Dos Factores'),
              subtitle: const Text('Añade una capa extra de seguridad'),
              value: twoFactorAuth,
              onChanged: (value) => setState(() => twoFactorAuth = value),
            ),
            SwitchListTile(
              title: const Text('Inicio de Sesión Biométrico'),
              subtitle: const Text('Usa huella o rostro para acceder'),
              value: biometricLogin,
              onChanged: (value) => setState(() => biometricLogin = value),
            ),
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text('Dispositivos Conectados'),
              subtitle: const Text('Gestiona tus sesiones activas'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dispositivos conectados (simulado)'),
                  ),
                );
              },
            ),
          ],
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

// Diálogo para centro de soporte
class SupportDialog extends StatelessWidget {
  const SupportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Centro de Soporte'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('Preguntas Frecuentes'),
              subtitle: const Text('Encuentra respuestas rápidas'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('FAQ (simulado)')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat con Soporte'),
              subtitle: const Text('Habla con nuestro equipo'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat de soporte (simulado)')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Enviar Email'),
              subtitle: const Text('Contáctanos por correo'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email enviado (simulado)')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Llamar'),
              subtitle: const Text('Llama a soporte técnico'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Llamada iniciada (simulado)')),
                );
              },
            ),
          ],
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

// Diálogo para mostrar planes de suscripción
class PlansDialog extends StatelessWidget {
  final Function(String) onPaymentSuccess;
  const PlansDialog({super.key, required this.onPaymentSuccess});

  @override
  Widget build(BuildContext context) {
    final plans = [
      {
        'name': 'Básico',
        'price': 'Gratis',
        'features': ['Acceso limitado', 'Rutinas básicas', 'Soporte básico'],
      },
      {
        'name': 'Premium',
        'price': '9.99€/mes',
        'features': [
          'Rutinas ilimitadas',
          'Seguimiento IA',
          'Soporte prioritario',
          'Sin anuncios',
        ],
        'popular': true,
      },
      {
        'name': 'Pro',
        'price': '19.99€/mes',
        'features': [
          'Todo lo de Premium',
          'Entrenadores personales',
          'Análisis avanzado',
          'Acceso anticipado',
        ],
      },
    ];

    return AlertDialog(
      title: const Text('Planes Disponibles'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: plan['popular'] == true ? const Color(0xFFF3F4FF) : null,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          plan['name'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (plan['popular'] == true) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4F46E5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Popular',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      plan['price'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F46E5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (plan['features'] as List<String>)
                          .map(
                            (feature) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(feature),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          final planName = plan['name'] as String;
                          final planPrice = plan['price'] as String;

                          Navigator.of(
                            context,
                          ).pop(); // Cerrar diálogo de planes

                          // Abrir diálogo de pago
                          showDialog(
                            context: context,
                            builder: (paymentCtx) => PaymentDialog(
                              planName: planName,
                              planPrice: planPrice,
                              onPaymentSuccess: onPaymentSuccess,
                            ),
                          );
                        },
                        child: const Text('Seleccionar'),
                      ),
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
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}

// Diálogo para agregar método de pago (nota: usa RadioListTile deprecated, considerar actualizar a RadioGroup)
class PaymentMethodDialog extends StatefulWidget {
  const PaymentMethodDialog({super.key});

  @override
  State<PaymentMethodDialog> createState() => _PaymentMethodDialogState();
}

class _PaymentMethodDialogState extends State<PaymentMethodDialog> {
  String selectedType = 'card'; // 'card' or 'paypal'

  // Controladores para tarjeta
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  // Controlador para PayPal
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Método de Pago'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selecciona el tipo de método de pago:'),
            Column(
              children: [
                ListTile(
                  title: const Text('Tarjeta de Crédito/Débito'),
                  leading: Radio<String>(
                    value: 'card',
                    groupValue: selectedType,
                    onChanged: (value) => setState(() => selectedType = value!),
                  ),
                ),
                ListTile(
                  title: const Text('PayPal'),
                  leading: Radio<String>(
                    value: 'paypal',
                    groupValue: selectedType,
                    onChanged: (value) => setState(() => selectedType = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (selectedType == 'card') ...[
              TextField(
                controller: cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Número de Tarjeta',
                  hintText: '1234 5678 9012 3456',
                ),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expiryController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de Expiración',
                        hintText: 'MM/YY',
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre en la Tarjeta',
                  hintText: 'Juan Pérez',
                ),
              ),
            ] else ...[
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico de PayPal',
                  hintText: 'usuario@ejemplo.com',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            // Here you would validate and save the payment method
            // For now, just show a snackbar and close
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Método de pago agregado (simulado)'),
              ),
            );
            Navigator.of(context).pop();
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}

// Diálogo para procesar el pago de un plan
class PaymentDialog extends StatefulWidget {
  final String planName;
  final String planPrice;
  final Function(String) onPaymentSuccess;

  const PaymentDialog({
    super.key,
    required this.planName,
    required this.planPrice,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String selectedPaymentMethod = 'card';
  bool isProcessing = false;

  // Controladores para tarjeta
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (selectedPaymentMethod == 'card') {
      if (cardNumberController.text.isEmpty ||
          expiryController.text.isEmpty ||
          cvvController.text.isEmpty ||
          nameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor completa todos los campos'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() => isProcessing = true);

    // Simular procesamiento de pago
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => isProcessing = false);

      // Llamar al callback de éxito
      widget.onPaymentSuccess(widget.planName == 'Premium' ? 'Premium' : 'Pro');

      Navigator.of(context).pop(); // Cerrar diálogo de pago

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Pago exitoso! Plan ${widget.planName} activado'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pagar Plan ${widget.planName}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Precio: ${widget.planPrice}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Selecciona método de pago:'),
            Column(
              children: [
                ListTile(
                  title: const Text('Tarjeta de Crédito/Débito'),
                  leading: Radio<String>(
                    value: 'card',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) =>
                        setState(() => selectedPaymentMethod = value!),
                  ),
                ),
                ListTile(
                  title: const Text('PayPal'),
                  leading: Radio<String>(
                    value: 'paypal',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) =>
                        setState(() => selectedPaymentMethod = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (selectedPaymentMethod == 'card') ...[
              TextField(
                controller: cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Número de Tarjeta',
                  hintText: '1234 5678 9012 3456',
                ),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expiryController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de Expiración',
                        hintText: 'MM/YY',
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre en la Tarjeta',
                  hintText: 'Juan Pérez',
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.paypal, color: Colors.blue),
                    SizedBox(width: 12),
                    Text('Serás redirigido a PayPal para completar el pago'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: isProcessing ? null : _processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
          ),
          child: isProcessing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Pagar'),
        ),
      ],
    );
  }
}
