part of ur.render;

class Signpost extends Entity {
  Map data;
  Signpost(this.data) {
    this.onMouseClick.listen((_) {
      spawnBubble("You can visit these locations!");
    });
  }

  load() async {
    if (!StreetRenderer.resourceManager.containsBitmapData('signpost')) {
      StreetRenderer.resourceManager
          .addBitmapData('signpost', 'images/post.svg');
    }
    await StreetRenderer.resourceManager.load();

    Bitmap pole =
        new Bitmap(StreetRenderer.resourceManager.getBitmapData('signpost'));
    pole.pivotX = pole.width / 2;
    pole.pivotY = pole.height - 20;
    addChild(pole);

    for (int i = 0; i < data['connects'].length; i++) {
      Map connection = data['connects'][i];
      SignpostSign sign = new SignpostSign(connection);
      await sign.load();
      sign.y = -pole.height + (sign.height + 3) * (i + 1.5);
      if (i.isOdd) {
        sign.pivotX = sign.width - 5;
        sign.rotation = 0.1;
      } else {
        sign.pivotX = 5;
        sign.rotation = -0.1;
      }
      addChild(sign);
    }
  }
}

class SignpostSign extends Entity {
  Map data;
  String get label => data['label'];
  String get tsid => data['tsid'];
  int get targetX => data['x'];
  int get targetY => data['y'];

  SignpostSign(this.data) {}

  load() async {
    if (!StreetRenderer.resourceManager.containsBitmapData('sign')) {
      StreetRenderer.resourceManager.addBitmapData('sign', 'images/sign.svg');
    }
    await StreetRenderer.resourceManager.load();

    Bitmap sign =
        new Bitmap(StreetRenderer.resourceManager.getBitmapData('sign'));
    animation.addChild(sign);

    TextField locationText = new TextField();
    var format = new TextFormat('Fredoka One', 12, Color.White);
    locationText.autoSize = TextFieldAutoSize.LEFT;
    locationText.height = 20;
    locationText.defaultTextFormat = format;
    locationText.text = label;
    locationText.x = 10;
    locationText.y = sign.height/4;
    sign.width = locationText.width + 20;

    this.onMouseOver.listen((_) {
      glowing = true;
    });
    this.onMouseOut.listen((_) {
      glowing = false;
    });

    animation.addChild(locationText);
    addChild(animation);
  }
}
