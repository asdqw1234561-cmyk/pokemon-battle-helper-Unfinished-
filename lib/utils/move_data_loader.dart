// lib/utils/move_data_loader.dart
import 'dart:convert';
import 'package:flutter/services.dart';

class MoveData {
  final String name;
  final String type;
  final String category;
  final num power;

  MoveData({
    required this.name,
    required this.type,
    required this.category,
    required this.power,
  });

  // JSON 데이터를 객체로 변환 (null 또는 잘못된 값은 0 처리)
  factory MoveData.fromJson(Map<String, dynamic> json) {
    return MoveData(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      power: (json['power'] != null && json['power'] is num)
          ? json['power'] as num
          : 0,
    );
  }
}

// JSON 파일에서 기술 데이터를 비동기로 로드
Future<List<MoveData>> loadMoveData() async {
  final String jsonString = await rootBundle.loadString('assets/move_data.json');
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((json) => MoveData.fromJson(json)).toList();
}