import 'package:flame_oxygen/flame_oxygen.dart';
import 'package:flutter/rendering.dart';

import '../component/tiled_map.dart';

class TiledMapSystem extends BaseSystem {
  @override
  List<Filter<Component>> get filters => [Has<TiledMapComponent>()];

  // @override
  // void render(Canvas canvas) {
  //   for (final entity in entities) {
  //     entity.get<PositionComponent>()!.position = world!.game.size / 2;
  //   }
  //   super.render(canvas);
  // }

  @override
  void renderEntity(Canvas canvas, Entity entity) async {
    final map = entity.get<TiledMapComponent>()?.map;

    map?.render(canvas);
  }
}
