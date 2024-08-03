import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'hex_title.dart';
import 'main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WindowManager.instance.ensureInitialized();
  WindowManager.instance.setTitleBarStyle(TitleBarStyle.hidden);

  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(1200, 800));
    WindowManager.instance.setMaximumSize(const Size(1200, 800));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decoder',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
      ),
      home: const Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [HexTitle(), Expanded(child: MainPage())],
        ),
      ),
    );
  }
}
