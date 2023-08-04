import 'package:flame_oxygen/flame_oxygen.dart';
import 'move.dart';
import 'sprite.dart';
import 'sprite_animation.dart';
import 'tiled_map.dart';

registerSystems(World world) {
  world.registerSystem(TiledMapSystem());
  world.registerSystem(SpriteSystem());
  world.registerSystem(MoveSystem());
  world.registerSystem(SpriteAnimationSystem());
}
