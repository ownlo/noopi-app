import 'package:flutter/material.dart';

import 'webview_page.dart';

void main() => runApp(const NoopiApp());

class NoopiApp extends StatelessWidget {
  const NoopiApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: '누피',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF101426),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF9874FF),
        brightness: Brightness.dark,
      ),
    ),
    home: const NoopiWebViewPage(),
  );
}
