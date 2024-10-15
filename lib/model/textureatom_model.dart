import 'package:web_game_engine/wardrobe.dart';

class TextureAtom {
  static double aniCounter = 0;

  // текстурные координаты
  late double tx1;
  late double ty1;
  late double tx2;
  late double ty2;
  late int ix1;
  late int iy1;
  late int ix2;
  late int iy2;
  late String textureName;
  late final int th;
  late final int tl;
  int fps = 0;
  int frames = 1;
  int len = 1;
  int hgt = 1;

  TextureAtom(this.tx1, this.ty1, this.tx2, this.ty2, this.textureName,
      this.fps, this.frames, this.tl, this.th);

  factory TextureAtom.fromJson(Map<String, dynamic> json) {
    final ix1 = int.parse(json['ix1']);
    final iy1 = int.parse(json['iy1']);
    final ix2 = int.parse(json['ix2']);
    final iy2 = int.parse(json['iy2']);
    final textureName = json['texname'] as String;
    final frames = int.parse(json['frames']);
    final fps = int.parse(json['fps']).clamp(1, 10000);
    final ln = Wardrobe.getTextureByName(textureName)?.len ?? 1;
    final hg = Wardrobe.getTextureByName(textureName)?.hgt ?? 1;
    final tx1 = ix1 / ln;
    final ty1 = iy1 / hg;
    final tx2 = ix2 / ln;
    final ty2 = iy2 / hg;
    final len = (ix1 - ix2).abs();
    final hgt = (iy1 - iy2).abs();
    final tl = ln;
    final th = hg;
    return TextureAtom(tx1, ty1, tx2, ty2, textureName, fps, frames, tl, th)
      ..hgt = hgt
      ..len = len
      ..iy1 = iy1
      ..iy2 = iy2
      ..ix1 = ix1
      ..ix2 = ix2;
  }

  TextureAtom.int(
      int x1, int y1, int x2, int y2, this.textureName, this.tl, this.th) {
    tx1 = x1 / tl;
    tx2 = x2 / tl;
    ty1 = y1 / th;
    ty2 = y2 / th;
    frames = 1;
    fps = 1;
    len = (x2 - x1).abs();
    hgt = (y2 - y1).abs();
    ix1 = x1;
    iy1 = y1;
    ix2 = x2;
    iy2 = y2;
  }

  TextureAtom.ltwh(
      int x, int y, this.len, this.hgt, this.textureName, this.tl, this.th) {
    tx1 = x / tl;
    tx2 = (x + len) / tl;
    ty1 = (y + hgt) / th;
    ty2 = y / th;
    frames = 1;
    fps = 1;
  }

  TextureAtom.parse(String data) {
    /*
    парсинг текстурных координат
    сначала имя файла текстуры, потом координаты
     */
    tx1 = tx2 = ty1 = ty2 = 0;
    textureName = '';
    final parts = data.split(',');
    if (parts.length < 5) return;
    textureName = parts[0];
    tl = Wardrobe.getTextureByName(textureName)?.len ?? 1;
    th = Wardrobe.getTextureByName(textureName)?.hgt ?? 1;
    ix1 = int.parse(parts[1].replaceAll(' ', ''));
    iy1 = int.parse(parts[2].replaceAll(' ', ''));
    ix2 = int.parse(parts[3].replaceAll(' ', ''));
    iy2 = int.parse(parts[4].replaceAll(' ', ''));
    if (parts.length > 4) {
      frames = int.parse(parts[5]);
    } else {
      frames = 1;
    }
    if (parts.length > 5) {
      fps = int.parse(parts[6]).clamp(1, 1000);
    } else {
      fps = 1;
    }
    if (fps < 1) fps = 1;
    tx1 = ix1 / tl;
    ty1 = iy1 / th;
    tx2 = ix2 / tl;
    ty2 = iy2 / th;
    len = (ix1 - ix2).abs();
    hgt = (iy1 - iy2).abs();
  }

  Map<String, dynamic> toJson() => {
        'ix1': ix1,
        'iy1': iy1,
        'ix2': ix2,
        'iy2': iy2,
        'len': len,
        'hgt': hgt,
        'tl': tl,
        'th': th,
        'textureName': textureName,
        'fps': fps,
        'frames': frames,
      };

  @override
  String toString() => '$textureName,$ix1,$iy1,$ix2,$iy2,$fps,$frames,$tl,$th';
}
