import 'package:stagexl/stagexl.dart';
import 'package:ur/display/animator.dart';
import 'dart:math' show Random;

class Trant extends Sprite with Glowable, Talkable{
  Animator animator;

  Trant(String type) {
    animator = new Animator('packages/ur/assets/trant/$type/$type.json');
  }

  load() async {
    await animator.load();
    animator.set(animator.state.keys.last);
    addChild(animator);
  }
}
