part of ur.render;

/// a static representation of a camera. Makes sure it's in bounds;
class Camera extends TweenObject2D {
  Camera._();

  num _x = 0;
  num _y = 0;

  num get x {
    if (_x >= Street.current.bounds.width - viewport.width/2)
      return Street.current.bounds.width - viewport.width/2;
    if (_x <= viewport.width/2)
      return viewport.width/2;
    return _x;
  }

  num get y {
    if (_y <= viewport.height/2)
      return viewport.height/2;
    if (_y >= Street.current.bounds.height - viewport.height/2)
      return Street.current.bounds.height - viewport.height/2;
    return _y;
  }
  set x(num x) => _x = x;
  set y(num y) => _y = y;

  Tween currentTween;

  animateTo(num x, num y) {
    if (currentTween != null) {
      StreetRenderer.juggler.remove(currentTween);
    }
    currentTween = new Tween(this, 0.02, Transition.linear);
    StreetRenderer.juggler.add(currentTween);
    currentTween.animate.x.to(x);
    currentTween.animate.y.to(y);
  }

  Math.Rectangle get viewport =>
    new Math.Rectangle(_x, _y,
      StreetRenderer.stage.stageWidth,
      StreetRenderer.stage.stageHeight);

  @override
  toString() => 'x:$x y:$y';
}
