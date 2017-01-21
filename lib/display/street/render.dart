library ur.render;

import 'dart:html' as html;
import 'dart:math' as Math;
import 'dart:convert';
import 'dart:async';

import 'package:stagexl/stagexl.dart';

part 'animation.dart';
part 'camera.dart';
part 'layers.dart';
part 'street.dart';

// drawables
part 'entities/bubble.dart';
part 'entities/player.dart';
part 'entities/quoin.dart';
part 'entities/signpost.dart';

part 'entities/npc.dart';
// npcs
part 'entities/npc/batterfly.dart';
part 'entities/npc/bundle_of_joy.dart';
part 'entities/npc/bureaucrat.dart';
part 'entities/npc/butterfly.dart';
part 'entities/npc/cactus.dart';
part 'entities/npc/chicken.dart';
part 'entities/npc/cooking_vendor.dart';
part 'entities/npc/crab.dart';
part 'entities/npc/crafty_bot.dart';

abstract class StreetRenderer {
  static Camera camera = new Camera._();
  static html.CanvasElement canvas = html.querySelector('#world');
  static Stage stage = new Stage(canvas, width: 1024, height: 768);
  static Juggler get juggler => stage.juggler;
  static RenderLoop _renderloop = new RenderLoop();
  static ResourceManager resourceManager = new ResourceManager();

  /// Sets up the initial stage variables.
  static init() {
    StageXL.stageOptions
      ..antialias = true
      ..transparent = true
      ..backgroundColor = 0x00000000
      ..stageScaleMode = StageScaleMode.NO_SCALE
      ..stageAlign = StageAlign.TOP_LEFT;
    StageXL.bitmapDataLoadOptions.corsEnabled = true;
    _renderloop.addStage(stage);
  }

  static setStreet(Street street) {
    stage.removeChildren();
    stage.addChild(street);
    Street.current = street;
  }

  static String snap([BitmapFilter filter]) {
      if (filter != null) {
        StreetRenderer.stage.children.first.filters.add(filter);
      }
      StreetRenderer.stage.children.first.applyCache(
          0,
          0,
          StreetRenderer.camera.viewport.width,
          StreetRenderer.camera.viewport.height);
      String dataUrl = new BitmapData.fromRenderTextureQuad(
          StreetRenderer.stage.children.first.cache).toDataUrl();
      if (filter != null) {
        StreetRenderer.stage.children.first.filters.remove(filter);
      }
      StreetRenderer.stage.children.first.removeCache();

      html.window.open(dataUrl, "_blank");
      return dataUrl;
    }
}





abstract class Entity extends Sprite {
  String id;
  Animation animation = new Animation();
  bool showName = false;

  bool hasBubble = false;
  spawnBubble(String text, [username, int color, bool autoDismiss, Map gains]) async {
    if (hasBubble == true) {
      return;
    }
    hasBubble = true;

    num timeToLive =
        (text.length * 0.05) + 2; //minimum 3s plus 0.05 per character
    if (timeToLive > 10) {
      //max 10s
      timeToLive = 10; //messages over 10s will only display for 10s
    }
    ChatBubble cb = new ChatBubble(text, username, color, gains);
    addChild(cb);
    cb.y = -height - bounds.bottom;
    await cb.open();
    if (autoDismiss != false) {
      await new Future.delayed(new Duration(milliseconds: timeToLive * 1000));
      await cb.close();
      removeChild(cb);
      hasBubble = false;
    } else {
      await cb.onMouseClick.first;
      await cb.close();
      removeChild(cb);
      hasBubble = false;
    }
  }


  bool glowing = false;
  static BitmapFilter _glow = new GlowFilter()
    ..color = Color.Goldenrod
    ..quality = 3
    ..blurX = 2
    ..blurY = 2;

  @override
  render(RenderState renderState) {
    if (glowing && !animation.filters.contains(_glow)) {
      animation.filters.add(_glow);
      animation.filters.add(_glow);
      animation.filters.add(_glow);
      animation.filters.add(_glow);
    }
    if (!glowing && animation.filters.contains(_glow)) {
      animation.filters.clear();
    }

    //keep in bounds.
    if (x < Street.current.bounds.left) {
      x = Street.current.bounds.left;
    }
    if (x > Street.current.bounds.right) {
      x = Street.current.bounds.right;
    }
    super.render(renderState);
  }

  Future load();
}
