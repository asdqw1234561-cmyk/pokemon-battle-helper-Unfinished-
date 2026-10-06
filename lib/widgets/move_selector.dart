// lib/widgets/move_selector.dart
// 기술 선택 드롭다운 UI 및 자동 데이터 반영 위젯
import 'package:flutter/material.dart';
import '../utils/move_data_loader.dart'; // move_data.json 로드 함수

class MoveSelector extends StatefulWidget {
  // 선택된 기술 전체(MoveData)를 넘겨, 호출하는 쪽에서 필요한 값만 꺼내 쓰도록 함
  final ValueChanged<MoveData> onMoveSelected;

  const MoveSelector({super.key, required this.onMoveSelected});

  @override
  State<MoveSelector> createState() => _MoveSelectorState();
}

class _MoveSelectorState extends State<MoveSelector> {
  List<MoveData> moves = [];
  String? selectedMove;

  @override
  void initState() {
    super.initState();
    loadMoveData().then((loadedMoves) {
      setState(() {
        moves = loadedMoves;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedMove,
      hint: const Text('기술 선택'),
      items: moves.map((move) {
        return DropdownMenuItem(
          value: move.name,
          child: Text(move.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedMove = value;
        });
        final move = moves.firstWhere((m) => m.name == value);
        widget.onMoveSelected(move);
      },
    );
  }
}