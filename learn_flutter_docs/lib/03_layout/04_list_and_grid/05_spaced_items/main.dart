import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(SpacedItemsList());
}

class SpacedItemsList extends StatelessWidget {
  const SpacedItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    const count = 10;
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme: CardThemeData(color: Colors.blue.shade50),
      ),
      home: Scaffold(
        body: LayoutBuilder(
          //向下提供上下文和约束对象
          builder: (context, constraints) {
            //使子元素可以滚动
            return SingleChildScrollView(
              //为子元素添加约束
              child: ConstrainedBox(
                //使子元素高度至少与LayoutBuilder提供的约束高度相同
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  //子元素纵向间隔相同，横向充满可用空间
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(
                    count,
                    (index) => ItemWidget(text: 'Item $index'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final String text;
  const ItemWidget({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      //卡片自带4的外边距
      margin: EdgeInsets.all(4),
      elevation: 24,
      child: SizedBox(height: 100, child: Center(child: Text(text))),
    );
  }
}
