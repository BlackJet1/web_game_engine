import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:web_game_engine/web_game_engine.dart';

class Texture {
  late final String name;
  late final int len;
  late final int hgt;
  late ui.Image uiimage;
  late ByteData pngBytes;

  //late ByteData openglBytes;
  late dynamic textureID;
  late dynamic data;
  bool loaded = false;

  Texture(this.name, this.len, this.hgt) {
    textureID = Engine.flutterGlPlugin.gl.createTexture();
  }

  Texture.fromString(String stringData) {
    name = stringData.split(',')[0];
    len = int.parse(stringData.split(',')[1]);
    hgt = int.parse(stringData.split(',')[2]);
    textureID = Engine.flutterGlPlugin.gl.createTexture();
  }

  Future<bool> load(String serverpathImages) async {
    var completer = Completer<ImageInfo>();
    var img = NetworkImage(serverpathImages + name);
    img.resolve(const ImageConfiguration()).addListener(ImageStreamListener((info, _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    uiimage = imageInfo.image;
    pngBytes = (await uiimage.toByteData(format: ui.ImageByteFormat.png))!;
    ByteData openglBytes = (await uiimage.toByteData(format: ui.ImageByteFormat.rawUnmodified))!;
    data = openglBytes.buffer.asUint8List();

    loaded = true;
    toVideoMemory();
    return true;
  }

  @override
  toString() => '$name,$len,$hgt';

  void toVideoMemory() {
    final gl = Engine.flutterGlPlugin.gl;
    const alignment = 1;
    gl.pixelStorei(gl.UNPACK_ALIGNMENT, alignment);
    gl
      ..activeTexture(gl.TEXTURE0)
      ..bindTexture(gl.TEXTURE_2D, textureID)
      ..texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE)
      ..texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE)
    // Set texture filtering
      ..texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
      ..texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, len, hgt, 0, gl.RGBA, gl.UNSIGNED_BYTE, data);
  }

  void bind() {
    //print('bind texture $name');
    final gl = Engine.flutterGlPlugin.gl;
    gl
      ..activeTexture(gl.TEXTURE0)
      ..bindTexture(gl.TEXTURE_2D, textureID);
    //..uniform1i(JShader.bindtexture, 0);
  }

  void release() {
    if (textureID != null) {
      Engine.flutterGlPlugin.gl.deleteTexture(textureID);
    }
  }
}
