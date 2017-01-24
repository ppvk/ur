import 'package:stagexl/stagexl.dart';
import 'package:ur/display/animator.dart';

class Signpost extends Sprite {
  Map data;
  Signpost(this.data);

  load() async {
    if (!Animator.resources.containsBitmapData('signpost')) {
      Animator.resources
          .addBitmapData('signpost', 'packages/ur/assets/signpost/post.svg');
    }
    await Animator.resources.load();

    Bitmap pole =
        new Bitmap(Animator.resources.getBitmapData('signpost'));
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

class SignpostSign extends Sprite with Glowable {
  Map data;
  String get label => data['label'];
  String get tsid => data['tsid'];
  int get targetX => data['x'];
  int get targetY => data['y'];

  SignpostSign(this.data);

  load() async {
    if (!Animator.resources.containsBitmapData('sign')) {
      Animator.resources.addBitmapData('sign', 'packages/ur/assets/signpost/sign.svg');
    }
    await Animator.resources.load();

    Bitmap sign =
        new Bitmap(Animator.resources.getBitmapData('sign'));
    addChild(sign);

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
      Mouse.cursor = MouseCursor.POINTER;
      glow();
    });
    this.onMouseOut.listen((_) {
      Mouse.cursor = MouseCursor.AUTO;
      stopGlowing();
    });

    addChild(locationText);
  }
}
