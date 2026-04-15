import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 许多布局都可以随意的用 Container，它可以将使用了 padding 或者增加了 borders/margins 的 widget 分开。你可以通过将整个布局放到一个 Container 中，并且改变它的背景色或者图片，来改变设备的背景。
/// Summary (Container)
/// 摘要 (Container)
///   增加 padding、margins、borders
///   改变背景色或者图片
///   只包含一个子 widget，但是这个子 widget 可以是 Row、Column 或者是 widget 树的根 widget

void main() {
  debugPaintSizeEnabled = false; //设置为true开启视觉布局
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter layout demo')),
        body: Center(child: _buildImageColumn()),
      ),
    );
  }

  //一列，包含两行
  Widget _buildImageColumn() {
    return Container(
      decoration: const BoxDecoration(color: Colors.grey),
      child: Column(children: [_buildImageRow(1), _buildImageRow(3)]),
    );
  }

  //一行，包含两张图片
  Widget _buildImageRow(int i) {
    return Row(
      children: [_buildDecoratedImage(i), _buildDecoratedImage(i + 1)],
    );
  }

  //图片
  Widget _buildDecoratedImage(int inmageIndex) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 10, color: Colors.black38),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        margin: const EdgeInsets.all(4),
        child: Image.asset(
          'lib/03_layout/01_overview/03_container/images/pic$inmageIndex.jpg',
        ),
      ),
    );
  }
}
