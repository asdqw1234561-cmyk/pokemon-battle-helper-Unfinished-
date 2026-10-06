// lib/main.dart
// 앱 진입점 — 이름 기반 라우팅으로 홈 / 데미지 계산기 화면 연결
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(const PokemonBattleHelperApp());
}

class PokemonBattleHelperApp extends StatelessWidget {
  const PokemonBattleHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '포켓몬 배틀 도우미',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.red, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/calculator': (context) => const CalculatorScreen(),
      },
    );
  }
}
