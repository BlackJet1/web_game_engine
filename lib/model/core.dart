import 'package:web_game_engine/model/textureatom_model.dart';

class JSprite {
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

  JSprite(
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
