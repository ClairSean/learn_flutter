import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

//使用 GridView.extent 创建一个最大宽度为 150 像素的网格。

void main() {
  debugPaintSizeEnabled = false; //调试模式，画出组件边框和大小信息
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const showGrid = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter layout demo')),
        body: Center(child: showGrid ? _buildGrid() : _buildList()),
      ),
    );
  }

  //可滚动网格组件
  Widget _buildGrid() {
    //规定子元素最大宽度的可滚动网格
    return GridView.extent(
      //子元素最大宽度（逻辑像素）
      maxCrossAxisExtent: 150,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: _buildGridTileList(30),
    );
  }

  //网格子元素列表
  List<Widget> _buildGridTileList(int count) {
    return List.generate(
      count,
      (i) => Image.asset(
        'lib/03_layout/01_overview/04_grid_and_view/images/pic$i.jpg',
      ),
    );
  }

  //可滚动列表
  Widget _buildList() {
    return ListView(
      children: [
        _tile('CineArts at the Empire', '85 W Portal Ave', Icons.theaters),
        _tile('The Castro Theater', '429 Castro St', Icons.theaters),
        _tile('Alamo Drafthouse Cinema', '2550 Mission St', Icons.theaters),
        _tile('Roxie Theater', '3117 16th St', Icons.theaters),
        _tile(
          'United Artists Stonestown Twin',
          '501 Buckingham Way',
          Icons.theaters,
        ),
        _tile('AMC Metreon 16', '135 4th St #3000', Icons.theaters),
        //使用分割线分隔不同类型内容的子组件
        const Divider(),
        _tile('K\'s Kitchen', '757 Monterey Blvd', Icons.restaurant),
        _tile('Emmy\'s Restaurant', '1923 Ocean Ave', Icons.restaurant),
        _tile('Chaiya Thai Restaurant', '272 Claremont Blvd', Icons.restaurant),
        _tile('La Ciccia', '291 30th St', Icons.restaurant),
      ],
    );
  }

  //列表项
  ListTile _tile(String title, String subtitle, IconData icon) {
    return ListTile(
      //使用参数设置标题、副标题、左侧图标
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
      ),
      subtitle: Text(subtitle),
      leading: Icon(icon, color: Colors.blue[500]),
    );
  }
}
