import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game_test/ecs/component/all.dart';
import 'package:game_test/ecs/component/sprite_animation.dart';
import 'package:game_test/ecs/component/tiled_map.dart';
import 'package:game_test/ecs/component/velocity.dart';
import 'package:game_test/ecs/system/all.dart';
import 'package:flame/game.dart';
import 'package:flame_oxygen/flame_oxygen.dart';

import '../animation/animation_set.dart';
import '../assets.dart';
import '../controller.dart';
import 'camera.dart';

class EcsGame extends OxygenGame with OxygenCamera, Controller {
  late final Entity map;
  late final Entity rogue;

  @override
  Future<void> init() async {
    registerSystems(world);
    registerComponents(world);

    // Create the map entity
    final mapInit = await loadMap();
    final mapSize = Vector2(mapInit.map.width * mapInit.destTileSize.x,
        mapInit.map.height * mapInit.destTileSize.y);
    map = createEntity(
      position: Vector2.zero(),
      size: mapSize,
    )..add<TiledMapComponent, RenderableTiledMap>(mapInit);

    // Create the rogue player
    final rogueInit = AnimationSet("idle", await loadRogue());
    rogue = createEntity(
      position: Vector2(864, 1000),
      size: Vector2.all(64),
      anchor: Anchor.center,
    )
      ..add<VelocityComponent, Vector2>(Vector2.zero())
      ..add<SpriteAnimationComponent, AnimationSet>(rogueInit);

    // Follow with the camera
    camera.followVector2(rogue.get<PositionComponent>()!.position);
  }

  final double _moveSpeed = 100;

  @override
  onInputChange() {
    final horizontalDirection = (hasInput(GameInput.left) ? -1 : 0) +
        (hasInput(GameInput.right) ? 1 : 0);
    final verticalDirection =
        (hasInput(GameInput.up) ? -1 : 0) + (hasInput(GameInput.down) ? 1 : 0);

    final velocity = rogue.get<VelocityComponent>()!.velocity;

    var animations = rogue.get<SpriteAnimationComponent>()!.animations;
    var flip = rogue.get<FlipComponent>()!;

    velocity.x = horizontalDirection * _moveSpeed;
    velocity.y = 0.5 * verticalDirection * _moveSpeed;

    if (hasInput(GameInput.attack)) {
      //_attackTimer = 1;
      animations?.current = "attack";
      velocity.setZero();
      return;
    }

    if (velocity.x < 0) {
      flip.flipX = true;
    } else if (velocity.x > 0) {
      flip.flipX = false;
    }

    if (velocity.isZero()) {
      animations?.current = "idle";
    } else {
      animations?.current = "walk";
    }
  }
}
