import 'dart:math';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String title = 'Horizontal List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        //简单的列表
        body: GridView.count(
          crossAxisCount: 3,
          children: List.generate(100, (index) {
            return SizedBox.expand(
              child: Container(
                color: getRandomBrightColor(),
                child: Center(
                  child: Text(
                    'Item ${index + 1}',
                    style: TextTheme.of(context).headlineSmall,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // 生成明亮的随机颜色
  Color getRandomBrightColor() {
    final random = Random();
    return HSVColor.fromAHSV(
      1.0, // Alpha（不透明）
      random.nextDouble() * 360, // Hue（色相）：0-360
      0.7, // Saturation（饱和度）：0.7-1.0 保持高饱和
      1.0, // Value（亮度）：保持最亮
    ).toColor();
  }
}
