import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:web_game_engine/model/texture_model.dart';

import 'package:web_game_engine/model/textureatom_model.dart';

class Wardrobe {
  // платьяной шкаф - набор атомарных объектов
  static Map<String, TextureAtom> graphickAtoms = {};
  static List<Texture> textures = [];

  static TextureAtom getAtombyName(String name) {
    try {
      return graphickAtoms.entries
          .firstWhere((element) => element.key == name)
          .value;
    } catch (e) {
      log('missing atom: $name');
      return TextureAtom(0, 0, 0, 0, '', 0, 0, 1, 1);
    }
  }

  static void addAtom(String name, TextureAtom value) {
    graphickAtoms
      ..removeWhere((key, value) => key == name)
      ..addAll({name: value});
  }

  static void addTexture(Texture texture) {
    textures
      ..removeWhere((element) => element.name == texture.name)
      ..add(texture);
  }

  static Texture? getTextureByName(String name) {
    if (textures.where((element) => element.name == name).isEmpty) return null;
    return textures.firstWhere((element) => element.name == name);
  }

  static void releaseTextures() {
    for (final e in textures) {
      e.release();
    }
    textures.clear();
  }

  static void bindByName(String name) {
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
