library render_objects;

import 'dart:convert';
import 'dart:async';
import 'package:stagexl/stagexl.dart';

import 'package:ur/display/bubble.dart';

class Animator extends DisplayObjectContainer{
  String _animation_path;
  Animator(this._animation_path);

  num speed = 1;
  Map<String, FlipBook> state = {};
  String current;

  bool _flipped = false;
  flip() {
    _flipped = !_flipped;
    if (_flipped)
      this.scaleX = -1;
    else
      this.scaleX = 1;
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

  static ResourceManager resources = new ResourceManager();
  static Juggler juggler = new Juggler();

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
          bitmapData.width ~/ animation['width'],
          bitmapData.height ~/ animation['height']);

      animation['animations'].forEach((String name, Map animationData) =>
          _generateAnimation(name, sheet, animationData));
    }
  }

  _generateAnimation(String name, SpriteSheet sheet, Map animationData) {
    List animationFrames = [];
    for (var frame in animationData['frames']) {
      if (frame is int) {
        animationFrames.add(sheet.frames[frame]);
      } else if (frame is List<int>) {
        int i = frame[1] - frame[0];
        if (i.isNegative) {
          for (int j = i.abs(); j > 0; j--) {
            animationFrames.add(sheet.frames[frame[1] + j]);
          }
        } else {
          for (i; i > 0; i--) animationFrames.add(sheet.frames[frame[1] - i]);
        }
      }
    }
    if (animationData['bounce'] == true) {
      animationFrames.addAll(animationFrames.toList().reversed);
    }
    state[name] = new FlipBook(animationFrames);
    state[name]
      ..loop = animationData['loop'] ?? false
      ..setTransform(-state[name].width ~/ 2, -state[name].height);
    juggler.add(state[name]);
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
