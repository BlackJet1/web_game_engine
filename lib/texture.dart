import 'package:flutter/foundation.dart';
import 'package:web_game_engine/model/texture_model.dart';

class JTexture {
  List<Texture> textures = [];
  void addTexture(Texture texture) {
    textures
      ..removeWhere((element) => element.name == texture.name)
      ..add(texture);
  }

  Texture? getTextureByName(String name) {
    if (textures.where((element) => element.name == name).isEmpty) return null;
    return textures.firstWhere((element) => element.name == name);
  }

  void releaseTextures() {
    for (final e in textures) {
      e.release();
    }
    textures.clear();
  }

  void bindByName(String name) {
    var id = -1;
    for (var i = 0; i < textures.length; i++) {
      if (textures[i].name == name) {
        id = i;
      }
    }
    if (id != -1) {
      textures[id].bind();
    } else {
      if (kDebugMode) {
        print('failed to bind texture $name');
      }
    }
  }
}