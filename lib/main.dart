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
      title: 'Libélula · Confirmación de asistencia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kBlue),
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LandingPage(),
    );
  }
}

// ── Paleta azul / blanco ──────────────────────────────────────────────
const Color kBlue = Color(0xFF1565C0);
const Color kBlueMid = Color(0xFF1E88E5);
const Color kBlueLight = Color(0xFFE3F2FD);
const Color kWhite = Colors.white;
const Color kInk = Color(0xFF0D1B2A);
const Color kMuted = Color(0xFF607D8B);

// ── Landing Page ──────────────────────────────────────────────────────
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _nameError = false;
  double _parallaxOffset = 0;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _scrollCtrl.addListener(() {
      if (mounted) setState(() => _parallaxOffset = _scrollCtrl.offset * 0.35);
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _scrollCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    final nombre = _nameCtrl.text.trim();
    if (nombre.isEmpty) {
      setState(() => _nameError = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _nameError = false);
      });
      return;
    }
    final msg = Uri.encodeComponent(
      '¡Hola! Soy *$nombre* y confirmo mi asistencia a la '
      'Clausura del Programa de Educación Emocional — Proyecto Libélula\n'
      'Fecha: Lunes 22 de junio 2026 · 1:30 pm',
    );
    final uri = Uri.parse('https://wa.me/573118888534?text=$msg');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Stack(
        children: [
          const _BackgroundOrbs(),
          const ParticlesLayer(),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                controller: _scrollCtrl,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // PARALLAX HERO
                        _ParallaxHero(offset: _parallaxOffset),
                        // BRAND BAR
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: _BrandBar(),
                        ),
                        // TÍTULO
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          child: Column(
                            children: [
                              const _ChipTag(label: '✦  Evento especial'),
                              const SizedBox(height: 14),
                              const Text(
                                'Proyecto Libélula',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  color: kBlue,
                                  height: 1.05,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Clausura del Programa de Educación Emocional',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: kMuted,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const _BlueDivider(),
                        const SizedBox(height: 22),
                        // CARD
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _InvitationCard(
                            nameCtrl: _nameCtrl,
                            nameError: _nameError,
                            onConfirm: _confirmar,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // PATROCINADORES
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: _PatrocinadoresSection(),
                        ),
                        const SizedBox(height: 24),
                        // FOOTER
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: _FooterBanner(),
                        ),
                        const SizedBox(height: 28),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 24),
                          child: Text(
                            'Proyecto Libélula · 2026',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: kMuted,
                              letterSpacing: 1,
                            ),
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

// ── Parallax Hero ─────────────────────────────────────────────────────
class _ParallaxHero extends StatelessWidget {
  const _ParallaxHero({required this.offset});
  final double offset;
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height * 0.45;
    return SizedBox(
      height: h,
      child: ClipRect(
        child: OverflowBox(
          maxHeight: h + 120,
          child: Transform.translate(
            offset: Offset(0, -offset),
            child: Image.asset(
              'assets/landscape2.jpeg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: h + 120,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Brand Bar ─────────────────────────────────────────────────────────
class _BrandBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _logoBox('assets/logo1.jpeg', 72 * 2),
        const SizedBox(width: 14),
        _logoBox('assets/logo2.jpeg', 54),
        const Spacer(),
        const Text(
          'Clausura · 2026',
          style: TextStyle(
            color: kMuted,
            fontSize: 12,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _logoBox(String asset, double h) {
    return Container(
      height: h,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBlueLight),
        boxShadow: [
          BoxShadow(
            color: kBlue.withOpacity(0.10),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(asset, fit: BoxFit.contain),
    );
  }
}

// ── Chip tag ──────────────────────────────────────────────────────────
class _ChipTag extends StatelessWidget {
  const _ChipTag({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        color: kBlueLight,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: kBlueMid.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          letterSpacing: 2.5,
          color: kBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Divisor azul ──────────────────────────────────────────────────────
class _BlueDivider extends StatelessWidget {
  const _BlueDivider();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, kBlueMid.withOpacity(0.4)],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text('🪲', style: TextStyle(fontSize: 20)),
          ),
          Expanded(
            child: Container(
              height: 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kBlueMid.withOpacity(0.4), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card de invitación ────────────────────────────────────────────────
class _InvitationCard extends StatelessWidget {
  const _InvitationCard({
    required this.nameCtrl,
    required this.nameError,
    required this.onConfirm,
  });
  final TextEditingController nameCtrl;
  final bool nameError;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kBlue.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: kBlue.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen interior (landscape original)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/landscape.jpeg',
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 22),

          // Texto de invitación
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: kBlueLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Estimado equipo,',
                  style: TextStyle(
                    color: kBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Es un gusto invitarlos a la clausura del Programa de '
                  'Educación Emocional realizado con los pacientes y cuidadores '
                  'del Proyecto Libélula.\n\n'
                  'Queremos compartir los avances de este proceso y nos '
                  'encantaría contar con su presencia en el evento de cierre.',
                  style: TextStyle(color: kInk, fontSize: 14, height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Detalles
          const _EventDetail(
            icon: '📅',
            label: 'Fecha',
            value: 'Lunes 22 de junio 2026',
          ),
          const SizedBox(height: 10),
          const _EventDetail(
            icon: '🕐',
            label: 'Hora',
            value: '1:30 pm – 4:00 pm',
          ),
          const SizedBox(height: 10),
          const _EventDetail(
            icon: '📍',
            label: 'Lugar',
            value: 'Auditorio 2° piso · Hospital de Bosa\n(Cl. 73 Sur #KR 103)',
          ),
          const SizedBox(height: 20),

          // Deadline
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFECB3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFFB300).withOpacity(0.5),
              ),
            ),
            child: const Row(
              children: [
                Text('⏰', style: TextStyle(fontSize: 18)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Por favor confirme asistencia antes del 5 de junio 2026',
                    style: TextStyle(
                      color: Color(0xFF7B4F00),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Campo nombre
          const Text(
            'TU NOMBRE',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 2.5,
              color: kBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nameCtrl,
            style: const TextStyle(color: kInk, fontSize: 16),
            onSubmitted: (_) => onConfirm(),
            decoration: InputDecoration(
              hintText: '¿Cómo te llamas?',
              hintStyle: const TextStyle(color: kMuted),
              filled: true,
              fillColor: kBlueLight.withOpacity(0.5),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: nameError
                      ? const Color(0xFFE05C5C)
                      : kBlueMid.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kBlue, width: 1.8),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Botón
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: onConfirm,
              icon: const Icon(
                Icons.chat_rounded,
                size: 20,
                color: Colors.white,
              ),
              label: const Text(
                'Confirmar asistencia',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kBlue,
                foregroundColor: kWhite,
                elevation: 6,
                shadowColor: kBlue.withOpacity(0.4),
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

// ── Event detail row ──────────────────────────────────────────────────
class _EventDetail extends StatelessWidget {
  const _EventDetail({
    required this.icon,
    required this.label,
    required this.value,
  });
  final String icon, label, value;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, height: 1.5),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(color: kMuted),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: kInk,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Patrocinadores ────────────────────────────────────────────────────
class _PatrocinadoresSection extends StatelessWidget {
  const _PatrocinadoresSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kBlueLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBlueMid.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Text(
            'PATROCINADORES',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 3,
              color: kBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/patrocinadores1.jpeg',
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/patrocinadores2.jpeg',
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Footer banner ─────────────────────────────────────────────────────
class _FooterBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        'assets/footer.jpeg',
        width: double.infinity,

        height: 120,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

// ── Fondo orbs ───────────────────────────────────────────────────────
class _BackgroundOrbs extends StatelessWidget {
  const _BackgroundOrbs();
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Container(color: kWhite),
          _orb(-100, null, -80, null, 260),
          _orb(400, null, null, -100, 200),
          _orb(null, 80, -60, null, 180),
        ],
      ),
    );
  }

  Widget _orb(
    double? top,
    double? bottom,
    double? right,
    double? left,
    double size,
  ) {
    return Positioned(
      top: top,
      bottom: bottom,
      right: right,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [kBlueLight, Colors.transparent]),
        ),
      ),
    );
  }
}

// ── Partículas ────────────────────────────────────────────────────────
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
    for (int i = 0; i < 18; i++) _particles.add(_Particle.random(_rng));
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _ctrl.addListener(() {
      if (mounted)
        setState(() {
          for (var p in _particles) p.update();
        });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _ParticlesPainter(_particles),
    child: const SizedBox.expand(),
  );
}

class _Particle {
  double x, y, size, speed, opacity, angle, drift;
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.angle,
    required this.drift,
  });
  factory _Particle.random(Random rng) => _Particle(
    x: rng.nextDouble(),
    y: rng.nextDouble(),
    size: rng.nextDouble() * 7 + 5, // 5–12 px
    speed: rng.nextDouble() * 0.0015 + 0.0006,
    opacity: rng.nextDouble() * 0.35 + 0.12,
    angle: rng.nextDouble() * 2 * pi,
    drift: (rng.nextDouble() - 0.5) * 0.0006,
  );
  void update() {
    y -= speed;
    x += drift;
    angle += 0.03;
    if (y < -0.05) {
      y = 1.05;
      x = Random().nextDouble();
    }
    if (x < -0.05) x = 1.05;
    if (x > 1.05) x = -0.05;
  }
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlesPainter(this.particles);

  // Dibuja una libélula minimalista centrada en (0,0) de tamaño ~1
  void _drawDragonfly(Canvas canvas, Paint bodyPaint, Paint wingPaint) {
    // cuerpo
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-0.08, -0.5, 0.16, 1.0),
        const Radius.circular(0.08),
      ),
      bodyPaint,
    );
    // alas superiores (2 elipses)
    canvas.drawOval(const Rect.fromLTWH(-0.7, -0.55, 0.62, 0.28), wingPaint);
    canvas.drawOval(const Rect.fromLTWH(0.08, -0.55, 0.62, 0.28), wingPaint);
    // alas inferiores
    canvas.drawOval(const Rect.fromLTWH(-0.55, -0.22, 0.47, 0.22), wingPaint);
    canvas.drawOval(const Rect.fromLTWH(0.08, -0.22, 0.47, 0.22), wingPaint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final cx = p.x * size.width;
      final cy = p.y * size.height;
      final s = p.size;

      final bodyPaint = Paint()
        ..color = kBlue.withOpacity(p.opacity)
        ..style = PaintingStyle.fill;
      final wingPaint = Paint()
        ..color = kBlueMid.withOpacity(p.opacity * 0.45)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(p.angle);
      canvas.scale(s);
      _drawDragonfly(canvas, bodyPaint, wingPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter old) => true;
}
