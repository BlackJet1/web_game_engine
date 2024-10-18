import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:web_game_engine/model/texture_model.dart';

import 'package:web_game_engine/model/textureatom_model.dart';

class Wardrobe {
  // платьяной шкаф - набор атомарных объектов
  static Map<String, TextureAtom> graphickAtoms = {};

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
    graphickAtoms.addAll({name: value});
  }


}
