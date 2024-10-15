import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Mstrings {
  late String data;
  late String name;

  Mstrings(this.name, this.data);
}

class Mimage {
  late Uint8List data;
  final String name;

  Mimage(this.name);
}

// класс для работы с файлами (в частности изображениями) из ассетов
class Manager {
  static List<Mstrings> textData = [];
  static List<Mimage> imageData = [];

  static void init() {
    textData.clear();
    imageData.clear();
  }

  static Future<String> _loadString(String name) => rootBundle.loadString(name);

  static Future<void> loadSAssetString(String path, String name) async {
    if (textData.any((element) => element.name == name)) {
      if (kDebugMode) {
        print('$name already used. This path=$path');
      }
      // если такое имя уже было, нужно подумать, что сделать. пока отказываемся грузить
      return;
    }
    final data = await _loadString('$path$name');
    if (data.isNotEmpty) {
      textData.add(Mstrings(name, data));
      if (kDebugMode) {
        print('manager=> loaded $path$name');
      }
    } else {
      if (kDebugMode) {
        print('error loading $path$name');
      }
    }
  }

  static String getString(String name) {
    if (textData.any((element) => element.name == name)) {
      return textData.where((element) => element.name == name).first.data;
    }
    return '';
  }

  static Future<bool> loadImageAsset(String name) async {
    final img = AssetImage('bloc/images/$name');
    const config = ImageConfiguration.empty;
    final key = await img.obtainKey(config);
    final data = await key.bundle.load(key.name);
    imageData.add(Mimage(name));
    imageData.firstWhere((element) => element.name == name).data = Uint8List.fromList(data.buffer.asUint8List());
    if (kDebugMode) {
      print('manager => loaded $name');
    }
    return true;
  }
}
