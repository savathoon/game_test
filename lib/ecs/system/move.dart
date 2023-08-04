import 'package:flame_oxygen/flame_oxygen.dart';
import 'package:game_test/ecs/component/velocity.dart';

class MoveSystem extends System with UpdateSystem {
  Query? _query;

  @override
  void init() {
    _query = createQuery([
      Has<PositionComponent>(),
      Has<VelocityComponent>(),
    ]);
  }

  @override
  void dispose() {
    _query = null;
    super.dispose();
  }

  @override
  void update(double delta) {
    for (final entity in _query?.entities ?? <Entity>[]) {
      final velocity = entity.get<VelocityComponent>()!.velocity;
      entity.get<PositionComponent>()!.position.add(velocity * delta);
    }
  }
}
