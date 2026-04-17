import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}

///生成指定长度的字符串列表
List<String> generateList(int n) => List<String>.generate(n, (i) => 'Item $i');

///生成列表组件
Widget buildListView(List<String> items) {
  //只渲染屏幕上可见列表项，很丝滑
  return ListView.builder(
    //列表长度
    itemCount: items.length,
    //flutter根据原型计算每个列表项长度，前提是所有列表项高度必须相同
    prototypeItem: ListTile(title: Text(items.first)),
    //只渲染屏幕上可见列表项
    itemBuilder: (context, index) {
      return ListTile(title: Text(items[index]));
    },
  );
  //一次性生成所有列表项，卡到用不了
  // return ListView(
  //   children: [for (String str in items) ListTile(title: Text(str))],
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String title = 'Long List';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: buildListView(generateList(1e7.toInt())),
      ),
    );
  }
}
