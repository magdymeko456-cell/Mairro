import 'package:flutter/material.dart';
import 'dart:async';
import 'package:chess/chess.dart' as chess_lib;
import 'package:stockfish/stockfish.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class ChessScreen extends StatefulWidget {
  const ChessScreen({super.key});

  @override
  State<ChessScreen> createState() => _ChessScreenState();
}

class _ChessScreenState extends State<ChessScreen>
    with SingleTickerProviderStateMixin {
  late ChessBoardController _boardController;
  late Stockfish _stockfish;
  bool _isThinking = false;
  bool _isEngineReady = false;
  String _statusText = 'جاري تجهيز محرك الشطرنج...';
  String _lastMove = '';
  int _moveCount = 0;
  int _blackWins = 0;
  int _whiteWins = 0;
  int _draws = 0;
  late AnimationController _animController;
  late Animation<double> _thinkingAnim;
  bool _is3DView = true;
  String _difficulty = 'متوسط';
  final List<String> _difficulties = ['سهل', 'متوسط', 'صعب', 'خبير'];

  @override
  void initState() {
    super.initState();
    _boardController = ChessBoardController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _thinkingAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _initEngine();
  }

  Future<void> _initEngine() async {
    try {
      _stockfish = Stockfish();
      await _stockfish.init();
      // تعيين مستوى الصعوبة
      await _setDifficulty();
      setState(() {
        _isEngineReady = true;
        _statusText = 'محرك Stockfish جاهز - دورك';
      });
      _boardController.addListener(_onBoardChanged);
    } catch (e) {
      debugPrint('Stockfish init error: $e');
      setState(() {
        _statusText = 'محرك AI غير متاح - العب مع صديق';
        _isEngineReady = false;
      });
    }
  }

  Future<void> _setDifficulty() async {
    if (!_isEngineReady) return;
    switch (_difficulty) {
      case 'سهل':
        await _stockfish.sendCommand('setoption name Skill Level value 1');
        await _stockfish.sendCommand('setoption name UCI_LimitStrength value true');
        await _stockfish.sendCommand('setoption name UCI_Elo value 800');
        break;
      case 'متوسط':
        await _stockfish.sendCommand('setoption name Skill Level value 5');
        await _stockfish.sendCommand('setoption name UCI_LimitStrength value true');
        await _stockfish.sendCommand('setoption name UCI_Elo value 1500');
        break;
      case 'صعب':
        await _stockfish.sendCommand('setoption name Skill Level value 15');
        await _stockfish.sendCommand('setoption name UCI_LimitStrength value false');
        break;
      case 'خبير':
        await _stockfish.sendCommand('setoption name Skill Level value 20');
        await _stockfish.sendCommand('setoption name UCI_LimitStrength value false');
        break;
    }
  }

  void _onBoardChanged() {
    if (!_isEngineReady || _isThinking) return;
    final game = _boardController.game;
    if (game.isCheckmate) {
      setState(() {
        _statusText = '👑 كش مات!';
        if (game.turn == chess_lib.Color.WHITE) {
          _blackWins++;
        } else {
          _whiteWins++;
        }
      });
      return;
    }
    if (game.isStalemate || game.isDraw) {
      setState(() {
        _statusText = '🤝 تعادل';
        _draws++;
      });
      return;
    }
    _moveCount = game.fullMoves;
    setState(() => _statusText = 'دور الكمبيوتر...');
    _makeEngineMove();
  }

  Future<void> _makeEngineMove() async {
    if (!_isEngineReady) return;
    setState(() => _isThinking = true);
    try {
      final fen = _boardController.game.fen;
      await _stockfish.sendCommand('position fen $fen');
      await _stockfish.sendCommand('go movetime 1000');
      await Future.delayed(const Duration(milliseconds: 500));
      final bestMove = await _stockfish.sendCommand('bestmove');
      if (bestMove.startsWith('bestmove') && bestMove.length > 9) {
        final move = bestMove.split(' ')[1];
        _boardController.makeMoveFromUCI(move);
        setState(() {
          _lastMove = move;
          _statusText = 'دورك - مستوى: $_difficulty';
        });
      }
    } catch (e) {
      debugPrint('Engine move error: $e');
    }
    setState(() => _isThinking = false);
  }

  void _resetGame() {
    _boardController.resetBoard();
    setState(() {
      _lastMove = '';
      _statusText = 'لعبة جديدة - دورك';
      _moveCount = 0;
    });
    _animController.forward(from: 0);
  }

  void _undoMove() {
    _boardController.undo();
  }

  @override
  void dispose() {
    _boardController.removeListener(_onBoardChanged);
    _boardController.dispose();
    _stockfish.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        title: const Text('شطرنج 3D - محرك Stockfish',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B2838),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
                _is3DView ? Icons.view_in_ar : Icons.view_comfy,
                color: Colors.amber),
            onPressed: () => setState(() => _is3DView = !_is3DView),
            tooltip: 'تبديل المنظر 2D/3D',
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: const Color(0xFF1B2838),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _statusText,
                    style: TextStyle(
                      color: _isThinking ? Colors.amber : Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (_isThinking)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: _thinkingAnim.value,
                      color: Colors.amber,
                    ),
                  ),
                const SizedBox(width: 10),
                Text('الحركة: $_moveCount',
                    style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),

          // Difficulty Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                const Text('المستوى: ', style: TextStyle(color: Colors.white54)),
                DropdownButton<String>(
                  value: _difficulty,
                  dropdownColor: const Color(0xFF1B2838),
                  style: const TextStyle(color: Colors.amber, fontSize: 14),
                  underline: const SizedBox(),
                  items: _difficulties.map((d) => DropdownMenuItem(
                    value: d,
                    child: Text(d, style: const TextStyle(color: Colors.white)),
                  )).toList(),
                  onChanged: (v) {
                    setState(() => _difficulty = v!);
                    _setDifficulty();
                    _resetGame();
                  },
                ),
                const Spacer(),
                // Score
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      _scoreChip('⬜', _whiteWins, Colors.white),
                      const SizedBox(width: 8),
                      _scoreChip('⬛', _blackWins, Colors.black87),
                      const SizedBox(width: 8),
                      _scoreChip('🤝', _draws, Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Chess Board
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ChessBoard(
                  controller: _boardController,
                  boardColor: BoardColor.brown,
                  boardOrientation: BoardOrientation.white,
                  size: MediaQuery.of(context).size.width - 40,
                  enableUserMoves: !_isThinking,
                  pieceSet: PieceSet.merida,
                  showLegalMoves: true,
                  dragFeedback: true,
                ),
              ),
            ),
          ),

          // Control Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _controlButton(Icons.undo, 'رجوع', _undoMove),
                _controlButton(Icons.refresh, 'لعبة جديدة', _resetGame),
                _controlButton(
                  Icons.swap_horiz,
                  'تبديل الألوان',
                  () => _boardController.boardOrientation == BoardOrientation.white
                      ? _boardController.boardOrientation = BoardOrientation.black
                      : _boardController.boardOrientation = BoardOrientation.white,
                ),
              ],
            ),
          ),

          // Last Move
          if (_lastMove.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'آخر حركة: $_lastMove',
                style: TextStyle(
                    color: Colors.amber.withOpacity(0.7), fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }

  Widget _scoreChip(String label, int score, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text('$label $score',
          style: TextStyle(color: bgColor, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _controlButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent.withOpacity(0.3), Colors.purpleAccent.withOpacity(0.2)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
