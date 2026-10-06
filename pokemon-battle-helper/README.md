# ⚔️ 포켓몬 배틀 도우미

> 공격자·방어자의 능력치와 기술을 입력하면 **예상 데미지 비율**을 계산해 주는 Flutter 앱입니다.
> 기술을 고르면 위력·타입·분류가 자동으로 입력됩니다.

<!-- 📌 앱 화면 캡처를 여기에 넣으세요
<img src="docs/home.png" width="240"> <img src="docs/calculator.png" width="240">
-->

| 항목 | 내용 |
|---|---|
| 기간 | 2025.03 – 2025.06 (모바일프로그래밍) |
| 인원 | **개인 프로젝트** |
| 기술 | Flutter · Dart |

<br>

## 1. 주요 기능

- **데미지 계산기** — 공격자(기술·종족값·노력치·개체값·성격 보정·랭크·배수)와 방어자 능력치를 한 화면에서 입력
- **기술 자동 입력** — 553개 기술 데이터(18개 타입)에서 드롭다운으로 고르면 위력·타입·분류가 채워짐
- **결과 다이얼로그** — 계산된 예상 데미지 비율을 팝업으로 표시

## 2. 구조

```
lib/
├── main.dart                     # 앱 진입점, 이름 기반 라우팅 ('/', '/calculator')
├── screens/
│   ├── home_screen.dart          # 메인 메뉴
│   ├── calculator_screen.dart    # 능력치 입력 + 계산 로직
│   └── result_screen.dart        # 결과 다이얼로그
├── widgets/
│   └── move_selector.dart        # 기술 선택 드롭다운 (재사용 위젯)
└── utils/
    └── move_data_loader.dart     # JSON → MoveData 모델 변환
assets/
├── move_data.json                # 기술 553개 (이름·타입·분류·위력)
└── pokemon_data.json             # 포켓몬 28종 종족값
```

화면(UI), 재사용 위젯, 데이터 로딩을 폴더로 분리해 각 파일이 한 가지 역할만 맡도록 구성했습니다.

## 3. 핵심 구현

**① 랭크 보정을 반영한 능력치 계산** — [`calculator_screen.dart`](lib/screens/calculator_screen.dart)

```dart
double calculateStat(int base, int ev, int iv, double nature, int rank, double multiplier) {
  double rankRate = [
    0.25, 0.285, 0.33, 0.4, 0.5, 0.66, // -6 ~ -1
    1.0,                               //  0
    1.5, 2.0, 2.5, 3.0, 3.5, 4.0       // +1 ~ +6
  ][rank + 6];
  return (((base + iv / 2 + ev / 8 + 5) * nature) * rankRate) * multiplier;
}
```

랭크(-6 ~ +6)를 `rank + 6` 인덱스로 바꿔 보정 배율 표에서 바로 꺼내 쓰도록 했습니다.

**② 잘못된 데이터에 안전한 JSON 모델** — [`move_data_loader.dart`](lib/utils/move_data_loader.dart)

```dart
factory MoveData.fromJson(Map<String, dynamic> json) {
  return MoveData(
    name: json['name'] ?? '',
    type: json['type'] ?? '',
    category: json['category'] ?? '',
    // 변화기처럼 위력이 없거나 숫자가 아니면 0으로 처리
    power: (json['power'] != null && json['power'] is num) ? json['power'] as num : 0,
  );
}
```

**③ 콜백으로 값을 넘기는 재사용 위젯** — [`move_selector.dart`](lib/widgets/move_selector.dart)
기술 선택 위젯은 데이터를 직접 화면에 쓰지 않고 선택된 `MoveData`를 콜백으로 넘깁니다.
계산기 화면은 받은 값으로 입력칸을 채우기만 하므로, 같은 위젯을 다른 화면에서도 그대로 쓸 수 있습니다.

입력값이 비어 있거나 숫자가 아니면 `int.tryParse`·기본값으로 처리해 앱이 멈추지 않게 했습니다.

## 4. 실행 방법

```bash
flutter create .     # android / ios 등 플랫폼 폴더 생성 (최초 1회)
flutter pub get
flutter run
```

## 5. 회고와 개선할 점

- 현재 데미지 식은 `위력 × 공격 실수치 ÷ 방어 실수치`의 **간이 비율**입니다. 레벨·타입 상성·자속 보정·난수를 반영한 실제 데미지 공식으로 확장하면 더 실용적입니다.
- `pokemon_data.json`(종족값)은 준비만 해 두고 아직 화면에 연결하지 않았습니다. 포켓몬을 고르면 종족값이 자동 입력되도록 붙이는 것이 다음 단계입니다.
- 초기 기획에 있던 **배틀 퀴즈** 화면은 구현하지 못해 메뉴에서 제외했습니다.
