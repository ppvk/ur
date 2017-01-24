part of streetstage;

class Street extends DisplayObjectContainer with Animatable {
  StreetStage stage;
  static Street current;
  Map streetData;

  Rectangle _bounds;
  @override
  Rectangle get bounds => _bounds;

  String get tsid => streetData['tsid'].replaceRange(0, 1, 'L');
  num get groundY => -(streetData['dynamic']['ground_y'] as num).abs();

  // Entity Management
  EntityLayer playerLayer;
  EntityLayer quoinLayer;
  EntityLayer npcLayer;

  // Constructor
  Street(this.streetData) {
    _bounds = new Rectangle(
         streetData['dynamic']['l'],
         streetData['dynamic']['t'],
         (streetData['dynamic']['l'].abs() + streetData['dynamic']['r'].abs())
             .toInt(),
         (streetData['dynamic']['t'].abs() + streetData['dynamic']['b'].abs())
             .toInt());
  }

  load() async {
    // load layer images.
    String tsid = streetData['tsid'].replaceRange(0, 1, 'L');
    for (Map layer in streetData['dynamic']['layers'].values) {
      String layerName = layer['name'].replaceAll(' ', '_');
      String url =
          'http://childrenofur.com/assets/streetLayers/$tsid/$layerName.png';
      if (!Animator.resources.containsBitmapData(layerName + tsid))
        Animator.resources.addBitmapData(layerName + tsid, url);
    }
    await Animator.resources.load();

    // Gradient Layer
    String top = streetData['gradient']['top'];
    String bottom = streetData['gradient']['bottom'];
    addChild(new GradientLayer(_bounds.width, _bounds.height, top, bottom));

    // Image Layers
    List layerMaps = new List.from(streetData['dynamic']['layers'].values);
    layerMaps.sort((Map A, Map B) => A['z'].compareTo(B['z']));
    for (Map layer in layerMaps) {
      String layerName = layer['name'].replaceAll(' ', '_');
      addChild(new ImageLayer(tsid, layerName));
      // Add npcLayers
      if (layerName == 'middleground') {
        quoinLayer = new EntityLayer(_bounds.width, _bounds.height);
        addChild(quoinLayer);
        npcLayer = new EntityLayer(_bounds.width, _bounds.height);
        addChild(npcLayer);
        playerLayer = new EntityLayer(_bounds.width, _bounds.height);
        addChild(playerLayer);
      }
    }
    for (Map layer in layerMaps) {
      for (Map signpost in layer['signposts']) {
        Signpost sp = new Signpost(signpost)
          ..x = signpost['x']
          ..y = signpost['y'];
        await sp.load();
        npcLayer.addChild(sp);
      }
    }
  }

  spawn(int x, int y, DisplayObject npc) async {
    npc.x = x + bounds.left;
    npc.y = y + bounds.top;
    npcLayer.addChild(npc);
  }

  advanceTime(_) async {
    if (stage != null) {
      await html.window.animationFrame;
      for (Layer layer in children) {
        num currentPercentX = (stage.camera.x -
                stage.camera.viewport.width / 2) /
            (_bounds.width -
                stage.camera.viewport.width);
        num currentPercentY = (stage.camera.y -
                stage.camera.viewport.height / 2) /
            (_bounds.height -
                stage.camera.viewport.height);
        num offsetX =
            (layer.layerWidth - stage.camera.viewport.width) * currentPercentX;
        num offsetY =
            (layer.layerHeight - stage.camera.viewport.height) * currentPercentY;

        if (layer is EntityLayer) {
          layer.x = -offsetX - _bounds.left;
          layer.y = -offsetY - _bounds.top;
        } else {
          layer.x = -offsetX;
          layer.y = -offsetY;
        }
      }
    }
  }
}
