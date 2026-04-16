import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

void main(List<String> args) {
  debugPaintSizeEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //用于标记显示卡片组件还是栈组件
  static const showCard = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Card and Stack')),
        //根据showcard决定显示卡片还是栈
        body: Center(child: showCard ? _buildCard() : _buildStack()),
      ),
    );
  }

  Widget _buildCard() {
    return SizedBox(
      height: 210,
      //卡片是Material风格种用来显示相关信息的组件，默认带有圆角
      //包含三个列表项的卡片
      child: Card(
        //阴影效果
        elevation: 24,
        child: Column(
          children: [
            //Material风格的列表项
            ListTile(
              title: const Text(
                '1625 Main Street',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: const Text('My City, CA 99984'),
              leading: Icon(Icons.restaurant_menu, color: Colors.blue[500]),
            ),
            //分割线
            const Divider(),
            ListTile(
              title: const Text(
                '(408) 555-1212',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: Icon(Icons.contact_phone, color: Colors.blue[500]),
            ),
            ListTile(
              title: const Text('costa@example.com'),
              leading: Icon(Icons.contact_mail, color: Colors.blue[500]),
            ),
          ],
        ),
      ),
    );
  }

  //返回一个栈组件
  Widget _buildStack() {
    return Stack(
      //传入子组件对齐方式
      alignment: const Alignment(0.6, 0.6),
      children: [
        //首个子组件在底层
        //圆形头像组件
        const CircleAvatar(
          backgroundImage: AssetImage(
            'lib/03_layout/01_overview/08_card_and_stack/images/pic.jpg',
          ),
          radius: 100,
        ),
        Container(
          //背景半透明黑色
          decoration: const BoxDecoration(color: Colors.black45),
          child: const Text(
            'Mia B',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
