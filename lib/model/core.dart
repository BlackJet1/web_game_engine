import 'package:web_game_engine/model/textureatom_model.dart';

class JQuad {
  double x1;
  double y1;
  double x2;
  double y2;
  double x3;
  double y3;
  double x4;
  double y4;
  double z;
  TextureAtom atom;
  double a;
  double r;
  double g;
  double b;

  JQuad(this.x1, this.y1, this.x2, this.y2, this.x3, this.y3, this.x4, this.y4,
      this.z, this.atom, this.a, this.r, this.g, this.b);
}

class JFlat {
  final double x;
  final double y;
  final double z;
  final double len;
  final double hgt;
  TextureAtom atom;
  final double r;
  final double g;
  final double b;
  final double a;
  final double angle;
  final double anchorx;
  final double anchory;
  final bool mirrorX;
  final bool mirrorY;
  final int frame = 0;
  final int frameLen = 0;

  JFlat(
    this.x,
    this.y,
    this.z,
    this.len,
    this.hgt,
    this.atom,
    this.r,
    this.g,
    this.b,
    this.a,
    this.angle,
    this.anchorx,
    this.anchory,
    this.mirrorX,
    this.mirrorY,
  );
}

class JLine {
  final double x1;
  final double y1;
  final double z1;
  final double x2;
  final double y2;
  final double z2;
  final double r;
  final double g;
  final double b;
  final double a;

  JLine(
    this.x1,
    this.y1,
    this.z1,
    this.x2,
    this.y2,
    this.z2,
    this.r,
    this.g,
    this.b,
    this.a,
  );
}

class JRect {
  final double x;
  final double y;
  final double z;
  final double len;
  final double hgt;
  final double r;
  final double g;
  final double b;
  final double a;

  JRect(this.x, this.y, this.z, this.len, this.hgt, this.r, this.g, this.b,
      this.a);
}
