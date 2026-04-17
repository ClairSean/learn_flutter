import 'package:flutter/material.dart';

///不同数据类型的基类
abstract class ListItem {
  Widget buildTitle(BuildContext context);
  Widget buildSubtitle(BuildContext context);
}

///显示一条标题的列表项
class HeadingItem implements ListItem {
  final String heading;
  HeadingItem({required this.heading});

  @override
  Widget buildSubtitle(BuildContext context) {
    return Text(heading, style: Theme.of(context).textTheme.headlineSmall);
  }

  @override
  Widget buildTitle(BuildContext context) {
    return const SizedBox.shrink();
  }
}

///显示一条消息的列表项
class MessageItem extends ListItem {
  final String sender;
  final String body;

  MessageItem({required this.sender, required this.body});

  @override
  Widget buildTitle(BuildContext context) {
    return Text(sender);
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    return Text(body);
  }
}

///生成项目列表
List<ListItem> generateListItems(int n) {
  return List.generate(n, (i) {
    return i % 6 == 0
        ? HeadingItem(heading: 'Heading $i')
        : MessageItem(sender: 'Sender $i', body: 'Message body $i');
  });
}

///列表视图
Widget listView(List<ListItem> items) {
  //用ListView.builder，需要展示多少列表项就当场生成，而不是一次性生成
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      final item = items[index];
      return ListTile(
        title: item.buildTitle(context),
        subtitle: item.buildSubtitle(context),
      );
    },
  );
}

//主应用类
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    const String title = 'Mixed List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: listView(generateListItems(1000)),
      ),
    );
  }
}

void main(List<String> args) {
  runApp(MyApp());
}
