import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';

class FlappyBirdScreen extends StatefulWidget {
  const FlappyBirdScreen({super.key});

  @override
  State<FlappyBirdScreen> createState() => _FlappyBirdScreenState();
}

class _FlappyBirdScreenState extends State<FlappyBirdScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration? _lastElapsed;

  // Physics
  double _birdY = 0; // Center-based coordinate in logical game space
  double _velocity = 0; // px/s
  double gravity = 2000; // px/s^2
  double jumpImpulse = -700; // px/s

  // World
  final double pipeWidth = 90;
  double pipeGap = 220; // will adapt based on height
  double worldHeight = 640; // computed via LayoutBuilder
  double worldWidth = 360; // computed via LayoutBuilder
  double birdSize = 36;
  double horizontalSpeed = 230; // px/s

  bool running = false;
  bool gameOver = false;
  int score = 0;

  // Pipes: store x position and gap center Y
  final List<_Pipe> pipes = [];

  // Input buffering for keyboard controls
  bool _pendingFlap = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _resetGame(Size size) {
    worldWidth = size.width;
    worldHeight = size.height;
    pipeGap = math.max(180, size.height * 0.28);
    birdSize = math.max(28, size.shortestSide * 0.05);
    _birdY = 0; // center
    _velocity = 0;
    score = 0;
    gameOver = false;
    running = false;
    _lastElapsed = null;
    pipes
      ..clear()
      ..addAll(_generateInitialPipes());
    setState(() {});
  }

  List<_Pipe> _generateInitialPipes() {
    final List<_Pipe> list = [];
    final count = 3;
    final spacing = worldWidth * 0.7; // distance between pipes
    final start = worldWidth * 1.2; // start off-screen to right
    final rand = math.Random();
    double x = start;
    for (int i = 0; i < count; i++) {
      final gapCenter = _randomGapCenter(rand);
      list.add(_Pipe(x: x, gapCenter: gapCenter));
      x += spacing;
    }
    return list;
  }

  double _randomGapCenter(math.Random rand) {
    final margin = 60 + pipeGap / 2;
    return rand.nextDouble() * (worldHeight - margin * 2) + margin - worldHeight / 2;
  }

  void _onTick(Duration elapsed) {
    // Compute delta time from elapsed since ticker start
    final prev = _lastElapsed;
    _lastElapsed = elapsed;
    if (prev == null) return;
    final seconds = (elapsed - prev).inMicroseconds / 1e6;

    if (!running || gameOver) return;

    setState(() {
      // Apply a buffered flap if queued via keyboard
      if (_pendingFlap) {
        _velocity = jumpImpulse;
        _pendingFlap = false;
      }

      // Update bird
      _velocity += gravity * seconds;
      _birdY += _velocity * seconds;

      // Move pipes
      for (final p in pipes) {
        p.x -= horizontalSpeed * seconds;
      }

      // Recycle pipes and update score
      final recycleX = worldWidth * 1.2;
      final offscreenX = -pipeWidth - 20;
      for (final p in pipes) {
        if (!p.scored && p.x + pipeWidth < worldWidth * 0.3) {
          p.scored = true;
          score += 1;
        }
      }
      if (pipes.isNotEmpty && pipes.first.x < offscreenX) {
        final first = pipes.removeAt(0);
        final lastX = pipes.last.x;
        first
          ..x = math.max(recycleX, lastX + worldWidth * 0.7)
          ..gapCenter = _randomGapCenter(math.Random())
          ..scored = false;
        pipes.add(first);
      }

      // Collisions: ceiling/ground
      final topLimit = -worldHeight / 2 + birdSize / 2;
      final bottomLimit = worldHeight / 2 - birdSize / 2;
      if (_birdY < topLimit || _birdY > bottomLimit) {
        _triggerGameOver();
        return;
      }

      // Collisions with pipes
      final birdX = worldWidth * 0.3; // constant horizontal position
      final birdRect = Rect.fromCenter(
        center: Offset(birdX, _toScreenY(_birdY)),
        width: birdSize,
        height: birdSize,
      );

      for (final p in pipes) {
        final topRect = Rect.fromLTWH(
          p.x,
          0,
          pipeWidth,
          _toScreenY(p.gapCenter) - pipeGap / 2,
        );
        final bottomRect = Rect.fromLTWH(
          p.x,
          _toScreenY(p.gapCenter) + pipeGap / 2,
          pipeWidth,
          worldHeight - (_toScreenY(p.gapCenter) + pipeGap / 2),
        );
        if (topRect.overlaps(birdRect) || bottomRect.overlaps(birdRect)) {
          _triggerGameOver();
          return;
        }
      }
    });
  }

  double _toScreenY(double centerBasedY) => worldHeight / 2 + centerBasedY;

  void _triggerGameOver() {
    gameOver = true;
    running = false;
  }

  void _flap() {
    if (gameOver) return;
    if (!running) {
      running = true;
      _lastElapsed = null;
      _ticker.start();
    }
    setState(() => _velocity = jumpImpulse);
  }

  void _restart(Size size) {
    _ticker.stop();
    _resetGame(size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flappy Bird'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Letterbox into a 9:16-ish area while remaining responsive
          final targetAspect = 9 / 16;
          double w = constraints.maxWidth;
          double h = constraints.maxHeight;
          double gameW = w;
          double gameH = w / targetAspect;
          if (gameH > h) {
            gameH = h;
            gameW = h * targetAspect;
          }
          final size = Size(gameW, gameH);

          // Initialize game world when layout changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!running && !gameOver && pipes.isEmpty) {
              _resetGame(size);
            }
          });

          return FocusableActionDetector(
            autofocus: true,
            shortcuts: const <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
              SingleActivator(LogicalKeyboardKey.arrowUp): ActivateIntent(),
              SingleActivator(LogicalKeyboardKey.keyW): ActivateIntent(),
              SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            },
            actions: <Type, Action<Intent>>{
              ActivateIntent: CallbackAction<Intent>(onInvoke: (intent) {
                if (gameOver) return null;
                if (!running) {
                  running = true;
                  _lastElapsed = null;
                  _ticker.start();
                }
                _pendingFlap = true; // will be consumed on next tick
                return null;
              }),
            },
            child: Center(
              child: SizedBox(
                width: gameW,
                height: gameH,
                child: GestureDetector(
                  onTap: _flap,
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildBackground(context),
                      if (pipes.isNotEmpty) ..._buildPipes(),
                      if (!gameOver) _buildBird(),
                      _buildHud(size),
                      if (!running && !gameOver)
                        _buildCenterOverlay(
                          context,
                          title: 'Tap or press Space to play',
                          subtitle: 'Avoid the pipes and score!',
                          size: size,
                        ),
                      if (gameOver)
                        _buildGameOverOverlay(context, size),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            theme.colorScheme.surface,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPipes() {
    final List<Widget> widgets = [];
    for (final p in pipes) {
      final gapTop = _toScreenY(p.gapCenter) - pipeGap / 2;
      widgets.add(Positioned(
        left: p.x,
        top: 0,
        width: pipeWidth,
        height: gapTop,
        child: _PipeWidget(isTop: true),
      ));
      final gapBottom = _toScreenY(p.gapCenter) + pipeGap / 2;
      widgets.add(Positioned(
        left: p.x,
        top: gapBottom,
        width: pipeWidth,
        height: worldHeight - gapBottom,
        child: _PipeWidget(isTop: false),
      ));
    }
    return widgets;
  }

  Widget _buildBird() {
    final birdX = worldWidth * 0.3;
    return Positioned(
      left: birdX - birdSize / 2,
      top: _toScreenY(_birdY) - birdSize / 2,
      width: birdSize,
      height: birdSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.amber.shade700.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.flight, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildHud(Size size) {
    return Positioned(
      top: 12,
      left: 12,
      right: 12,
      child: Row(
        children: [
          _pill(
            child: Row(children: [
              const Icon(Icons.stars, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Text('$score', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ]),
          ),
          const Spacer(),
          _pill(
            child: Row(children: [
              IconButton(
                icon: Icon(running ? Icons.pause : Icons.play_arrow, color: Colors.white),
                onPressed: () {
                  setState(() {
                    if (running) {
                      running = false;
                      _ticker.stop();
                    } else if (!gameOver) {
                      running = true;
                      _lastElapsed = null;
                      _ticker.start();
                    }
                  });
                },
              ),
              const SizedBox(width: 6),
              IconButton(
                icon: const Icon(Icons.restart_alt, color: Colors.white),
                onPressed: () => _restart(size),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _pill({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _buildCenterOverlay(BuildContext context, {required String title, required String subtitle, required Size size}) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay(BuildContext context, Size size) {
    final theme = Theme.of(context);
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          width: math.min(size.width * 0.8, 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Game Over', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Score: $score', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _restart(size),
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Restart'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Pipe {
  _Pipe({required this.x, required this.gapCenter});
  double x;
  double gapCenter; // center-based Y (0 is middle of world)
  bool scored = false;
}

class _PipeWidget extends StatelessWidget {
  const _PipeWidget({required this.isTop});
  final bool isTop;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary.withValues(alpha: 0.95),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTop ? 0 : 8),
          topRight: Radius.circular(isTop ? 0 : 8),
          bottomLeft: Radius.circular(isTop ? 8 : 0),
          bottomRight: Radius.circular(isTop ? 8 : 0),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}
