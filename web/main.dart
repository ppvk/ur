import 'dart:convert';
import 'dart:html';
import 'package:ur/display/keyboard.dart';
import 'package:ur/display/ui/meters.dart';
import 'package:ur/display/ui/time.dart';

import 'package:ur/display/streetstage.dart';
import 'package:ur/display/animator.dart';

import 'package:ur/display/entities/animal.dart';
import 'package:ur/display/entities/quoin.dart';

StreetStage stage = new StreetStage();

main() async {
  Meters.img = 0;
  Meters.currants = 1024;
  Meters.mood = 100;
  Meters.moodMax = 100;
  Meters.energy = 100;
  Meters.energyMax = 100;
  Clock.start();

  StreetStage.init();

  Animator.resources.addTextFile('mira.json', 'mira.json');
  await Animator.resources.load();
  Map def = JSON.decode(Animator.resources.getTextFile('mira.json'));

  Street street = new Street(def);
  await street.load();
  stage.setStreet(street);

  await Keyboard.init();
  loop();


  // SPAWNING IN ENTITIES FOR TEST PURPOSES //
  Animal batterfly = new Animal('batterfly');
  await batterfly.load();
  batterfly.animator.set('chew');
  street.spawn(400, 200, batterfly, street.npcLayer);
  batterfly.onMouseUp.listen((_) {
    batterfly.say("Don't touch me.");
  });


  QuoinSprite quoin = new QuoinSprite('Img', 10);
  await quoin.load();
  street.spawn(400, 100, quoin, street.quoinLayer);


}


loop() async {
  int newX = stage.camera.x;
  int newY = stage.camera.y;

  if (Keyboard.pressed(37)) {
    newX -= 20;
  }
  if (Keyboard.pressed(38)) {
    newY -= 20;
  }
  if (Keyboard.pressed(39)) {
    newX += 20;
  }
  if (Keyboard.pressed(40)) {
    newY += 20;
  }

  if (newX != stage.camera.x || newY != stage.camera.y) {
    stage.camera.x = newX;
    stage.camera.y = newY;
  }
  await window.animationFrame;
  loop();
}
