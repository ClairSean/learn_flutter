import 'package:flutter/material.dart';

void main() {
  runApp(
    //使用安卓风格组件
    const MaterialApp(title: 'Using Material Components', home: TutorialHome()),
  );
}

class TutorialHome extends StatelessWidget {
  const TutorialHome({super.key});
  @override
  Widget build(BuildContext context) {
    //MaterialApp内部组件自动继承MaterialApp的默认主题
    return Scaffold(
      //组件作为参数传入组件，例如leading、title、actions
      //在制作通用组件时，接受其他组件作为属性
      appBar: AppBar(
        leading: const IconButton(
          onPressed: null,
          icon: Icon(Icons.menu),
          tooltip: 'Navigation menu',
        ),
        title: const Text('Example title'),
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.search),
            tooltip: 'Search',
          ),
        ],
      ),
      body: const Center(child: Text('Hello World')),
      //悬浮操作按钮
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
