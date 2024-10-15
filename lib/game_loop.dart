import 'package:flutter/foundation.dart';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:web_game_engine/shaders.dart';
import 'package:web_game_engine/web_game_engine.dart';

import 'camera.dart';

class Loop {
  bool isAnimation = false;
  num dpr = 1.0;
  int _previous = DateTime.timestamp().microsecondsSinceEpoch;
  double dt = 0;
  int zoom = 100;
  void Function()? renderCallback;
  void Function(double)? updateCallback;

  Future<bool> init(int len, int hgt, [renderer, update]) async {
    if (renderer != null) {
      renderCallback = renderer;
    } else {
      renderCallback = null;
    }
    if (update != null) {
      updateCallback = update;
    } else {
      updateCallback = null;
    }
    Engine.engineLen = len;
    Engine.engineHgt = hgt;
    zoom = 100;
    await prepare();
    //await Wardrobe.loadTextures();
    //render();
    _previous = 0;
    isAnimation = true;
    animate();
    return true;
  }

  void animate() {
    if (!isAnimation) return;
    final timestamp = DateTime.timestamp().microsecondsSinceEpoch;
    final durationDelta = timestamp - _previous;
    dt = durationDelta / Duration.microsecondsPerSecond;
    if (updateCallback != null) {
      updateCallback!(dt);
    }

    _previous = timestamp;
    render();

    Future.delayed(const Duration(milliseconds: 25), () {
      animate();
    });
  }

  void render() {
    if (renderCallback != null) {
      beginRender(zoom);
      renderCallback!();
      Engine.render();
    }
  }

  Future<bool> prepare() async {
    Engine.flutterGlPlugin = FlutterGlPlugin();

    Map<String, dynamic> options = {
      "antialias": true,
      "alpha": true,
      "width": Engine.engineLen,
      "height": Engine.engineHgt,
      "dpr": dpr
    };

    await Engine.flutterGlPlugin.initialize(options: options);
    if (kDebugMode) {
      print('get instance');
    }

    String version = "300 es";

    var vs = """#version $version
precision highp float;
uniform vec4 camera;
in vec3 vPosition;
in vec2 vTex;
in vec4 vColor;
out vec4 vCol;
out vec2 TexCoord;

void main(void)
{
  vec2 ofs = camera.zw;
    vec2 to = camera.xy;
    vec2 pos = vPosition.xy;
    pos = pos - to - ofs;
    pos.x = pos.x / ofs.x;
    pos.y = pos.y / ofs.y;

    gl_Position = vec4(pos.xy, vPosition.z, 1.0);
    TexCoord = vTex;
    vCol = vec4(vColor);
}
    """;

    var fs = """#version $version
precision highp float;
in vec2 TexCoord;
in vec4 vCol;
uniform sampler2D tTexture;
out vec4 color;

void main() {
  vec4 c=texture(tTexture, TexCoord);
    color = vCol;
}
    """;

    JShader.creareProgram(0, vs, fs);
    JShader.useProgram(0);
    vs = """#version $version
precision highp float;
uniform vec4 camera;
in vec3 vPosition;
in vec2 vTex;
in vec4 vColor;
out vec4 vCol;
out vec2 TexCoord;

void main(void)
{
  vec2 ofs = camera.zw;
    vec2 to = camera.xy;
    vec2 pos = vPosition.xy;
    pos = pos - to - ofs;
    pos.x = pos.x / ofs.x;
    pos.y = pos.y / ofs.y;

    gl_Position = vec4(pos.xy, vPosition.z, 1.0);
    TexCoord = vTex;
    vCol = vec4(vColor);
}
    """;

    fs = """#version $version
precision highp float;
in vec2 TexCoord;
in vec4 vCol;
uniform sampler2D tTexture;
out vec4 color;

void main() {
  vec4 c=texture(tTexture, TexCoord);
    if (c.a<0.1) discard;

    color =vec4(c.b, c.g, c.r, c.a) * vCol;
}
    """;

    JShader.creareProgram(1, vs, fs);
    JShader.useProgram(1);
    // Write the positions of vertices to a vertex shader
    return true;
  }

  void beginRender(int zoom) {
    final gl = Engine.flutterGlPlugin.gl;

    gl.viewport(0, 0, Engine.engineLen, Engine.engineHgt);
    gl.enable(gl.BLEND);
    gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);

    JCamera.viewHgt = Engine.engineHgt * 100 ~/ zoom;
    JCamera.viewLen = Engine.engineLen * 100 ~/ zoom;
    JCamera.prepare();

    // Clear canvas
    gl.clearColor(0, 0, 0, 1);

    gl.depthFunc(gl.LEQUAL);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    gl.enable(gl.DEPTH_TEST);
    gl.enable(gl.BLEND);
    gl.enable(gl.ALPHA);

    Engine.clearScene();
  }

  void stop() {
    isAnimation = false;
    renderCallback = null;
  }
}
