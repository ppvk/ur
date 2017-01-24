part of streetstage;

class EntityLayer extends Layer {
  EntityLayer(num width, num height) {
    layerWidth = width;
    layerHeight = height;
  }
}

class ImageLayer extends Layer {
  Rectangle streetBounds;
  ImageLayer(String tsid, String name) {

    this.mouseEnabled = false;
    this.name = name;
    Bitmap layerBitmap =
        new Bitmap(Animator.resources.getBitmapData(name + tsid));
    addChild(layerBitmap);
    layerWidth = layerBitmap.width;
    layerHeight = layerBitmap.height;
  }
}


class GradientLayer extends Layer {
  Map streetData;
  GradientLayer(num width, num height, String top, String bottom) {

    Shape shape = new Shape();
    shape.graphics.rect(0, 0, width, height);
    var gradient = new GraphicsGradient.linear(0, 0, 0, height);
    gradient.addColorStop(0, int.parse('0xFF$top'));
    gradient.addColorStop(1, int.parse('0xFF$bottom'));
    shape.graphics.fillGradient(gradient);
    shape.applyCache(0, 0, width, height);
    BitmapData bitmapData = new BitmapData.fromRenderTextureQuad(shape.cache);
    Bitmap layerBitmap = new Bitmap(bitmapData);
    addChild(layerBitmap);

    layerWidth = layerBitmap.width;
    layerHeight = layerBitmap.height;
  }
}

abstract class Layer extends Sprite {
  num layerWidth;
  num layerHeight;
  Layer();
}
