import 'package:flame_oxygen/flame_oxygen.dart';
import 'package:flutter/material.dart';
import 'package:game_test/ecs/component/sprite_animation.dart';

class SpriteAnimationSystem extends BaseSystem with UpdateSystem {
  @override
  List<Filter<Component>> get filters => [Has<SpriteAnimationComponent>()];

  @override
  void renderEntity(Canvas canvas, Entity entity) {
    final size = entity.get<SizeComponent>()!.size;
    final animations = entity.get<SpriteAnimationComponent>()!.animations;

    animations?.ticker?.getSprite().render(canvas, size: size);
  }

  @override
  void update(double delta) {
    for (final entity in entities) {
      entity.get<SpriteAnimationComponent>()!.animations?.update(delta);
    }
  }
}
