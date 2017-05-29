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

  QuoinSprite quoin = new QuoinSprite('mood', 10);
  await quoin.load();
  street.spawn(150, 100, quoin, street.quoinLayer);

  DemoAnimal batterfly = new DemoAnimal('batterfly');
  await batterfly.load();
  street.spawn(150, 200, batterfly, street.npcLayer);

  DemoAnimal butterfly = new DemoAnimal('butterfly');
  await butterfly.load();
  street.spawn(150, 300, butterfly, street.npcLayer);

  DemoAnimal chicken = new DemoAnimal('chicken');
  await chicken.load();
  street.spawn(150, 400, chicken, street.npcLayer);

  DemoAnimal firefly = new DemoAnimal('firefly');
  await firefly.load();
  street.spawn(150, 500, firefly, street.npcLayer);

  DemoAnimal fox = new DemoAnimal('fox');
  await fox.load();
  street.spawn(300, 200, fox, street.npcLayer);

  DemoAnimal kitty = new DemoAnimal('kitty');
  await kitty.load();
  street.spawn(300, 300, kitty, street.npcLayer);

  DemoAnimal piggy = new DemoAnimal('piggy');
  await piggy.load();
  street.spawn(300, 400, piggy, street.npcLayer);

  DemoAnimal salmon = new DemoAnimal('salmon');
  await salmon.load();
  street.spawn(300, 500, salmon, street.npcLayer);

  DemoAnimal silverFox = new DemoAnimal('silverfox');
  await silverFox.load();
  street.spawn(450, 200, silverFox, street.npcLayer);





  
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
