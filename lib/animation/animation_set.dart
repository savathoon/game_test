import 'package:flame/sprite.dart';

class AnimationSet {
  AnimationSet(this._current, Map<String, SpriteAnimation> animations)
      : _tickers =
            animations.map((key, value) => MapEntry(key, value.createTicker()));

  String _current;
  final Map<String, SpriteAnimationTicker> _tickers;

  String get current => _current;
  set current(String value) {
    final prevTicker = ticker;
    _current = value;

    if (prevTicker != ticker) {
      prevTicker?.reset();
    }
  }

  SpriteAnimationTicker? get ticker => _tickers[_current];

  update(double dt) {
    ticker?.update(dt);
  }
}
