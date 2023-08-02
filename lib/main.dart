import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' as Widgets;

void main() {
  Widgets.WidgetsFlutterBinding.ensureInitialized();
  final game = DemoGame();
  Widgets.runApp(GameWidget(game: game));
}

class DemoGame extends FlameGame with KeyboardEvents {
  final world = World();
  late final CameraComponent cameraComponent;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _walkAnimation;
  late final SpriteAnimation _attackAnimation;
  late final rogue;

  //move to rogue class
  final double _moveSpeed = 100;
  int _horizontalDirection = 0;
  int _verticalDirection = 0;
  double _attackTimer = 0;
  final Vector2 _velocity = Vector2.zero();
  Vector2 position = Vector2(864, 1000);

  @override
  Future<void>? onLoad() async {
    cameraComponent = CameraComponent(world: world);
    addAll([cameraComponent, world]);

    final contents = await Flame.bundle.loadString(
      'assets/map/demo.tmx',
    );
    final tiledMap = await TiledMap.fromString(
      contents,
      FlameTsxProvider.parse,
    );

    final spriteImage = await images.load('rogue.png');
    final spriteSheet =
        SpriteSheet(image: spriteImage, srcSize: Vector2.all(64));
    world.add(
      TiledComponent(
          await RenderableTiledMap.fromTiledMap(
            tiledMap,
            Vector2(128, 64),
          ),
          position: Vector2(0, 0)),
    );
    // Initialize player animations
    _walkAnimation = spriteSheet.createAnimation(row: 7, stepTime: 0.1);
    _idleAnimation = spriteSheet.createAnimation(row: 5, stepTime: 0.1);
    _attackAnimation = spriteSheet.createAnimation(row: 8, stepTime: 0.1);

    rogue = SpriteAnimationComponent(
        animation: _idleAnimation, position: position, anchor: Anchor.center);

    world.add(rogue);

    cameraComponent.viewfinder.position = Vector2(1264, 1000);
    cameraComponent.viewfinder.zoom = 1;
    cameraComponent.follow(rogue);

    return super.onLoad();
  }

  @override
  Widgets.KeyEventResult onKeyEvent(
    Widgets.RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    final isLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isUp = keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isDown = keysPressed.contains(LogicalKeyboardKey.arrowDown);
    final isAttack = keysPressed.contains(LogicalKeyboardKey.space);

    if (isKeyDown) {
      if (isAttack) {
        _attackTimer = 1;
      } else {
        _horizontalDirection = 0;
        _verticalDirection = 0;
        if (isLeft) {
          _horizontalDirection = -1;
        } else if (isRight) {
          _horizontalDirection = 1;
        }

        if (isUp) {
          _verticalDirection = -1;
        } else if (isDown) {
          _verticalDirection = 1;
        }
      }

      return Widgets.KeyEventResult.handled;
    }
    return Widgets.KeyEventResult.ignored;
  }

  // Credit: @eugene-kleshnin
  // https://hackernoon.com/teaching-your-character-to-run-in-flame
  @override
  void update(double dt) {
    super.update(dt);

    if (_attackTimer <= 0) {
      _velocity.x = _horizontalDirection * _moveSpeed;
      _velocity.y = 0.5 * _verticalDirection * _moveSpeed;
      rogue.position += _velocity * dt;
    }

    if ((_horizontalDirection < 0 && rogue.scale.x > 0) ||
        (_horizontalDirection > 0 && rogue.scale.x < 0)) {
      rogue.flipHorizontally();
    }
    updateAnimation(dt);
  }

  void updateAnimation(double dt) {
    if (_attackTimer > 0) {
      rogue.animation = _attackAnimation;
      _attackTimer -= dt;
    } else if (_horizontalDirection == 0 && _verticalDirection == 0) {
      rogue.animation = _idleAnimation;
    } else {
      rogue.animation = _walkAnimation;
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