import 'package:flutter/foundation.dart';
import 'package:web_game_engine/manager.dart';
import 'package:web_game_engine/web_game_engine.dart';

class JShader {
  static int currentProgram = -1;
  static late dynamic positionSlot;
  static late dynamic textureSlot;
  static late dynamic colorSlot;
  //static late dynamic bindtexture;
  static late dynamic animationSlot;
  static late dynamic cameraSlot;

  static List<dynamic> programsHandle = List.filled(256, -1);

  static void release() {
    for (var q = 0; q < 256; q++) {
      if (programsHandle[q] != -1) deleteProgram(q);
    }
    programsHandle = List.filled(256, -1);
  }

  static void prepareSlots(dynamic programHandle, gl) {
    positionSlot = gl.getAttribLocation(programHandle, 'vPosition');
    textureSlot = gl.getAttribLocation(programHandle, 'vTex');
    colorSlot = gl.getAttribLocation(programHandle, 'vColor');
    //bindtexture = gl.getUniformLocation(programHandle, 'tTexture');
    //print('bindtexture slot: $bindtexture');
    cameraSlot = gl.getUniformLocation(programHandle, 'camera');
  }

  // класс для упрощения работы с вершинными и фрагментыми шейдерами
  static String loadAsset(String name) {
    if (kDebugMode) {
      print('begin loading asset; $name');
    }
    return Manager.getString(name);
  }

  static dynamic stringShader(int type, String source) {
    currentProgram = -1;
    final gl = Engine.flutterGlPlugin.gl;
    final shader = gl.createShader(type);
    if (shader == 0) {
      if (kDebugMode) {
        print('Error: failed to create shader.');
      }
      return 0;
    }

    if (kDebugMode) {
      print('Loaded Shader');
    }

    gl.shaderSource(shader, source);

    // Compile the shader
    gl.compileShader(shader);
    var res = gl.getShaderParameter(shader, gl.COMPILE_STATUS);
    if (res == 0 || res == false) {
      if (kDebugMode) {
        print("Error compiling shader: ${gl.getShaderInfoLog(shader)}");
      }
    }

    return shader;
  }

  static int assetShader(int type, String filename) {
    final shaderStr = loadAsset(filename);
    return stringShader(type, shaderStr);
  }

  static int assetProgram(String vertex, String fragment) {
    final gl = Engine.flutterGlPlugin.gl;
    final vertexShader = assetShader(gl.VERTEX_SHADER, vertex);
    if (vertexShader == 0) {
      if (kDebugMode) {
        print('error vertex shader');
      }
      return 0;
    }

    final fragmentShader = assetShader(gl.FRAGMENT_SHADER, fragment);
    if (fragmentShader == 0) {
      gl.deleteShader(vertexShader);
      if (kDebugMode) {
        print('error fragment shader');
      }
      return 0;
    }

    // Create the program object
    final programHandle = gl.createProgram();
    if (programHandle == 0) {
      if (kDebugMode) {
        print('error creating programm');
      }
      return 0;
    }

    gl
      ..attachShader(programHandle, vertexShader)
      ..attachShader(programHandle, fragmentShader)
      ..linkProgram(programHandle)
      ..deleteShader(vertexShader)
      ..deleteShader(fragmentShader);
    if (kDebugMode) {
      print('create program=$programHandle');
    }
    return programHandle as int;
  }

  static dynamic stringProgramm(String vertex, String fragment) {
    final gl = Engine.flutterGlPlugin.gl;
    final vertexShader = stringShader(gl.VERTEX_SHADER, vertex);
    if (vertexShader == 0) {
      if (kDebugMode) {
        print('error vertex shader');
      }
      return 0;
    }

    final fragmentShader = stringShader(gl.FRAGMENT_SHADER, fragment);
    if (fragmentShader == 0) {
      gl.deleteShader(vertexShader);
      if (kDebugMode) {
        print('error fragment shader');
      }
      return 0;
    }

    // Create the program object
    final programHandle = gl.createProgram();
    if (programHandle == 0) {
      if (kDebugMode) {
        print('error creating programm');
      }
      return 0;
    }

    gl
      ..attachShader(programHandle, vertexShader)
      ..attachShader(programHandle, fragmentShader)
      ..linkProgram(programHandle);
    if (kDebugMode) {
      print('create program=$programHandle');
    }
    return programHandle;
  }

  static void loadProgram(int slot, String vertex, String fragment) {
    programsHandle[slot] = assetProgram(vertex, fragment);
  }

  static void creareProgram(int slot, String vertex, String fragment) {
    programsHandle[slot] = stringProgramm(vertex, fragment);
  }

  static void useProgram(int slot) {
    if (slot==currentProgram) return;
    currentProgram = slot;
    final gl = Engine.flutterGlPlugin.gl;
    gl.useProgram(programsHandle[slot]);
    prepareSlots(programsHandle[slot], gl);
    return;
    /*gl
      ..bindBuffer(gl.ELEMENT_ARRAY_BUFFER, JFlat.ibo)
      ..enable(gl.PRIMITIVE_RESTART_FIXED_INDEX)
      ..enableVertexAttribArray(JShader.positionSlot)
      ..enableVertexAttribArray(JShader.textureSlot)
      ..enableVertexAttribArray(JShader.colorSlot);

     */
  }

  static void deleteProgram(int slot) {
    final gl = Engine.flutterGlPlugin.gl;
    gl.deleteProgram(programsHandle[slot]);
  }
}
