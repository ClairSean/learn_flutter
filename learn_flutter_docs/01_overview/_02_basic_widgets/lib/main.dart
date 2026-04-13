import 'package:flutter/material.dart';

void main() {
  runApp(
    //不少material设计的组件需要包含在MaterialApp内，来继承主题
    const MaterialApp(
      title: 'Basic Widgets', //在操作系统的任务切换界面中显示的应用名
      home: SafeArea(child: MyScaffold()),
    ),
  );
}

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      //组织子组件为一列
      child: Column(
        children: [
          //在顶部放了一个MyAppBar，并传入一个widget作为其标题
          //像这样以widget作为属性的代码结构可以使组件可复用
          MyAppBar(title: Text('Basic Widgets')),
          //剩余空间用作页面的主体部分
          const Expanded(child: Center(child: Text('Hello World'))),
        ],
      ),
    );
  }
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({required this.title, super.key});

  final Widget title;

  @override
  Widget build(BuildContext context) {
    //一个高度56、有左右边距的矩形容器
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      //设置背景色
      decoration: BoxDecoration(color: Colors.blue[500]),
      //有一个行子组件来组织其子组件
      child: Row(
        children: [
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.menu),
            tooltip: 'Navigation menu',
          ),
          //Expanded占据其他兄弟组件没有占用的所有空间
          //如果设置了多个Expanded，使用flex属性可以调整它们占据空间的比例
          Expanded(child: title),
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.search),
            tooltip: 'Search',
          ),
        ],
      ),
    );
  }
}
