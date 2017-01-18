part of ur.render;

class Street extends DisplayObjectContainer {
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
      if (!StreetRenderer.resourceManager
          .containsBitmapData(layerName + tsid)) StreetRenderer.resourceManager
          .addBitmapData(layerName + tsid, url);
    }
    await StreetRenderer.resourceManager.load();

    // adds layers
    addChild(new GradientLayer(streetData));

    List layerMaps = new List.from(streetData['dynamic']['layers'].values);
    layerMaps.sort((Map A, Map B) => A['z'].compareTo(B['z']));
    for (Map layer in layerMaps) {
      String layerName = layer['name'].replaceAll(' ', '_');
      addChild(new ImageLayer(tsid, layerName, streetData));
      if (layerName == 'middleground') {
        quoinLayer = new EntityLayer(streetData);
        addChild(quoinLayer);
        npcLayer = new EntityLayer(streetData);
        addChild(npcLayer);
        playerLayer = new EntityLayer(streetData);
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

  spawn(int x, int y, Entity npc) async {
    await npc.load();
    npc.x = x + bounds.left;
    npc.y = y + bounds.top;
    npcLayer.addChild(npc);
  }

  spawnQuoin(int x, int y, String type, int value) async {
    Quoin quoin = new Quoin(type, value);
    await quoin.load();
    quoin.x = x + bounds.left;
    quoin.y = y + bounds.top;
    quoinLayer.addChild(quoin);
    return quoin;
  }
}
