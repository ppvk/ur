part of ur.render;

class Player extends Entity {
  static Player current;
  String name;
  Player(this.name);

  load() async {
    await animation.load(animationBatchTemplate);
    addChild(animation);
  }

  List animationBatchTemplate = [
    {
      'image': 'packages/ur/sprites/player/base.png',
      'height': 1,
      'width': 15,
      'animations': {
        'walk': {
          'frames': [
            [0, 11]
          ],
          'loop': true
        },
        'default': {
          'frames': [14]
        },
        'flip': {
          'frames': [12],
          'loop': true
        }
      }
    },
    {
      'image': 'packages/ur/sprites/player/climb.png',
      'height': 1,
      'width': 19,
      'animations': {
        'climb up': {
          'frames': [
            [0, 18]
          ],
          'loop': true
        },
        'climb down': {
          'frames': [
            [18, 0]
          ],
          'loop': true
        }
      }
    },
    {
      'image': 'packages/ur/sprites/player/idle.png',
      'height': 2,
      'width': 29,
      'animations': {
        'idle': {
          'frames': [
            [0, 57]
          ],
          'loop': true
        }
      }
    },
    {
      'image': 'packages/ur/sprites/player/jump.png',
      'height': 1,
      'width': 33,
      'animations': {
        'float up': {
          'frames': [
            [1, 11]
          ],
          'bounce': true
        },
        'float down': {
          'frames': [
            [12, 32]
          ],
          'bounce': true
        }
      }
    }
  ];
}
