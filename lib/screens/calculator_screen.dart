// lib/screens/calculator_screen.dart
// Flutter UI - 한 화면에서 공격자/방어자 정보 입력 및 데미지 계산
// MoveSelector 통합 및 기술 자동 반영 기능 포함

import 'package:flutter/material.dart';
import 'result_screen.dart';
import '../utils/move_data_loader.dart';
import '../widgets/move_selector.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // 공격자 입력 컨트롤러
  final TextEditingController atkBaseController = TextEditingController();
  final TextEditingController atkEvController = TextEditingController();
  final TextEditingController atkIvController = TextEditingController();
  final TextEditingController atkNatureController = TextEditingController();
  final TextEditingController atkRankController = TextEditingController();
  final TextEditingController atkMultiplierController = TextEditingController();
  final TextEditingController atkPowerController = TextEditingController();
  final TextEditingController atkTypeController = TextEditingController();
  final TextEditingController atkCategoryController = TextEditingController();

  // 방어자 입력 컨트롤러
  final TextEditingController defBaseController = TextEditingController();
  final TextEditingController defEvController = TextEditingController();
  final TextEditingController defIvController = TextEditingController();
  final TextEditingController defNatureController = TextEditingController();
  final TextEditingController defRankController = TextEditingController();
  final TextEditingController defMultiplierController = TextEditingController();

  double parseOrDefault(String? value, double defaultValue) {
    if (value == null || value.trim().isEmpty) return defaultValue;
    return double.tryParse(value) ?? defaultValue;
  }

  double calculateStat(int base, int ev, int iv, double nature, int rank, double multiplier) {
    double rankRate = [
      0.25, 0.285, 0.33, 0.4, 0.5, 0.66, // -6 ~ -1
      1.0,  // 0
      1.5, 2.0, 2.5, 3.0, 3.5, 4.0       // +1 ~ +6
    ][rank + 6];
    return (((base + iv / 2 + ev / 8 + 5) * nature) * rankRate) * multiplier;
  }

  void calculateDamage() {
    final int atkBase = int.tryParse(atkBaseController.text) ?? 0;
    final int atkEv = int.tryParse(atkEvController.text) ?? 0;
    final int atkIv = int.tryParse(atkIvController.text) ?? 0;
    final double atkNature = parseOrDefault(atkNatureController.text, 1);
    final int atkRank = int.tryParse(atkRankController.text) ?? 0;
    final double atkMultiplier = parseOrDefault(atkMultiplierController.text, 1);
    final int atkPower = int.tryParse(atkPowerController.text) ?? 0;

    final int defBase = int.tryParse(defBaseController.text) ?? 0;
    final int defEv = int.tryParse(defEvController.text) ?? 0;
    final int defIv = int.tryParse(defIvController.text) ?? 0;
    final double defNature = parseOrDefault(defNatureController.text, 1);
    final int defRank = int.tryParse(defRankController.text) ?? 0;
    final double defMultiplier = parseOrDefault(defMultiplierController.text, 1);

    final double attackStat = calculateStat(atkBase, atkEv, atkIv, atkNature, atkRank, atkMultiplier);
    final double defenseStat = calculateStat(defBase, defEv, defIv, defNature, defRank, defMultiplier);

    final double damagePercent = ((atkPower * attackStat) / (defenseStat == 0 ? 1 : defenseStat));

    showDialog(
      context: context,
      builder: (context) => ResultScreen(
        resultText: "예상 데미지 비율: ${damagePercent.toStringAsFixed(2)}%",
      ),
    );
  }

  Widget buildStatInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('데미지 계산기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: calculateDamage,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("공격자 입력", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            MoveSelector(
              onMoveSelected: (move) {
                atkPowerController.text = move.power.toString();
                atkTypeController.text = move.type;
                atkCategoryController.text = move.category;
              },
            ),
            buildStatInput("기술 타입", atkTypeController),
            buildStatInput("기술 분류", atkCategoryController),
            buildStatInput("기술 위력", atkPowerController),
            buildStatInput("종족값", atkBaseController),
            buildStatInput("노력치", atkEvController),
            buildStatInput("개체값", atkIvController),
            buildStatInput("성격보정", atkNatureController),
            buildStatInput("랭크업", atkRankController),
            buildStatInput("배수", atkMultiplierController),
            const SizedBox(height: 16),
            const Text("방어자 입력", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            buildStatInput("종족값", defBaseController),
            buildStatInput("노력치", defEvController),
            buildStatInput("개체값", defIvController),
            buildStatInput("성격보정", defNatureController),
            buildStatInput("랭크업", defRankController),
            buildStatInput("배수", defMultiplierController),
          ],
        ),
      ),
    );
  }
}