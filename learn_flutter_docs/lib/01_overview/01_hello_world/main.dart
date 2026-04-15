import 'package:flutter/material.dart';

void main() {
  //设置应用的根组件
  runApp(
    //根组件会充满屏幕
    const Center(
      child: Text(
        'Hello World',
        //text组件必须定义文字方向
        textDirection: TextDirection.ltr,
        style: TextStyle(color: Colors.red),
      ),
    ),
  );
}
