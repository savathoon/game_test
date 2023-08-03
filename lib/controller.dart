import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum GameInput {
  up,
  down,
  left,
  right,
  attack,
}

mixin Controller on Game implements KeyboardEvents {
  final _keybinds = {
    // Arrow movement
    LogicalKeyboardKey.arrowUp: GameInput.up,
    LogicalKeyboardKey.arrowDown: GameInput.down,
    LogicalKeyboardKey.arrowRight: GameInput.right,
    LogicalKeyboardKey.arrowLeft: GameInput.left,

    // WASD movement
    LogicalKeyboardKey.keyW: GameInput.up,
    LogicalKeyboardKey.keyS: GameInput.down,
    LogicalKeyboardKey.keyA: GameInput.left,
    LogicalKeyboardKey.keyD: GameInput.right,

    // Numpad
    LogicalKeyboardKey.numpad8: GameInput.up,
    LogicalKeyboardKey.numpad2: GameInput.down,
    LogicalKeyboardKey.numpad4: GameInput.left,
    LogicalKeyboardKey.numpad6: GameInput.right,

    // Other actions
    LogicalKeyboardKey.space: GameInput.attack,
  };
  final _multiBinds = {
    // Numpad diagonals
    LogicalKeyboardKey.numpad1: [GameInput.down, GameInput.left],
    LogicalKeyboardKey.numpad3: [GameInput.down, GameInput.right],
    LogicalKeyboardKey.numpad7: [GameInput.up, GameInput.left],
    LogicalKeyboardKey.numpad9: [GameInput.up, GameInput.right],
  };

  var _commands = Set<GameInput>();

  bool hasInput(GameInput input) {
    return _commands.contains(input);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final commands = Set<GameInput>();

    // Determine which logical inputs are active
    for (final kvp in _keybinds.entries) {
      if (keysPressed.contains(kvp.key)) {
        commands.add(kvp.value);
      }
    }
    for (final kvp in _multiBinds.entries) {
      if (keysPressed.contains(kvp.key)) {
        commands.addAll(kvp.value);
      }
    }

    var result = KeyEventResult.ignored;

    // Diff against previous state for up/down events
    for (final cmd in _commands) {
      if (!commands.contains(cmd)) {
        // TODO: keyUp
        result = KeyEventResult.handled;
      }
    }
    for (final cmd in commands) {
      if (!_commands.contains(cmd)) {
        // TODO: keyDown
        result = KeyEventResult.handled;
      }
    }
    _commands = commands;

    return result;
  }
}
