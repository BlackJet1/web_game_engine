import 'dart:html' as html;
import 'package:example/game.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter/material.dart';
import 'package:web_game_engine/web_game_engine.dart';

void main() async {
  //await export();
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(null);
  Engine.init(engineLen: 1280, engineHgt: 720);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    html.document.onContextMenu.listen((event) => event.preventDefault());
    return MaterialApp(
      theme: ThemeData(
          canvasColor: Colors.white,
          textTheme: Theme.of(context).textTheme.apply(
              decoration: TextDecoration.none,
              bodyColor: const Color.fromARGB(255, 0, 0, 0),
              fontSizeFactor: 1.5)),
      home: Scaffold(
        body: const PlayGameWidget(),
        appBar: AppBar(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
