import 'package:vector_math/vector_math.dart';
import 'package:web_game_engine/shaders.dart';
import 'package:web_game_engine/web_game_engine.dart';

class JCamera {
  Vector2 viewfinder = Vector2.zero();
  Vector2 viewport = Vector2(1280, 720);
  Vector2 shift = Vector2.zero();

  // смотри куда то, то куда смотрим - в центре экрана
  void lookAt(Vector2 to) {
    shift = to - viewfinder;
  }

  void moveImmediately(Vector2 shift) {
    viewfinder += shift;
  }

  void screen() {
    final gl = Engine.flutterGlPlugin.gl;
    gl.uniform4f(
        JShader.cameraSlot, 0, 0, Engine.engineLen / 2, Engine.engineHgt / 2);
  }

  void prepare() {
    final gl = Engine.flutterGlPlugin.gl;
    gl.uniform4f(JShader.cameraSlot, viewfinder.x, viewfinder.y, viewport.x / 2,
        viewport.y / 2);
  }

  void init() {
    shift = Vector2.zero();
    viewfinder = Vector2.zero();
    viewport = Vector2(Engine.engineLen + 0.0, Engine.engineHgt + 0.0);
  }

  void update(double delta, int spd) {
    //if (shift.x > 0.9)
    {
      viewfinder.x += shift.x * delta * spd;
      shift.x -= delta * spd * shift.x;
    }
    //if (shift.y > 0.9)
    {
      final vspd = spd.abs() + (shift.y < 0 ? 50 : 1);
      viewfinder.y += shift.y * delta * vspd;
      shift.y -= delta * vspd;
      if (viewfinder.y < 0) viewfinder.y = 0;
    }
  }
}
