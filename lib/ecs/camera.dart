import 'package:flutter/widgets.dart';
import 'package:flame/game.dart';
import 'package:flame_oxygen/flame_oxygen.dart';

mixin OxygenCamera on OxygenGame {
  final Camera camera = Camera();

  @override
  void render(Canvas canvas) {
    canvas.save();
    camera.viewport.apply(canvas);
    camera.apply(canvas);
    super.render(canvas);
    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    camera.update(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    camera.handleResize(size);
  }
}
