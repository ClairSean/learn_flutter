import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = '布局组件';
    return MaterialApp(
      title: appTitle,
      //选择一个布局组件
      home: Scaffold(
        appBar: AppBar(title: const Text(appTitle)),
        body: const Center(
          //创建可见组件
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
