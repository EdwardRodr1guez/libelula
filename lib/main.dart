import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const LibelulaApp());
}

class LibelulaApp extends StatelessWidget {
  const LibelulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clausura Proyecto Libélula',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        fontFamily: 'sans-serif',
      ),
      home: const LandingPage(),
    );
  }
}

// ── Colores ────────────────────────────────────────────────────────────
const Color kGold = Color(0xFFC9A84C);
const Color kGoldLight = Color(0xFFE8C97A);
const Color kDark = Color(0xFF0D0D0D);
const Color kDark2 = Color(0xFF1A1A2E);
const Color kTextMuted = Color(0xFFA89F8C);

// ── Landing Page ──────────────────────────────────────────────────────
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  bool _nameError = false;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    final nombre = _nameController.text.trim();
    if (nombre.isEmpty) {
      setState(() => _nameError = true);
      Future.delayed(
        const Duration(seconds: 2),
        () => setState(() => _nameError = false),
      );
      return;
    }
    final msg = Uri.encodeComponent(
      '¡Hola! Soy *$nombre* y confirmo mi asistencia a la Clausura del Proyecto Libélula. 🪲✨',
    );
    final uri = Uri.parse('https://wa.me/573103799897?text=$msg');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDark,
      body: Stack(
        children: [
          // Fondo degradado
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.6, 0),
                radius: 1.2,
                colors: [Color(0xFF1A1A3E), kDark],
              ),
            ),
          ),
          // Partículas
          const ParticlesLayer(),
          // Contenido
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      children: [
                        // Tag
                        _Tag(),
                        const SizedBox(height: 20),
                        // Título
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [kGoldLight, kGold, Color(0xFFA07830)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: const Text(
                            'Proyecto\nLibélula',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ceremonia de Clausura',
                          style: TextStyle(
                            fontSize: 16,
                            color: kTextMuted,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Divisor
                        _GoldDivider(),
                        const SizedBox(height: 28),
                        // Card
                        _InvitationCard(
                          nameController: _nameController,
                          nameError: _nameError,
                          onConfirm: _confirmar,
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Proyecto Libélula · 2026',
                          style: TextStyle(
                            fontSize: 12,
                            color: kTextMuted,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tag de evento ──────────────────────────────────────────────────────
class _Tag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: kGold.withOpacity(0.7)),
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Text(
        '✦  Evento especial',
        style: TextStyle(
          fontSize: 11,
          letterSpacing: 3,
          color: kGold,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ── Divisor dorado ────────────────────────────────────────────────────
class _GoldDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, kGold],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('🪲', style: TextStyle(fontSize: 18)),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [kGold, Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Card de invitación ────────────────────────────────────────────────
class _InvitationCard extends StatelessWidget {
  const _InvitationCard({
    required this.nameController,
    required this.nameError,
    required this.onConfirm,
  });

  final TextEditingController nameController;
  final bool nameError;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: kGold.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kGold.withOpacity(0.06),
            blurRadius: 60,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder de imagen
          _HeroImagePlaceholder(),
          const SizedBox(height: 24),
          // Info del evento
          _EventRow(icon: '📅', label: 'Próximamente', value: '2026'),
          const SizedBox(height: 10),
          _EventRow(icon: '📍', label: 'Lugar', value: 'Por confirmar'),
          const SizedBox(height: 10),
          _EventRow(icon: '🕐', label: 'Hora', value: 'Por confirmar'),
          const SizedBox(height: 28),
          // Label
          const Text(
            'TU NOMBRE',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 2.5,
              color: kGold,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          // Input
          TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            onSubmitted: (_) => onConfirm(),
            decoration: InputDecoration(
              hintText: '¿Cómo te llamas?',
              hintStyle: const TextStyle(color: kTextMuted),
              filled: true,
              fillColor: Colors.white.withOpacity(0.06),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: nameError
                      ? const Color(0xFFE05C5C)
                      : kGold.withOpacity(0.25),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kGold, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Botón
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: onConfirm,
              icon: const _WhatsAppIcon(),
              label: const Text(
                'Confirmar asistencia',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kGold,
                foregroundColor: const Color(0xFF1A1200),
                elevation: 8,
                shadowColor: kGold.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero image placeholder ────────────────────────────────────────────
class _HeroImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kGold.withOpacity(0.3),
          style: BorderStyle.solid,
        ),
      ),
      // Para usar tu imagen, reemplaza este child por:
      // child: ClipRRect(
      //   borderRadius: BorderRadius.circular(16),
      //   child: Image.asset('assets/hero.jpg', fit: BoxFit.cover),
      // ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🖼️', style: TextStyle(fontSize: 40)),
          SizedBox(height: 8),
          Text(
            'Agrega tu imagen aquí',
            style: TextStyle(color: kTextMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ── Fila de info del evento ───────────────────────────────────────────
class _EventRow extends StatelessWidget {
  const _EventRow(
      {required this.icon, required this.label, required this.value});
  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(color: kTextMuted, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// ── Ícono WhatsApp ────────────────────────────────────────────────────
class _WhatsAppIcon extends StatelessWidget {
  const _WhatsAppIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 20),
      painter: _WhatsAppPainter(),
    );
  }
}

class _WhatsAppPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1200)
      ..style = PaintingStyle.fill;
    final path = Path();
    // Círculo exterior
    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        size.width / 2, paint);
    final innerPaint = Paint()
      ..color = kGold
      ..style = PaintingStyle.fill;
    // Burbuja de chat simplificada
    path.addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width * 0.38));
    canvas.drawPath(path, innerPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Capa de partículas ────────────────────────────────────────────────
class ParticlesLayer extends StatefulWidget {
  const ParticlesLayer({super.key});

  @override
  State<ParticlesLayer> createState() => _ParticlesLayerState();
}

class _ParticlesLayerState extends State<ParticlesLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final List<_Particle> _particles = [];
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 20; i++) {
      _particles.add(_Particle.random(_rng));
    }
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _ctrl.addListener(() {
      setState(() {
        for (var p in _particles) {
          p.update();
        }
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlesPainter(_particles),
      child: const SizedBox.expand(),
    );
  }
}

class _Particle {
  double x, y, size, speed, opacity;
  _Particle(
      {required this.x,
      required this.y,
      required this.size,
      required this.speed,
      required this.opacity});

  factory _Particle.random(Random rng) => _Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        size: rng.nextDouble() * 3 + 1.5,
        speed: rng.nextDouble() * 0.002 + 0.0008,
        opacity: rng.nextDouble() * 0.5 + 0.1,
      );

  void update() {
    y -= speed;
    if (y < -0.02) y = 1.02;
  }
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlesPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = kGoldLight.withOpacity(p.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
          Offset(p.x * size.width, p.y * size.height), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter old) => true;
}

