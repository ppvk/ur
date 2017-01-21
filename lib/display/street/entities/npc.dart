part of ur.render;

Math.Random R = new Math.Random();

class NPC extends Entity {
  String name;
  List<String> flags;
  NPC(this.name);
  load() async {
    addChild(animation);

    int i = 0;
    animation.onMouseRightClick.listen((_) {
      if ( i >= animation.state.keys.length) i = 0;
      String anim = animation.state.keys.toList()[i];
      i++;
      print(anim);
      animation.set(anim);
    });
  }
}


List PIGGYDEF = [
  {
    'image': 'packages/ur/sprites/piggy/walk.png',
    'height': 3,
    'width': 8,
    'animations': {
      'walk': {
        'frames': [
          [0, 23]
        ],
        'loop': true
      }
    }
  },
  {
    'image': 'packages/ur/sprites/piggy/look.png',
    'height': 5,
    'width': 10,
    'animations': {
      'default': {
        'frames': [
          [0, 47]
        ],
        'bounce': true
      }
    }
  },
  {
    'image': 'packages/ur/sprites/piggy/nibble.png',
    'height': 6,
    'width': 10,
    'animations': {
      'nibble': {
        'frames': [
          [0, 59]
        ],
        'loop': false
      }
    }
  },
  {
    'image': 'packages/ur/sprites/piggy/toomuchnibble.png',
    'height': 6,
    'width': 11,
    'animations': {
      'tooMuchNibble': {
        'frames': [
          [0, 64]
        ],
        'loop': false
      }
    }
  }
];
