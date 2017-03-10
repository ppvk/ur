library render_objects;

import 'dart:convert';
import 'dart:async';
import 'package:stagexl/stagexl.dart';

import 'package:ur/display/bubble.dart';


class Animator extends DisplayObjectContainer {
  static ResourceManager resources = new ResourceManager();
  static Juggler juggler = new Juggler();

  String _animation_path;
  Animator(this._animation_path);
  num speed = 1;
  Map<String, FlipBook> state = {};
  String current;

  /// Populates the [Animatior] with the included states.
  load() async {
    // Path to JSON file
    resources.addTextFile(_animation_path, _animation_path);
    await resources.load();
    String json = resources.getTextFile(_animation_path);
    List animations = JSON.decode(json);

    for (Map animation in animations) {
      if (!resources.containsBitmapData(animation['image'])) {
        resources.addBitmapData(animation['image'], animation['image']);
        await resources.load();
      }

      BitmapData bitmapData = resources.getBitmapData(animation['image']);
      SpriteSheet sheet = new SpriteSheet(
          bitmapData,
          animation['frame']['width'],
          animation['frame']['height']);
      _generateAnimation(sheet, animation);
    }
  }

  _generateAnimation(SpriteSheet sheet, Map animation) {
    if (!animation.containsKey('animations')) {
      List animationFrames = [];
      for (int i = 0; i < animation['frames']; i++) {
        animationFrames.add(sheet.frames[i]);
      }

      String name = animation['name'];
      state[name] = new FlipBook(animationFrames);
      state[name]
        ..loop = animation['loops'] ?? false
        ..setTransform(-animation['frame']['width'] ~/ 2, -state[name].height);
      juggler.add(state[name]);
      if (animation['flipped'] ?? false) {
        state[name]
          ..scaleX = -1
          ..x = state[name].width ~/2;
      }
    } else {
      animation['animations'].forEach((String name, Map subAnimation) {
        List animationFrames = [];
        for (int i = subAnimation['end'] - subAnimation['start']; i > 0; i--) {
          animationFrames.add(sheet.frames[subAnimation['end'] - i]);
        }

        state[name] = new FlipBook(animationFrames);
        state[name]
          ..loop = subAnimation['loops'] ?? false
          ..setTransform(-state[name].width ~/ 2, -state[name].height);
        juggler.add(state[name]);
        if (subAnimation['flipped'] ?? false) {
          state[name]
            ..scaleX = -1
            ..x = state[name].width/2;
        }
      });
    }
  }

  set(String name) async {
    if (!state.containsKey(name)) {
      throw ('unloaded Animation $name!');
    }
    if (current == name) return;
    children.clear();
    children.add(state[name]);
    for (int i = state[name].frameDurations.length - 1; i >= 0; i--) {
      state[name].frameDurations[i] = 0.033 / speed;
    }
    state[name].gotoAndPlay(0);
    current = name;
    await state[name].onComplete.first;
  }

}


/// This is a mixin for a DisplayObject that glows
class Glowable {
  List filters = [];

  static BitmapFilter _glow = new GlowFilter()
    ..color = Color.Goldenrod
    ..quality = 3
    ..blurX = 2
    ..blurY = 2;

  glow() {
    filters.clear();
    filters.add(_glow);
    filters.add(_glow);
    filters.add(_glow);
    filters.add(_glow);
  }

  stopGlowing() {
    filters.removeWhere((filter) => filter == _glow);
  }
}

/// This is a mixin for spawning chat bubbles over entities
class Talkable {
  say(String text) {
    ChatBubble bubble = new ChatBubble(text);
    Sprite container = this as Sprite;
    container.addChild(bubble);
    bubble.y = -container.height;
    bubble.open();
    new Future.delayed(new Duration(milliseconds: 1500)).then((_) async {
      await bubble.close();
      container.removeChild(bubble);
    });
  }
}
