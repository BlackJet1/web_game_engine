library web_game_engine;

import 'package:flutter/foundation.dart';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:web_game_engine/camera.dart';
import 'package:web_game_engine/model/core.dart';
import 'package:web_game_engine/model/textureatom_model.dart';
import 'dart:typed_data';
import 'dart:math';

import 'package:web_game_engine/shaders.dart';
import 'package:web_game_engine/wardrobe.dart';

class Engine {
  static late int engineLen;
  static late int engineHgt;
  static late FlutterGlPlugin flutterGlPlugin;
  static List<JFlat> scene = [];
  static List<JQuad> post = [];
  static List<String> usingTextures = [];
  static List<String> usingPostTextures = [];
  static List postScene = [];
  static List<JLine> lines = [];
  static List<JRect> rects = [];
  static Int16List index = Int16List(65535);

  static void _drawLines() {
    final gl = flutterGlPlugin.gl;
    final dynamic vaoLines = gl.createVertexArray();
    final vertices = Float32Array(lines.length * 14);
    for (var i = 0; i < lines.length; i++) {
      vertices[i * 14 + 0] = lines[i].x1;
      vertices[i * 14 + 1] = lines[i].y1;
      vertices[i * 14 + 2] = lines[i].z1;
      vertices[i * 14 + 3] = lines[i].r;
      vertices[i * 14 + 4] = lines[i].g;
      vertices[i * 14 + 5] = lines[i].b;
      vertices[i * 14 + 6] = lines[i].a;
      vertices[i * 14 + 7] = lines[i].x2;
      vertices[i * 14 + 8] = lines[i].y2;
      vertices[i * 14 + 9] = lines[i].z2;
      vertices[i * 14 + 10] = lines[i].r;
      vertices[i * 14 + 11] = lines[i].g;
      vertices[i * 14 + 12] = lines[i].b;
      vertices[i * 14 + 13] = lines[i].a;
    }

    gl.bindVertexArray(vaoLines);

    // Create a buffer object
    final vertexBuffer = gl.createBuffer();
    if (vertexBuffer == null) {
      if (kDebugMode) {
        print('Failed to create the buffer object');
      }
      return;
    }
    const stride = Float32List.bytesPerElement * 7;
    gl
      ..bindBuffer(gl.ARRAY_BUFFER, vertexBuffer)
      ..bufferData(
          gl.ARRAY_BUFFER, vertices.length / 7, vertices, gl.STATIC_DRAW)
      ..vertexAttribPointer(JShader.positionSlot, 3, gl.FLOAT, false, stride, 0)
      ..enableVertexAttribArray(JShader.positionSlot);

    final colorBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, colorBuffer);
    gl.bufferData(
        gl.ARRAY_BUFFER, vertices.length / 7, vertices, gl.STATIC_DRAW);
    gl.enableVertexAttribArray(JShader.colorSlot);
    const size = 4;
    final type = gl.FLOAT; // the data is 32bit floats

