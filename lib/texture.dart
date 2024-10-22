import 'package:web_game_engine/model/texture_model.dart';

class JTexture {
  Map<String, Texture> textures = {};

  void addTexture(String name, texture) {
    textures.addAll({name: texture});
  }

  Texture? getTextureByName(String name) {
    return textures[name];
  }

  void releaseTextures() {
    for (final e in textures.values) {
      e.release();
    }
    textures.clear();
  }

  void bindByName(String name) {
    if (textures[name] != null) {
      textures[name]!.bind();
    }
  }
}
