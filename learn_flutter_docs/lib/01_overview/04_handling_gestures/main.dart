//应用的重点之一是处理交互，也就是检测输入手势，以下是一个创建简单按钮的示例
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: MyButton())),
    ),
  );
}

class MyButton extends StatelessWidget {
  const MyButton({super.key});
  @override
  Widget build(BuildContext context) {
    //GestureDetector组件本身没有视觉效果，但是可以检测手势（调整参数可以检测点击、拖拉和缩放）
    //不少组件使用GestureDetector来给其他组件提供可选的回调函数，例如IconButton, ElevatedButton, FloatingActionButton的onPressed属性
    return GestureDetector(
      onTap: () {
        print('MyButton was tapped...');
      },
      //当用户点击容器，GestureDetector调用ontap回调方法
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.lightGreen[500],
        ),
        child: const Center(child: Text('Engage')),
      ),
    );
  }
}
