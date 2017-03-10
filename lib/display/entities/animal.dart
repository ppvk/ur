import 'package:stagexl/stagexl.dart';
import 'package:ur/display/animator.dart';
import 'dart:math' show Random;

class Animal extends Sprite with Glowable, Talkable{
  Animator animator;

  Animal(String type) {
    animator = new Animator('packages/ur/assets/animal/$type/$type.json');
  }

  load() async {
    await animator.load();
    animator.set(animator.state.keys.last);
    addChild(animator);
  }
}


class DemoAnimal extends Animal {
  DemoAnimal(String type): super(type) {
    onMouseUp.listen((_) {
      int r = R.nextInt(animator.state.length - 1);
      String name = animator.state.keys.toList()[r];
      animator.set(name);
    });
  }
  Random R = new Random();
}
