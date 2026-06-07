import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class RubikCubeScreen extends StatefulWidget {
  const RubikCubeScreen({super.key});

  @override
  State<RubikCubeScreen> createState() => _RubikCubeScreenState();
}

class _RubikCubeScreenState extends State<RubikCubeScreen>
    with SingleTickerProviderStateMixin {
  // تمثيل المكعب 3x3x3
  late List<List<List<Color>>> _cube;
  final List<String> _moves = [];
  bool _isSolving = false;
  bool _isScrambling = false;
  String _currentAlgorithm = 'بسيط';
  int _moveCount = 0;
  int _solveTime = 0;
  Timer? _timer;
  int _bestTime = 0;
  bool _isTimerRunning = false;
  double _rotationX = -30;
  double _rotationY = 45;
  double _rotationZ = 0;
  String _statusText = 'مكعب روبيك 3D';

  // ألوان المكعب
  static const Color _blue = Color(0xFF0051A8);
  static const Color _red = Color(0xFFB71234);
  static const Color _green = Color(0xFF009E60);
  static const Color _orange = Color(0xFFFF5800);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _yellow = Color(0xFFFFD500);

  // خوارزميات الحل
  static const Map<String, Map<String, dynamic>> algorithms = {
    'بسيط (مبتدئ)': {
      'difficulty': 'سهل',
      'moves': 120,
      'description': 'طبقة بطبقة - خطوة بخطوة',
    },
    'CFOP (متقدم)': {
      'difficulty': 'متوسط',
      'moves': 56,
      'description': 'Cross - F2L - OLL - PLL',
    },
    'Roux (احترافي)': {
      'difficulty': 'صعب',
      'moves': 48,
      'description': 'كتلة أولى - CMLL - L6E',
    },
    'ZZ (خبير)': {
      'difficulty': 'خبير',
      'moves': 44,
      'description': 'EOLine - Blockbuilding',
    },
    'Kociemba (مثالي)': {
      'difficulty': 'مثالي',
      'moves': 20,
      'description': 'خوارزمية God\'s Number',
    },
  };

  @override
  void initState() {
    super.initState();
    _initCube();
  }

  void _initCube() {
    _cube = List.generate(3, (x) => List.generate(3, (y) => [
      _white, _white, _white,  // وجه أمامي
    ]));
    _resetCube();
  }

  void _resetCube() {
    setState(() {
      _cube = [
        // الوجه الأمامي (أبيض)
        [
          [_white, _white, _white],
          [_white, _white, _white],
          [_white, _white, _white],
        ],
        // الوجه الخلفي (أصفر)
        [
          [_yellow, _yellow, _yellow],
          [_yellow, _yellow, _yellow],
          [_yellow, _yellow, _yellow],
        ],
        // الوجه الأيمن (أحمر)
        [
          [_red, _red, _red],
          [_red, _red, _red],
          [_red, _red, _red],
        ],
        // الوجه الأيسر (برتقالي)
        [
          [_orange, _orange, _orange],
          [_orange, _orange, _orange],
          [_orange, _orange, _orange],
        ],
        // الوجه العلوي (أزرق)
        [
          [_blue, _blue, _blue],
          [_blue, _blue, _blue],
          [_blue, _blue, _blue],
        ],
        // الوجه السفلي (أخضر)
        [
          [_green, _green, _green],
          [_green, _green, _green],
          [_green, _green, _green],
        ],
      ];
      _moves.clear();
      _moveCount = 0;
      _solveTime = 0;
      _statusText = 'مكعب روبيك 3D - مرتب';
      if (_timer != null && _timer!.isActive) {
        _timer!.cancel();
        _isTimerRunning = false;
      }
    });
  }

  void _scrambleCube() {
    if (_isScrambling) return;
    setState(() => _isScrambling = true);

    final random = Random();
    final moves = ['F', "F'", 'R', "R'", 'U', "U'", 'L', "L'", 'B', "B'", 'D', "D'"];
    final scrambleMoves = List.generate(25, (_) => moves[random.nextInt(moves.length)]);

    setState(() {
      _moves.clear();
      _moves.addAll(scrambleMoves);
      _moveCount = scrambleMoves.length;
      _statusText = 'تم الخلط - ابدأ الحل!';
    });

    _startTimer();
    setState(() => _isScrambling = false);
  }

  void _startTimer() {
    if (_isTimerRunning) return;
    _isTimerRunning = true;
    _solveTime = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _solveTime++);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _isTimerRunning = false;
    if (_bestTime == 0 || _solveTime < _bestTime) {
      _bestTime = _solveTime;
    }
  }

  Future<void> _solveCube() async {
    if (_isSolving) return;
    setState(() => _isSolving = true);

    // محاكاة الحل باستخدام الخوارزمية المختارة
    final algo = algorithms[_currentAlgorithm]!;
    final moveCount = algo['moves'] as int;
    final isReversed = _currentAlgorithm == 'Kociemba (مثالي)';

    _statusText = 'جاري الحل باستخدام ${_currentAlgorithm}...';

    for (int i = 0; i < min(moveCount, 60); i++) {
      if (!mounted) break;
      await Future.delayed(const Duration(milliseconds: 100));

      if (isReversed) {
        // Kociemba - عكس حركات الخلط
        if (_moves.isNotEmpty) {
          final lastMove = _moves.removeLast();
          setState(() {
            _moveCount = _moves.length;
            _statusText = 'Kociemba: عكس الحركات... ${_moves.length} متبقي';
          });
        }
      } else {
        // الخوارزميات الأخرى - توليد حركات حل
        setState(() {
          _moves.add('R${i % 2 == 0 ? "" : "'"}');
          _moveCount = _moves.length;
        });
      }
    }

    // إنهاء الحل
    _stopTimer();
    setState(() {
      _isSolving = false;
      _statusText = _solveTime < 60
          ? '🎉 تم الحل! الزمن: ${_solveTime} ثانية'
          : '🎉 تم الحل! الزمن: ${_solveTime ~/ 60}:${_solveTime % 60}';
      _moves.clear();
      _moveCount = 0;
    });
  }

  String _formatTime(int seconds) {
    if (seconds < 60) return '${seconds}ث';
    return '${seconds ~/ 60}:${seconds % 60}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        title: const Text('مكعب روبيك 3D',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B2838),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(_statusText,
                      style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoChip('الحركات', '$_moveCount'),
                      _infoChip('الزمن', _formatTime(_solveTime)),
                      if (_bestTime > 0)
                        _infoChip('الأفضل', _formatTime(_bestTime)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3D Cube Visualization
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
              ),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _rotationY += details.delta.dx;
                    _rotationX -= details.delta.dy;
                    _rotationX = _rotationX.clamp(-90, 90);
                  });
                },
                child: CustomPaint(
                  painter: _RubikCubePainter(
                    rotationX: _rotationX,
                    rotationY: _rotationY,
                    isSolving: _isSolving,
                  ),
                  size: const Size(double.infinity, 300),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Algorithm Selector
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('خوارزمية الحل:',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  ...algorithms.entries.map((algo) {
                    final isSelected = _currentAlgorithm == algo.key;
                    return GestureDetector(
                      onTap: () => setState(() => _currentAlgorithm = algo.key),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.amber.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Colors.amber
                                : Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? Colors.amber : Colors.white24,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(algo.key,
                                  style: TextStyle(
                                    color: isSelected ? Colors.amber : Colors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 13,
                                  )),
                            ),
                            Text(
                              '${algo.value['moves']} حركة',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Control Buttons
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    icon: Icons.shuffle,
                    label: 'خلط',
                    color: Colors.orange,
                    onTap: _scrambleCube,
                    isLoading: _isScrambling,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionButton(
                    icon: Icons.auto_awesome,
                    label: 'حل',
                    color: Colors.green,
                    onTap: _solveCube,
                    isLoading: _isSolving,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionButton(
                    icon: Icons.refresh,
                    label: 'إعادة',
                    color: Colors.redAccent,
                    onTap: _resetCube,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // تحدي السرعة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.withOpacity(0.2), Colors.blue.withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Speed Cubing Challenge',
                            style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        Text(
                          'أفضل وقت: ${_bestTime > 0 ? _formatTime(_bestTime) : "لم تسجل بعد"}',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      color: Colors.amber, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            if (isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            else
              Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ========== 3D Cube Painter ==========
class _RubikCubePainter extends CustomPainter {
  final double rotationX;
  final double rotationY;
  final bool isSolving;

  _RubikCubePainter({
    required this.rotationX,
    required this.rotationY,
    required this.isSolving,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final cubeSize = min(size.width, size.height) * 0.25;
    final gap = 3.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    // تطبيق الدوران ثلاثي الأبعاد
    final matrix = Matrix4.identity()
      ..rotateX(rotationX * pi / 180)
      ..rotateY(rotationY * pi / 180);
    final transformedCenter = Offset(0, 0);

    // رسم المكعبات الصغيرة (3x3x3)
    final colors = [
      const Color(0xFFFFFFFF), // أبيض - أمام
      const Color(0xFFFFD500), // أصفر - خلف
      const Color(0xFFB71234), // أحمر - يمين
      const Color(0xFFFF5800), // برتقالي - يسار
      const Color(0xFF0051A8), // أزرق - فوق
      const Color(0xFF009E60), // أخضر - تحت
    ];

    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        for (int z = -1; z <= 1; z++) {
          final pos = _rotatePoint(
            Offset(x.toDouble(), y.toDouble()),
            rotationX,
            rotationY,
            z.toDouble(),
          );

          final rect = Rect.fromCenter(
            center: Offset(
              pos.dx * (cubeSize + gap),
              pos.dy * (cubeSize + gap),
            ),
            width: cubeSize,
            height: cubeSize,
          );

          // تحديد اللون بناءً على الموقع
          Color faceColor;
          if (z == 1) faceColor = colors[0]; // أمام
          else if (z == -1) faceColor = colors[1]; // خلف
          else if (x == 1) faceColor = colors[2]; // يمين
          else if (x == -1) faceColor = colors[3]; // يسار
          else if (y == -1) faceColor = colors[4]; // فوق
          else faceColor = colors[5]; // تحت

          // رسم المكعب
          final paint = Paint()
            ..color = faceColor
            ..style = PaintingStyle.fill;
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(4)),
            paint,
          );

          // إطار أسود
          final borderPaint = Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5;
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(4)),
            borderPaint,
          );
        }
      }
    }

    canvas.restore();

    // تأثير الانعكاس
    if (!isSolving) {
      final reflectionPaint = Paint()
        ..color = Colors.blueAccent.withOpacity(0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.drawCircle(
        Offset(center.dx, center.dy + cubeSize * 4),
        cubeSize * 2,
        reflectionPaint,
      );
    }
  }

  Offset _rotatePoint(Offset point, double rx, double ry, double z) {
    final radX = rx * pi / 180;
    final radY = ry * pi / 180;

    double x = point.dx;
    double y = point.dy;

    // الدوران حول Y
    final cosY = cos(radY);
    final sinY = sin(radY);
    final newX = x * cosY - z * sinY;
    final newZ = x * sinY + z * cosY;
    x = newX;
    z = newZ;

    // الدوران حول X
    final cosX = cos(radX);
    final sinX = sin(radX);
    final newY = y * cosX - z * sinX;
    z = y * sinX + z * cosX;
    y = newY;

    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant _RubikCubePainter oldDelegate) {
    return oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.isSolving != isSolving;
  }
}
