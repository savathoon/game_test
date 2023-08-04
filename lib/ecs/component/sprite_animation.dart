import 'package:flame_oxygen/flame_oxygen.dart';

import '../../animation/animation_set.dart';

class SpriteAnimationComponent extends Component<AnimationSet> {
  AnimationSet? animations;

  @override
  void init([AnimationSet? initValue]) => animations = initValue;

  @override
  void reset() => animations = null;
}
