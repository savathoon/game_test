import 'package:flame/game.dart';
import 'package:flame_oxygen/flame_oxygen.dart';
import 'package:flame_tiled/flame_tiled.dart';
import '../../animation/animation_set.dart';
import 'sprite_animation.dart';
import 'tiled_map.dart';
import 'velocity.dart';

registerComponents(World world) {
  world.registerComponent<TiledMapComponent, RenderableTiledMap>(
      TiledMapComponent.new);
  world.registerComponent<VelocityComponent, Vector2>(VelocityComponent.new);
  world.registerComponent<SpriteAnimationComponent, AnimationSet>(
      SpriteAnimationComponent.new);
}
