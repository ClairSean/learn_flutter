import 'package:flutter/material.dart';

enum ListDemoType { oneLine, twoLine }

class ListDemo extends StatelessWidget {
  final ListDemoType type;

  const ListDemo({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('list_demo_list_view'),
        ),
        //可滚动列表
        body: ListView(
          restorationId: 'list_demo_list_view',
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            //列表中有21个列表项
            for (var index = 1; index < 21; index++)
              ListTile(
                leading: ExcludeSemantics(
                  child: CircleAvatar(child: Text('$index')),
                ),
                title: Text('Item $index'),
                subtitle: type == ListDemoType.twoLine
                    ? const Text('Secondary text')
                    : null,
                trailing: Icon(Icons.turn_right),
              ),
          ],
        ),
      ),
    );
  }
}

void main(List<String> args) {
  runApp(const ListDemo(type: ListDemoType.twoLine));
}
