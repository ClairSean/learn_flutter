import 'package:flutter/material.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/common/app_initializer.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/ui/home/view/home_screen.dart';

void main() async {
  // 初始化应用
  await AppInitializer.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '待办事项',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
