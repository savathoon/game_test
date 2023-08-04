import 'package:flame_oxygen/flame_oxygen.dart';
import 'package:flame_tiled/flame_tiled.dart';

class TiledMapComponent extends Component<RenderableTiledMap> {
  RenderableTiledMap? map;

  @override
  void init([RenderableTiledMap? initValue]) => map = initValue;

  @override
  void reset() => map = null;
}
