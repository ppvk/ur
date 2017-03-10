import 'package:stagexl/stagexl.dart';
import 'package:ur/display/animator.dart';
import 'dart:async';


class QuoinSprite extends Sprite {
  Animator icon = new Animator('packages/ur/assets/quoin/quoin.json');
  QuoinRing ring;
  int value = 1;
  String type = 'none';

  QuoinSprite(this.type, this.value) {
    onMouseClick.listen((_) {
      if (collected) {
        reset();
      } else {
        pop();
      }
    });
  }

  bool disabled = false;
  bool collected = false;

  pop() async {
    collected = true;
    Tween fade = new Tween(icon, 0.25, Transition.easeInOutQuadratic);
    Animator.juggler.add(fade);
    fade.animate.alpha.to(0.1);
    await ring.pop();
  }

  reset() async {
    collected = false;
    Tween fade = new Tween(icon, 0.5, Transition.easeInOutQuadratic);
    Animator.juggler.add(fade);
    fade.animate.alpha.to(1);
  }

  load() async {
    await icon.load();
    icon.speed = 0.8;
    icon.set(type);
    ring = new QuoinRing('+$value $type');
    addChild(ring);
    addChild(icon);
  }
}


class QuoinRing extends Sprite {
  Shape ring;
  TextField text;
  QuoinRing(String message) {
    ring = new Shape();
    ring.graphics.circle(0,0,30);
    ring.graphics.strokeColor(0xFFFFFFFF, 3);
    ring.graphics.fillColor(0x44FFFFFF);
    ring.applyCache(-35, -35, (35)*2, (35)*2);
    ring.y -= 20;

    text = new TextField();
    var format = new TextFormat('Fredoka One', 32, 0xFFFFFFFF, align:TextFormatAlign.CENTER);
    text.defaultTextFormat = format;
    text.text = message;
    text.width = 600;
    text.filters.add(
      new DropShadowFilter(5, 1.5708, 0x55000000, 5, 5)
    );
    text.applyCache(-20, -20, text.width + 20, text.height + 20);
    text.pivotX = text.width/2;
    text.pivotY = text.height/2 - 20;
    text.y = -10;
    text.scaleX = 0;
    text.scaleY = 0;
    ring.scaleX = 0;
    ring.scaleY = 0;
    addChild(ring);
    addChild(text);
  }

  open() async {
    Tween textTween = new Tween(text, 0.9, Transition.easeInOutElastic);
    Animator.juggler.add(textTween);
    textTween.animate.scaleY.to(1.0);
    textTween.animate.scaleX.to(1.0);
    await new Future.delayed(new Duration(milliseconds: 100));

    Tween ringTween = new Tween(ring, 0.9, Transition.easeInOutElastic);
    Animator.juggler.add(ringTween);
    ringTween.animate.scaleY.to(1.0);
    ringTween.animate.scaleX.to(1.0);
    await new Future.delayed(new Duration(milliseconds: 250));
  }
  close() async {
    Tween ringTween = new Tween(ring, 0.9, Transition.easeInOutElastic);
    Animator.juggler.add(ringTween);
    ringTween.animate.scaleY.to(0);
    ringTween.animate.scaleX.to(0);
    await new Future.delayed(new Duration(milliseconds: 100));

    Tween textTween = new Tween(text, 0.9, Transition.easeInOutElastic);
    Animator.juggler.add(textTween);
    textTween.animate.scaleY.to(0.0);
    textTween.animate.scaleX.to(0.0);
    await new Future.delayed(new Duration(milliseconds: 250));
  }


  pop() async {
    await open();
    await new Future.delayed(new Duration(milliseconds: 600));
    await close();
  }
}
