import 'package:web_game_engine/web_game_engine.dart';

class TextureAtom {
  // текстурные координаты
  final double tx1;
  final double ty1;
  final double tx2;
  final double ty2;
  final int ix1;
  final int iy1;
  final int ix2;
  final int iy2;
  final String textureName;
  final int th;
  final int tl;
  final int len;
  final int hgt;

  TextureAtom(this.tx1, this.ty1, this.tx2, this.ty2, this.textureName, this.tl,
      this.th,
      {this.ix1 = 0,
      this.iy1 = 0,
      this.ix2 = 0,
      this.iy2 = 0,
      this.len = 1,
      this.hgt = 1});

  factory TextureAtom.fromJson(Map<String, dynamic> json) {
    final ix1 = int.parse(json['ix1']);
    final iy1 = int.parse(json['iy1']);
    final ix2 = int.parse(json['ix2']);
    final iy2 = int.parse(json['iy2']);
    final textureName = json['texname'] as String;
    final ln = Engine.instance.texture.getTextureByName(textureName)?.len ?? 1;
    final hg = Engine.instance.texture.getTextureByName(textureName)?.hgt ?? 1;
    final tx1 = ix1 / ln;
    final ty1 = iy1 / hg;
    final tx2 = ix2 / ln;
    final ty2 = iy2 / hg;
    final len = (ix1 - ix2).abs();
    final hgt = (iy1 - iy2).abs();
    final tl = ln;
    final th = hg;
    return TextureAtom(tx1, ty1, tx2, ty2, textureName, tl, th,
        ix1: ix1, iy1: iy1, ix2: ix2, iy2: iy2, len: len, hgt: hgt);
  }

  factory TextureAtom.int(
      int x1, int y1, int x2, int y2, String textureName, int tl, int th) {
    final tx1 = x1 / tl;
    final tx2 = x2 / tl;
    final ty1 = y1 / th;
    final ty2 = y2 / th;
    final len = (x2 - x1).abs();
    final hgt = (y2 - y1).abs();
    final ix1 = x1;
    final iy1 = y1;
    final ix2 = x2;
    final iy2 = y2;
    return TextureAtom(tx1, ty1, tx2, ty2, textureName, tl, th,
        ix1: ix1, iy1: iy1, ix2: ix2, iy2: iy2, len: len, hgt: hgt);
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
      };

  @override
  String toString() => '$textureName,$ix1,$iy1,$ix2,$iy2,$tl,$th';
}
