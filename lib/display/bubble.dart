import 'package:stagexl/stagexl.dart';
import 'package:ur/display/animator.dart';
import 'dart:async';

class ChatBubble extends Sprite {
  String text;
  ChatBubble(this.text, [String username, int color, Map gains]) {
    int paddingX = 0;
    int paddingY = 0;

    TextField text = new TextField();
    var format = new TextFormat('Lato', 14, Color.Black);
    text.defaultTextFormat = format;
    if (this.text.length > 60) {
      text.width = 250;
    }
    text.wordWrap = true;
    text.text = this.text;
    text.autoSize = TextFieldAutoSize.LEFT;
    text.x = 15;
    text.y = 15;

    TextField usernameField;
    if (username != null) {
      text.y += 20;
      paddingY = 20;
      if (color == null) {
        color = Color.Brown;
      }
      usernameField = new TextField();
      var format = new TextFormat('Fredoka One', 12, color);
      usernameField.defaultTextFormat = format;
      usernameField.text = username + ':';
      usernameField.x = 15;
      usernameField.y = 15;
    }

    Shape back = new Shape();
    back.x = 0;
    back.y = 0;
    back.graphics
        .rectRound(0, 0, text.width + paddingX + 30, text.height + 30 + paddingY, 12, 12);
    back.graphics.fillColor(Color.White);

    Shape nubbin = new Shape();
    nubbin.x = back.width / 2 + 10;
    nubbin.y = back.height - 10;
    nubbin.graphics.rectRound(-15, -15, 30, 30, 3, 3);
    nubbin.graphics.fillColor(Color.White);
    nubbin.rotation = 45;

    addChild(back);
    addChild(nubbin);
    addChild(text);
    if (username != null) {
      addChild(usernameField);
    }

    filters.add(new DropShadowFilter(3, 1.5708, 0x33000000, 3, 3));
    applyCache(-10, -10, width + 10, height + 10);
    scaleX = 0.3;
    scaleY = 0.3;
    pivotX = back.width/2;
    pivotY = back.height;
  }

  open() async {
    Tween tween = new Tween(this, 0.5, Transition.easeOutElastic);
    Animator.juggler.add(tween);
    tween.animate.alpha.to(0.9);
    tween.animate.scaleY.to(1.0);
    tween.animate.scaleX.to(1.0);
    await new Future.delayed(new Duration(milliseconds: 500));
  }

  close() async {
    Tween tween = new Tween(this, 0.5, Transition.easeInElastic);
    Animator.juggler.add(tween);
    tween.animate.alpha.to(0.2);
    tween.animate.scaleY.to(0.5);
    tween.animate.scaleX.to(0.5);
    await new Future.delayed(new Duration(milliseconds: 500));
  }
}
