
import 'package:vector_math/vector_math.dart';
import 'package:web_game_engine/shaders.dart';
import 'package:web_game_engine/web_game_engine.dart';
class JCamera {
  static Vector2 pos = Vector2.zero();
  static int viewLen = 1280;
  static int viewHgt = 720;
  static Vector2 shift = Vector2.zero();

  // смотри куда то, то куда смотрим - в центре экрана
  static void lookAt(Vector2 to) {
    shift = to - pos;
  }

  static void screen() {
    final gl = Engine.flutterGlPlugin.gl;
    gl.uniform4f(JShader.cameraSlot, 0, 0, Engine.engineLen / 2, Engine.engineHgt / 2);
  }

  static void prepare() {
    final gl = Engine.flutterGlPlugin.gl;
    gl.uniform4f(JShader.cameraSlot, pos.x, pos.y, viewLen / 2, viewHgt / 2);
  }

  static void init() {
    shift = Vector2.zero();
    pos = Vector2.zero();
    viewHgt = Engine.engineHgt;
    viewLen = Engine.engineLen;
  }

  static void update(double delta, int spd) {
    //if (shift.x > 0.9)
    {
      pos.x += shift.x * delta * spd;
      shift.x -= delta * spd * shift.x;
    }
    //if (shift.y > 0.9)
        {
      final vspd = spd.abs() + (shift.y < 0 ? 50 : 1);
      pos.y += shift.y * delta * vspd;
      shift.y -= delta * vspd;
      if (pos.y < 0) pos.y = 0;
    }
  }
}