    const offset = Float32List.bytesPerElement * 3;
    gl.vertexAttribPointer(
        JShader.colorSlot, size, type, false, stride, offset);
    gl.drawArrays(gl.LINES, 0, lines.length * 2);
  }

  static void _drawRects() {
    final gl = flutterGlPlugin.gl;
    final dynamic vaoLines = gl.createVertexArray();
    final vertices = Float32Array(rects.length * 42);
    for (var i = 0; i < rects.length; i++) {
      vertices[i * 42 + 0] = rects[i].x;
      vertices[i * 42 + 1] = rects[i].y;
      vertices[i * 42 + 2] = rects[i].z;
      vertices[i * 42 + 3] = rects[i].r;
      vertices[i * 42 + 4] = rects[i].g;
      vertices[i * 42 + 5] = rects[i].b;
      vertices[i * 42 + 6] = rects[i].a;

      vertices[i * 42 + 7] = rects[i].x + rects[i].len;
      vertices[i * 42 + 8] = rects[i].y;
      vertices[i * 42 + 9] = rects[i].z;
      vertices[i * 42 + 10] = rects[i].r;
      vertices[i * 42 + 11] = rects[i].g;
      vertices[i * 42 + 12] = rects[i].b;
      vertices[i * 42 + 13] = rects[i].a;

      vertices[i * 42 + 14] = rects[i].x + rects[i].len;
      vertices[i * 42 + 15] = rects[i].y + rects[i].hgt;
      vertices[i * 42 + 16] = rects[i].z;
      vertices[i * 42 + 17] = rects[i].r;
      vertices[i * 42 + 18] = rects[i].g;
      vertices[i * 42 + 19] = rects[i].b;
      vertices[i * 42 + 20] = rects[i].a;

      vertices[i * 42 + 21] = rects[i].x;
      vertices[i * 42 + 22] = rects[i].y;
      vertices[i * 42 + 23] = rects[i].z;
      vertices[i * 42 + 24] = rects[i].r;
      vertices[i * 42 + 25] = rects[i].g;
      vertices[i * 42 + 26] = rects[i].b;
      vertices[i * 42 + 27] = rects[i].a;

      vertices[i * 42 + 28] = rects[i].x;
      vertices[i * 42 + 29] = rects[i].y + rects[i].hgt;
      vertices[i * 42 + 30] = rects[i].z;
      vertices[i * 42 + 31] = rects[i].r;
      vertices[i * 42 + 32] = rects[i].g;
      vertices[i * 42 + 33] = rects[i].b;
      vertices[i * 42 + 34] = rects[i].a;

      vertices[i * 42 + 35] = rects[i].x + rects[i].len;
      vertices[i * 42 + 36] = rects[i].y + rects[i].hgt;
      vertices[i * 42 + 37] = rects[i].z;
      vertices[i * 42 + 38] = rects[i].r;
      vertices[i * 42 + 39] = rects[i].g;
      vertices[i * 42 + 40] = rects[i].b;
      vertices[i * 42 + 41] = rects[i].a;
    }

    gl.bindVertexArray(vaoLines);

    // Create a buffer object
    var vertexBuffer = gl.createBuffer();
    if (vertexBuffer == null) {
      if (kDebugMode) {
        print('Failed to create the buffer object');
      }
      return;
    }
    var stride = Float32List.bytesPerElement * 7;
    gl
      ..bindBuffer(gl.ARRAY_BUFFER, vertexBuffer)
      ..bufferData(
          gl.ARRAY_BUFFER, vertices.length / 7, vertices, gl.STATIC_DRAW)
      ..vertexAttribPointer(JShader.positionSlot, 3, gl.FLOAT, false, stride, 0)
      ..enableVertexAttribArray(JShader.positionSlot);

    var colorBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, colorBuffer);
    gl.bufferData(
        gl.ARRAY_BUFFER, vertices.length / 7, vertices, gl.STATIC_DRAW);
    gl.enableVertexAttribArray(JShader.colorSlot);
    var size = 4;
    var type = gl.FLOAT; // the data is 32bit floats

    var offset = Float32List.bytesPerElement * 3;
    gl.vertexAttribPointer(
        JShader.colorSlot, size, type, false, stride, offset);
    gl.drawArrays(gl.TRIANGLES, 0, rects.length * 6);
  }

  static void _drawScene() {
    final gl = flutterGlPlugin.gl;
    for (final tex in usingTextures) {
      //print('try $tex');
      Wardrobe.bindByName(tex);
      final filteredScene = List<JFlat>.from(
          scene.where((element) => element.atom.textureName == tex));
      dynamic vao;
      final vertices = Float32Array(filteredScene.length * 36);
      for (var i = 0; i < filteredScene.length; i++) {
        var curentFrame = (TextureAtom.aniCounter /
                    (1 /
                        (filteredScene[i].atom.frames *
                            (filteredScene[i].atom.fps < 0
                                ? 1
                                : filteredScene[i].atom.fps))))
                .ceil() -
            1;
        double atomAnimation = 0;
        if (curentFrame < 1) {
          curentFrame = 0;
        } else {
          atomAnimation = ((filteredScene[i].atom.hgt + 1) * curentFrame) /
              filteredScene[i].atom.th;
        }

        final z = filteredScene[i].z;
        final x0 = filteredScene[i].x - filteredScene[i].len / 2;
        final y0 = filteredScene[i].y - filteredScene[i].hgt / 2;
        final frameOffset = filteredScene[i].frameLen * filteredScene[i].frame;
        final r = filteredScene[i].r;
        final g = filteredScene[i].g;
        final b = filteredScene[i].b;
        final a = filteredScene[i].a;
        final cx = filteredScene[i].x +
            filteredScene[i].len * filteredScene[i].anchorx;
        final cy = filteredScene[i].y +
            filteredScene[i].hgt * filteredScene[i].anchory;
        final radians = filteredScene[i].angle * pi / 180;
        final x1 = (x0 - cx) * cos(radians) - (y0 - cy) * sin(radians) + cx;
        final y1 = (x0 - cx) * sin(radians) + (y0 - cy) * cos(radians) + cy;
        final x2 = (x0 - cx) * cos(radians) -
            (y0 + filteredScene[i].hgt - cy) * sin(radians) +
            cx;
        final y2 = (x0 - cx) * sin(radians) +
            (y0 + filteredScene[i].hgt - cy) * cos(radians) +
            cy;
        final x3 = (x0 + filteredScene[i].len - cx) * cos(radians) -
            (y0 + filteredScene[i].hgt - cy) * sin(radians) +
            cx;
        final y3 = (x0 + filteredScene[i].len - cx) * sin(radians) +
            (y0 + filteredScene[i].hgt - cy) * cos(radians) +
            cy;
        final x4 = (x0 + filteredScene[i].len - cx) * cos(radians) -
            (y0 - cy) * sin(radians) +
            cx;
        final y4 = (x0 + filteredScene[i].len - cx) * sin(radians) +
            (y0 - cy) * cos(radians) +
            cy;
        // translate to screen coords
        final xl = frameOffset +
            ((filteredScene[i].mirrorX == true)
                ? filteredScene[i].atom.tx2
                : filteredScene[i].atom.tx1);
        final xr = frameOffset +
            ((filteredScene[i].mirrorX == true)
                ? filteredScene[i].atom.tx1
                : filteredScene[i].atom.tx2);
        final yd = (filteredScene[i].mirrorY == true)
            ? filteredScene[i].atom.ty2 + atomAnimation
            : filteredScene[i].atom.ty1 + atomAnimation;
        final yu = (filteredScene[i].mirrorY == true)
            ? filteredScene[i].atom.ty1 + atomAnimation
            : filteredScene[i].atom.ty2 + atomAnimation;

        vertices[i * 36 + 0] = x1;
        vertices[i * 36 + 1] = y1;
        vertices[i * 36 + 2] = z;
        vertices[i * 36 + 3] = r;
        vertices[i * 36 + 4] = g;
        vertices[i * 36 + 5] = b;
        vertices[i * 36 + 6] = a;
        vertices[i * 36 + 7] = xl;
        vertices[i * 36 + 8] = yd;

        vertices[i * 36 + 9] = x2;
        vertices[i * 36 + 10] = y2;
        vertices[i * 36 + 11] = z;
        vertices[i * 36 + 12] = r;
        vertices[i * 36 + 13] = g;
        vertices[i * 36 + 14] = b;
        vertices[i * 36 + 15] = a;
        vertices[i * 36 + 16] = xl;
        vertices[i * 36 + 17] = yu;

        vertices[i * 36 + 18] = x3;
        vertices[i * 36 + 19] = y3;
        vertices[i * 36 + 20] = z;
        vertices[i * 36 + 21] = r;
        vertices[i * 36 + 22] = g;
        vertices[i * 36 + 23] = b;
        vertices[i * 36 + 24] = a;
        vertices[i * 36 + 25] = xr;
        vertices[i * 36 + 26] = yu;

        vertices[i * 36 + 27] = x4;
        vertices[i * 36 + 28] = y4;
        vertices[i * 36 + 29] = z;
        vertices[i * 36 + 30] = r;
        vertices[i * 36 + 31] = g;
        vertices[i * 36 + 32] = b;
        vertices[i * 36 + 33] = a;
        vertices[i * 36 + 34] = xr;
        vertices[i * 36 + 35] = yd;
      }
      // 1-2-3 1-3-4

      vao = gl.createVertexArray();
      gl.bindVertexArray(vao);

      // Create a buffer object
      var vertexBuffer = gl.createBuffer();
      if (vertexBuffer == null) {
        if (kDebugMode) {
          print('Failed to create the buffer object');
        }
        return;
      }
      var stride = Float32List.bytesPerElement * 9;
      gl
        ..bindBuffer(gl.ARRAY_BUFFER, vertexBuffer)
        ..bufferData(
            gl.ARRAY_BUFFER, vertices.length / 9, vertices, gl.STATIC_DRAW)
        ..vertexAttribPointer(
            JShader.positionSlot, 3, gl.FLOAT, false, stride, 0)
        ..enableVertexAttribArray(JShader.positionSlot);

      final texCoordBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, texCoordBuffer);
      gl.bufferData(
          gl.ARRAY_BUFFER, vertices.length / 9, vertices, gl.STATIC_DRAW);
      gl.enableVertexAttribArray(JShader.textureSlot);
      var size = 2; // 2 components per iteration
      var type = gl.FLOAT; // the data is 32bit floats
      const normalize = false; // don't normalize the data

      var offset = Float32List.bytesPerElement *
          7; // start at the beginning of the buffer
      gl.vertexAttribPointer(
          JShader.textureSlot, size, type, normalize, stride, offset);

      var colorBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, colorBuffer);
      gl.bufferData(
          gl.ARRAY_BUFFER, vertices.length / 9, vertices, gl.STATIC_DRAW);
      gl.enableVertexAttribArray(JShader.colorSlot);
      size = 4;
      type = gl.FLOAT; // the data is 32bit floats

      offset = Float32List.bytesPerElement * 3;
      gl.vertexAttribPointer(
          JShader.colorSlot, size, type, normalize, stride, offset);

      //gl.drawArrays(gl.TRIANGLES, 0, n);
      dynamic ibo = gl.createBuffer();
      gl
        ..bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibo)
        ..bufferData(gl.ELEMENT_ARRAY_BUFFER, filteredScene.length * 6, index,
            gl.STATIC_DRAW);
      gl.drawElements(
          gl.TRIANGLES, filteredScene.length * 6, gl.UNSIGNED_SHORT, 0);
    }
  }

  static void _drawPost() {
    final gl = flutterGlPlugin.gl;
    gl.cullFace(gl.FRONT_AND_BACK);
    gl.enable(gl.BLEND);
    gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
    for (final tex in usingPostTextures) {
      //print('try $tex');
      Wardrobe.bindByName(tex);
      final List<JQuad> filteredScene =
          List.from(post.where((element) => element.atom.textureName == tex));
      dynamic vao;
      var vertices = Float32Array(filteredScene.length * 36);
      for (int i = 0; i < filteredScene.length; i++) {
        //print('drawint ${filteredScene[i].atom}');
        final z = filteredScene[i].z;
        final r = filteredScene[i].r;
        final g = filteredScene[i].g;
        final b = filteredScene[i].b;
        final a = filteredScene[i].a;
        final x1 = filteredScene[i].x1;
        final y1 = filteredScene[i].y1;
        final x2 = filteredScene[i].x2;
        final y2 = filteredScene[i].y2;
        final x3 = filteredScene[i].x3;
        final y3 = filteredScene[i].y3;
        final x4 = filteredScene[i].x4;
        final y4 = filteredScene[i].y4;

        final xl = filteredScene[i].atom.tx1;
        final xr = filteredScene[i].atom.tx2;
        final yd = filteredScene[i].atom.ty1;
        final yu = filteredScene[i].atom.ty2;

        vertices[i * 36 + 0] = x1;
        vertices[i * 36 + 1] = y1;
        vertices[i * 36 + 2] = z;
        vertices[i * 36 + 3] = r;
        vertices[i * 36 + 4] = g;
        vertices[i * 36 + 5] = b;
        vertices[i * 36 + 6] = a;
        vertices[i * 36 + 7] = xl;
        vertices[i * 36 + 8] = yd;

        vertices[i * 36 + 9] = x2;
        vertices[i * 36 + 10] = y2;
        vertices[i * 36 + 11] = z;
        vertices[i * 36 + 12] = r;
        vertices[i * 36 + 13] = g;
        vertices[i * 36 + 14] = b;
        vertices[i * 36 + 15] = a;
        vertices[i * 36 + 16] = xl;
        vertices[i * 36 + 17] = yu;

        vertices[i * 36 + 18] = x3;
        vertices[i * 36 + 19] = y3;
        vertices[i * 36 + 20] = z;
        vertices[i * 36 + 21] = r;
        vertices[i * 36 + 22] = g;
        vertices[i * 36 + 23] = b;
        vertices[i * 36 + 24] = a;
        vertices[i * 36 + 25] = xr;
        vertices[i * 36 + 26] = yu;

        vertices[i * 36 + 27] = x4;
        vertices[i * 36 + 28] = y4;
        vertices[i * 36 + 29] = z;
        vertices[i * 36 + 30] = r;
        vertices[i * 36 + 31] = g;
        vertices[i * 36 + 32] = b;
        vertices[i * 36 + 33] = a;
        vertices[i * 36 + 34] = xr;
        vertices[i * 36 + 35] = yd;
      }
      // 1-2-3 1-3-4

      vao = gl.createVertexArray();
      gl.bindVertexArray(vao);

      // Create a buffer object
      var vertexBuffer = gl.createBuffer();
      if (vertexBuffer == null) {
        if (kDebugMode) {
          print('Failed to create the buffer object');
        }
        return;
      }
      var stride = Float32List.bytesPerElement * 9;
      gl
        ..bindBuffer(gl.ARRAY_BUFFER, vertexBuffer)
        ..bufferData(
            gl.ARRAY_BUFFER, vertices.length / 9, vertices, gl.STATIC_DRAW)
        ..vertexAttribPointer(
            JShader.positionSlot, 3, gl.FLOAT, false, stride, 0)
        ..enableVertexAttribArray(JShader.positionSlot);

      var texCoordBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, texCoordBuffer);
      gl.bufferData(
          gl.ARRAY_BUFFER, vertices.length / 9, vertices, gl.STATIC_DRAW);
      gl.enableVertexAttribArray(JShader.textureSlot);
      var size = 2; // 2 components per iteration
      var type = gl.FLOAT; // the data is 32bit floats
      const normalize = false; // don't normalize the data

      var offset = Float32List.bytesPerElement *
          7; // start at the beginning of the buffer
      gl.vertexAttribPointer(
          JShader.textureSlot, size, type, normalize, stride, offset);

      final colorBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, colorBuffer);
      gl.bufferData(
          gl.ARRAY_BUFFER, vertices.length / 9, vertices, gl.STATIC_DRAW);
      gl.enableVertexAttribArray(JShader.colorSlot);
      size = 4;
      type = gl.FLOAT; // the data is 32bit floats

      offset = Float32List.bytesPerElement * 3;
      gl.vertexAttribPointer(
          JShader.colorSlot, size, type, normalize, stride, offset);

      //gl.drawArrays(gl.TRIANGLES, 0, n);
      final dynamic ibo = gl.createBuffer();
      gl
        ..bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibo)
        ..bufferData(gl.ELEMENT_ARRAY_BUFFER, filteredScene.length * 6, index,
            gl.STATIC_DRAW);
      gl.drawElements(
          gl.TRIANGLES, filteredScene.length * 6, gl.UNSIGNED_SHORT, 0);
    }
  }

  static int _previous = 0;

  static void render() {
    final timestamp = DateTime.timestamp().microsecondsSinceEpoch;
    final durationDelta = timestamp - _previous;
    final dt = durationDelta / Duration.microsecondsPerSecond;

    if (_previous != 0) TextureAtom.aniCounter += dt;
    if (TextureAtom.aniCounter > 2) TextureAtom.aniCounter = 0;
    if (TextureAtom.aniCounter > 1) TextureAtom.aniCounter -= 1;
    if (TextureAtom.aniCounter < 0) TextureAtom.aniCounter += 1;
    _previous = timestamp;
    if (scene.isNotEmpty) {
      JShader.useProgram(1);
      JCamera.prepare();
      _drawScene();
    }
    if (post.isNotEmpty) {
      JShader.useProgram(1);
      JCamera.prepare();
      _drawPost();
    }
    if (lines.isNotEmpty || rects.isNotEmpty) {
      JShader.useProgram(0);
      if (lines.isNotEmpty) _drawLines();
      if (rects.isNotEmpty) _drawRects();
    }
  }

  static void clearScene() {
    scene = [];
    lines = [];
    rects = [];
    post = [];
    usingPostTextures.clear();
    usingTextures.clear();
  }

  static void addLine(JLine line) {
    lines.add(line);
  }

  static void addRect(JRect rect) {
    rects.add(rect);
  }

  static void addBox(double x, double y, double z, double len, double hgt,
      double a, double r, double g, double b) {
    lines
      ..add(JLine(x, y, z, x + len, y, z, r, g, b, a))
      ..add(JLine(x, y + hgt, z, x + len, y + hgt, z, r, g, b, a))
      ..add(JLine(x, y, z, x, y + hgt, z, r, g, b, a))
      ..add(JLine(x + len, y, z, x + len, y + hgt, z, r, g, b, a));
  }

  static void addSprite(JFlat sprite) {
    scene.add(sprite);
    if (!usingTextures.any((element) => element == sprite.atom.textureName)) {
      usingTextures.add(sprite.atom.textureName);
    }
  }

  static void addQuad(JQuad quad) {
    post.add(quad);
    if (!usingPostTextures.any((element) => element == quad.atom.textureName)) {
      usingPostTextures.add(quad.atom.textureName);
    }
  }

  static Future<bool> init({required int engineLen, required int engineHgt}) async {
    Engine.engineLen = engineLen;
    Engine.engineHgt = engineHgt;
    Engine.flutterGlPlugin = FlutterGlPlugin();

    final options = <String, dynamic>{
      'antialias': true,
      'alpha': true,
      'width': Engine.engineLen,
      'height': Engine.engineHgt,
      'dpr': 1.0
    };

    await Engine.flutterGlPlugin.initialize(options: options);
    for (var i = 0; i < 10500; i++) {
      index[i * 6 + 0] = i * 4 + 0;
      index[i * 6 + 1] = i * 4 + 1;
      index[i * 6 + 2] = i * 4 + 2;
      index[i * 6 + 3] = i * 4 + 0;
      index[i * 6 + 4] = i * 4 + 2;
      index[i * 6 + 5] = i * 4 + 3;
    }
    return true;
  }
}
