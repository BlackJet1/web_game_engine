import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math.dart';
import 'package:web_game_engine/model/core.dart';
import 'package:web_game_engine/web_game_engine.dart';
import 'package:web_game_engine/game_loop.dart';

class PlayGameWidget extends StatefulWidget {
  const PlayGameWidget({super.key});

  @override
  State<StatefulWidget> createState() => PLayGameState();
}

class PLayGameState extends State<PlayGameWidget> {
  final Loop gameLoop = Loop();

  void render() {
    for (var q = 0; q < 1000; q++) {
      final x1 = Random().nextInt(1280) + 0.0;
      final y1 = Random().nextInt(720) + 0.0;
      final x2 = Random().nextInt(1280) + 0.0;
      final y2 = Random().nextInt(720) + 0.0;
      Engine.addLine(JLine(x1, y1, 0, x2, y2, 0, 1, 1, 1, 1));
    }
  }

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;
    if (key == 'Enter') {}
    return false;
  }

  void update(double delta) {}

  @override
  void initState() {
    ServicesBinding.instance.keyboard.addHandler(_onKey);
    gameLoop.init(720, 1280, render, update);
    super.initState();
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!gameLoop.isAnimation) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {});
      });
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DrawFieldGame(),
        ],
      ),
    );
  }
}

class DrawFieldGame extends StatelessWidget {
  const DrawFieldGame({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipBehavior: Clip.hardEdge,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (e) {
          final dx = e.delta.dx;
          final dy = e.delta.dy;
          Engine.cameras[Engine.currentCamera]
              .moveImmediately(Vector2(-dx * 4, -dy * 4));
        },
        child: SizedBox.expand(
          child: IgnorePointer(
            child: Engine.flutterGlPlugin.isInitialized
                ? HtmlElementView(
                    viewType: Engine.flutterGlPlugin.textureId!.toString())
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }
}
