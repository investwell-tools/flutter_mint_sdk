import 'package:flutter/material.dart';

import 'screens/mint_demo_screen.dart';

void main() {
  runApp(const MintDemoApp());
}

class MintDemoApp extends StatelessWidget {
  const MintDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mint SDK Demo',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF215E61),
        useMaterial3: true,
      ),
      home: const MintDemoScreen(),
    );
  }
}
