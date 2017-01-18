import 'dart:convert';
import 'dart:html';
import 'package:ur/display/keyboard.dart';
import 'package:ur/display/street/render.dart';
import 'package:ur/display/ui/meters.dart';
import 'package:ur/display/ui/time.dart';

main() async {
  Meters.img = 0;
  Meters.currants = 1024;
  Meters.mood = 100;
  Meters.moodMax = 100;
  Meters.energy = 100;
  Meters.energyMax = 100;
  Clock.start();

  StreetRenderer.init();


  StreetRenderer.resourceManager.addTextFile('mira.json', 'mira.json');
  await StreetRenderer.resourceManager.load();
  Map def = JSON.decode(StreetRenderer.resourceManager.getTextFile('mira.json'));

  Street street = new Street(def);
  await street.load();

  StreetRenderer.stage.children.clear();
  StreetRenderer.juggler.clear();
  StreetRenderer.setStreet(street);

  NPC piggy = new NPC('pig', PIGGYDEF);
  piggy.onMouseOver.listen((_) {
    piggy.glowing = true;
  });
  piggy.onMouseOut.listen((_) {
    piggy.glowing = false;
  });
  piggy.onMouseClick.listen((_) {
    piggy.spawnBubble("Hello Friend!", "Piggy");
  });
  await street.spawn(300, 300, piggy);

  Player player = new Player('Paul');
  await street.spawn(400, 300, player);
  player.animation.set('walk');
  player.onMouseClick.listen((_) {
    player.spawnBubble("Hello Friend! Hello Friend! Hello Friend! Hello Friend! Hello Friend! Hello Friend! Hello Friend! Hello Friend! Hello Friend! Hello Friend! Hello Friend! Hello Friend! Hello Friend!", player.name);
  });

  Quoin quoin = await street.spawnQuoin(200, 250, 'Img', 16);
  quoin.onMouseClick.listen((_) async {
    if (!quoin.collected) quoin.pop();
    else quoin.reset();
  });

  await Keyboard.init();
  loop();
}


loop() async {
  int newX = StreetRenderer.camera.x;
  int newY = StreetRenderer.camera.y;

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

  if (newX != StreetRenderer.camera.x || newY != StreetRenderer.camera.y)
  StreetRenderer.camera.animateTo(
    newX, newY
  );
  await window.animationFrame;
  loop();
}
