import 'package:vector_math/vector_math.dart';

class JCamera {
  Vector2 viewfinder = Vector2.zero();
  Vector2 viewport = Vector2(1280, 720);
  Vector2 shift = Vector2.zero();

  // смотри куда то, то куда смотрим - в центре экрана
  void lookAt(Vector2 to) {
    shift = to - viewfinder;
  }

  void moveBy(Vector2 shift) {
    viewfinder += shift;
  }

  void init(int w, int h) {
    shift = Vector2.zero();
    viewfinder = Vector2.zero();
    viewport = Vector2(w + 0.0, h + 0.0);
  }

  void update(double delta, int spd) {
    viewfinder.x += shift.x * delta * spd;
    shift.x -= delta * spd * shift.x;
    final vspd = spd.abs() + (shift.y < 0 ? 50 : 1);
    viewfinder.y += shift.y * delta * vspd;
    shift.y -= delta * vspd;
    if (viewfinder.y < 0) viewfinder.y = 0;
  }
}
