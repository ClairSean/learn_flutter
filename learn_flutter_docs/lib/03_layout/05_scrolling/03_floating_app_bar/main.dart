import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false),
      title: 'Floating App Bar',
      home: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              forceElevated: true,
              elevation: 30,
              shadowColor: Colors.black87,
              backgroundColor: Colors.grey[100],
              leading: Icon(Icons.shop),
              title: Text('Floating App Bar'),
              //当滚动的时候是否与列表固定
              pinned: false,
              //用图片填充可用的高度
              flexibleSpace: ClipRect(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset(
                    'lib/03_layout/05_scrolling/03_floating_app_bar/images/pic1.jpg',
                  ),
                ),
              ),
              expandedHeight: 200,
            ),
            SliverList.builder(
              itemBuilder: (context, index) {
                return ListTile(title: Text('Item #$index'));
              },
              itemCount: 50,
            ),
          ],
        ),
      ),
    );
  }
}
