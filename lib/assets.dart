import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';

Future<RenderableTiledMap> loadMap() async {
  return await RenderableTiledMap.fromFile("demo.tmx", Vector2(128, 64));
}

Future<Map<String, SpriteAnimation>> loadRogue() async {
  final spriteImage = await Flame.images.load('rogue.png');
  final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2.all(64));

  return {
    "idle": spriteSheet.createAnimation(row: 5, stepTime: 0.1),
    "walk": spriteSheet.createAnimation(row: 7, stepTime: 0.1),
    "attack": spriteSheet.createAnimation(row: 8, stepTime: 0.1),
  };
}
