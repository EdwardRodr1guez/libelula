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
const Color kBackground = Color(0xFFF7F2E8);
const Color kSurface = Color(0xFFFFFDF8);
const Color kInk = Color(0xFF2B2620);
const Color kTextMuted = Color(0xFF7E7668);

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
    final uri = Uri.parse('https://wa.me/573118888534?text=$msg');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFFBF4), kBackground],
              ),
            ),
          ),
          const _SoftOrbs(),
          const ParticlesLayer(),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      children: [
                        const _BrandBar(),
                        const SizedBox(height: 18),
                        _HeroDetailImage(),
                        const SizedBox(height: 18),
                        _Tag(),
                        const SizedBox(height: 16),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFFB8892C), kGold, Color(0xFF6E531A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: const Text(
                            'Proyecto\nLibélula',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 54,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.05,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ceremonia de Clausura',
                          style: TextStyle(
                            fontSize: 16,
                            color: kTextMuted,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _GoldDivider(),
                        const SizedBox(height: 22),
                        _InvitationCard(
                          nameController: _nameController,
                          nameError: _nameError,
                          onConfirm: _confirmar,
                        ),
                        const SizedBox(height: 18),
                        const _FooterBanner(),
                        const SizedBox(height: 18),
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
        color: Colors.white.withOpacity(0.72),
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
        color: kSurface.withOpacity(0.96),
        border: Border.all(color: kGold.withOpacity(0.22)),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kGold.withOpacity(0.10),
            blurRadius: 50,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LogoStrip(),
          const SizedBox(height: 18),
          _HeroDetailImage(),
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
            style: const TextStyle(color: kInk, fontSize: 16),
            onSubmitted: (_) => onConfirm(),
            decoration: InputDecoration(
              hintText: '¿Cómo te llamas?',
              hintStyle: const TextStyle(color: kTextMuted),
              filled: true,
              fillColor: const Color(0xFFFFFCF8),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: nameError
                      ? const Color(0xFFE05C5C)
                      : kGold.withOpacity(0.28),
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

// ── Hero image y logos ────────────────────────────────────────────────
class _HeroDetailImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kGold.withOpacity(0.22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/landscape.jpeg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

class _BrandBar extends StatelessWidget {
  const _BrandBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MiniLogo(asset: 'assets/logo1.jpeg'),
        const SizedBox(width: 12),
        _MiniLogo(asset: 'assets/logo2.jpeg'),
        const Spacer(),
        const Text(
          'Clausura',
          style: TextStyle(
            color: kTextMuted,
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _LogoStrip extends StatelessWidget {
  const _LogoStrip();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _MiniLogo(asset: 'assets/logo1.jpeg', height: 68)),
        SizedBox(width: 12),
        Expanded(child: _MiniLogo(asset: 'assets/logo2.jpeg', height: 68)),
      ],
    );
  }
}

class _MiniLogo extends StatelessWidget {
  const _MiniLogo({required this.asset, this.height = 42});

  final String asset;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGold.withOpacity(0.16)),
      ),
      child: Image.asset(asset, fit: BoxFit.contain),
    );
  }
}

class _FooterBanner extends StatelessWidget {
  const _FooterBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kGold.withOpacity(0.16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/footer.jpeg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
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
              color: kInk, fontSize: 14, fontWeight: FontWeight.w600),
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
        ..color = kGold.withOpacity(p.opacity * 0.20)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
          Offset(p.x * size.width, p.y * size.height), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter old) => true;
}

class _SoftOrbs extends StatelessWidget {
  const _SoftOrbs();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -40,
            child: _orb(180),
          ),
          Positioned(
            top: 220,
            left: -70,
            child: _orb(140),
          ),
        ],
      ),
    );
  }

  Widget _orb(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [kGold.withOpacity(0.18), Colors.transparent],
        ),
      ),
    );
  }
}

