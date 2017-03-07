import 'package:stagexl/stagexl.dart';
import 'package:ur/display/animator.dart';

class Animal extends Sprite with Glowable, Talkable{
  Animator animator;

  Animal(String type) {
    animator = new Animator('packages/ur/assets/animal/$type/$type.json');
  }

  load() async {
    await animator.load();
    addChild(animator);
  }
}
