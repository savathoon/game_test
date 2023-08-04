import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart' as Widgets;

import 'assets.dart';
import 'controller.dart';

void main() {
  Widgets.WidgetsFlutterBinding.ensureInitialized();
  //final game = EcsGame();
  final game = DemoGame();
  Widgets.runApp(GameWidget(game: game));
}

class DemoGame extends FlameGame with Controller {
  final world = World();
  late final CameraComponent cameraComponent;
  late final Map<String, SpriteAnimation> _animations;
  late final SpriteAnimationComponent rogue;

  //move to rogue class
  final double _moveSpeed = 100;
  double _attackTimer = 0;
  final Vector2 _velocity = Vector2.zero();

  @override
  Future<void>? onLoad() async {
    cameraComponent = CameraComponent(world: world);
    addAll([cameraComponent, world]);

    world.add(TiledComponent(await loadMap()));

    // Initialize player animations
    _animations = await loadRogue();
    rogue = SpriteAnimationComponent(
      animation: _animations["idle"],
      position: Vector2(864, 1000),
      anchor: Anchor.center,
    );

    world.add(rogue);

    cameraComponent.follow(rogue);

    return super.onLoad();
  }

  // Credit: @eugene-kleshnin
  // https://hackernoon.com/teaching-your-character-to-run-in-flame
  @override
  onInputChange() {
    if (hasInput(GameInput.attack)) {
      _attackTimer = 1;
    }

    final horizontalDirection = (hasInput(GameInput.left) ? -1 : 0) +
        (hasInput(GameInput.right) ? 1 : 0);
    final verticalDirection =
        (hasInput(GameInput.up) ? -1 : 0) + (hasInput(GameInput.down) ? 1 : 0);

    _velocity.x = horizontalDirection * _moveSpeed;
    _velocity.y = 0.5 * verticalDirection * _moveSpeed;

    if ((horizontalDirection < 0 && rogue.scale.x > 0) ||
        (horizontalDirection > 0 && rogue.scale.x < 0)) {
      rogue.flipHorizontally();
    }

    updateAnimation();
  }

  void updateAnimation() {
    if (_attackTimer > 0) {
      rogue.animation = _animations["attack"];
    } else if (_velocity.isZero()) {
      rogue.animation = _animations["idle"];
    } else {
      rogue.animation = _animations["walk"];
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_attackTimer > 0) {
      _attackTimer -= dt;
      updateAnimation();
    } else {
      rogue.position += _velocity * dt;
    }
  }
}
  

/** 
class IsometricTileMapExample extends FlameGame with MouseMovementDetector {
  static const String description = '''
    Shows an example of how to use the `IsometricTileMapComponent`.\n\n
    Move the mouse over the board to see a selector appearing on the tiles.
  ''';

  final topLeft = Vector2.all(500);

  static const scale = 1.0;
  static const srcTileHeight = 48.0;
  static const srcTileWidth = 96.0;
  static const destTileHeight = scale * srcTileHeight;
  static const destTileWidth = scale * srcTileWidth;
  static const tileHeight = 48.0;

  final originColor = Paint()..color = const Color(0xFFFF00FF);
  final originColor2 = Paint()..color = const Color(0xFFAA55FF);

  late IsometricTileMapComponent base;
  late Selector selector;

  IsometricTileMapExample();

  @override
  Future<void> onLoad() async {
    final tilesetImage = await images.load('tileset_Full.png');
    final tileset = SpriteSheet(
      image: tilesetImage,
      srcSize: Vector2(srcTileWidth, srcTileHeight),
    );
    final matrix = [[11, 11, 11], [11, 11, 11], [11, 11, 11]];
    add(
      base = IsometricTileMapComponent(
        tileset,
        matrix,
        destTileSize: Vector2(destTileWidth, destTileHeight),
        tileHeight: tileHeight,
        position: topLeft,
      ),
    );

    final selectorImage = await images.load('selector.png');
    add(selector = Selector(destTileHeight, selectorImage));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.renderPoint(topLeft, size: 5, paint: originColor);
    canvas.renderPoint(
      topLeft.clone()..y -= tileHeight,
      size: 5,
      paint: originColor2,
    );
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    final screenPosition = info.eventPosition.game;
    final block = base.getBlock(screenPosition);
    selector.show = base.containsBlock(block);
    selector.position.setFrom(topLeft + base.getBlockRenderPosition(block));
  }
}

class Selector extends SpriteComponent {
  bool show = true;

  Selector(double s, Image image)
      : super(
          sprite: Sprite(image, srcSize: Vector2.all(32.0)),
          size: Vector2.all(s),
        );

  @override
  void render(Canvas canvas) {
    if (!show) {
      return;
    }

    super.render(canvas);
  }
}
*/