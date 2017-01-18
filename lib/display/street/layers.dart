part of ur.render;

class EntityLayer extends Layer {
  Map streetData;
  Math.Rectangle streetBounds;

  EntityLayer(this.streetData) {

   streetBounds = new Rectangle(
        streetData['dynamic']['l'],
        streetData['dynamic']['t'],
        (streetData['dynamic']['l'].abs() + streetData['dynamic']['r'].abs())
            .toInt(),
        (streetData['dynamic']['t'].abs() + streetData['dynamic']['b'].abs())
            .toInt());

    layerWidth = streetBounds.width;
    layerHeight = streetBounds.height;
  }

  // Adjusts the layers according to the camera position.
  @override
  render(RenderState renderState) {
    num currentPercentX = (StreetRenderer.camera.x -
            StreetRenderer.camera.viewport.width / 2) /
        (streetBounds.width -
            StreetRenderer.camera.viewport.width);
    num currentPercentY = (StreetRenderer.camera.y -
            StreetRenderer.camera.viewport.height / 2) /
        (streetBounds.height -
            StreetRenderer.camera.viewport.height);
    num offsetX =
        (layerWidth - StreetRenderer.camera.viewport.width) * currentPercentX;
    num offsetY =
        (layerHeight - StreetRenderer.camera.viewport.height) * currentPercentY;
        x = -offsetX  - streetData['dynamic']['l'];
        y = -offsetY  - streetData['dynamic']['t'];
    super.render(renderState);
  }
}

class ImageLayer extends Layer {
  Map streetData;
  Rectangle streetBounds;
  ImageLayer(String tsid, String name, this.streetData) {
    streetBounds = new Rectangle(
         streetData['dynamic']['l'],
         streetData['dynamic']['t'],
         (streetData['dynamic']['l'].abs() + streetData['dynamic']['r'].abs())
             .toInt(),
         (streetData['dynamic']['t'].abs() + streetData['dynamic']['b'].abs())
             .toInt());

    this.mouseEnabled = false;
    this.name = name;
    Bitmap layerBitmap =
        new Bitmap(StreetRenderer.resourceManager.getBitmapData(name + tsid));
    addChild(layerBitmap);
    layerWidth = layerBitmap.width;
    layerHeight = layerBitmap.height;
  }
  // Adjusts the layers according to the camera position.
  @override
  render(RenderState renderState) {
    num currentPercentX = (StreetRenderer.camera.x -
            StreetRenderer.camera.viewport.width / 2) /
        (streetBounds.width -
            StreetRenderer.camera.viewport.width);
    num currentPercentY = (StreetRenderer.camera.y -
            StreetRenderer.camera.viewport.height / 2) /
        (streetBounds.height -
            StreetRenderer.camera.viewport.height);
    num offsetX =
        (layerWidth - StreetRenderer.camera.viewport.width) * currentPercentX;
    num offsetY =
        (layerHeight - StreetRenderer.camera.viewport.height) * currentPercentY;
    x = -offsetX;
    y = -offsetY;
    super.render(renderState);
  }
}


class GradientLayer extends Layer {
  Map streetData;
  Rectangle streetBounds;
  GradientLayer(this.streetData) {

    streetBounds = new Rectangle(
        streetData['dynamic']['l'],
        streetData['dynamic']['t'],
        (streetData['dynamic']['l'].abs() + streetData['dynamic']['r'].abs())
            .toInt(),
        (streetData['dynamic']['t'].abs() + streetData['dynamic']['b'].abs())
            .toInt());

    String top = streetData['gradient']['top'];
    String bottom = streetData['gradient']['bottom'];

    Shape shape = new Shape();
    shape.graphics.rect(0, 0, streetBounds.width, streetBounds.height);
    var gradient = new GraphicsGradient.linear(0, 0, 0, streetBounds.height);
    gradient.addColorStop(0, int.parse('0xFF$top'));
    gradient.addColorStop(1, int.parse('0xFF$bottom'));
    shape.graphics.fillGradient(gradient);
    shape.applyCache(0, 0, streetBounds.width, streetBounds.height);
    BitmapData bitmapData = new BitmapData.fromRenderTextureQuad(shape.cache);
    Bitmap layerBitmap = new Bitmap(bitmapData);
    addChild(layerBitmap);

    layerWidth = layerBitmap.width;
    layerHeight = layerBitmap.height;
  }

  @override
  render(RenderState renderState) {
    num currentPercentX = (StreetRenderer.camera.x -
            StreetRenderer.camera.viewport.width / 2) /
        (streetBounds.width -
            StreetRenderer.camera.viewport.width);
    num currentPercentY = (StreetRenderer.camera.y -
            StreetRenderer.camera.viewport.height / 2) /
        (streetBounds.height -
            StreetRenderer.camera.viewport.height);
    num offsetX =
        (layerWidth - StreetRenderer.camera.viewport.width) * currentPercentX;
    num offsetY =
        (layerHeight - StreetRenderer.camera.viewport.height) * currentPercentY;
    x = -offsetX;
    y = -offsetY;
    super.render(renderState);
  }
}

abstract class Layer extends Sprite {
  num layerWidth;
  num layerHeight;
  Layer();
}
