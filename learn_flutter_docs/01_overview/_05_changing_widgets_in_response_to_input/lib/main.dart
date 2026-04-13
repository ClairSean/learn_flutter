import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: Counter())),
    ),
  );
}

//组件是临时对象，根据状态变化会刷新
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

//状态是永久对象，记录状态和组件构成内容
class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //不同组件职责分离，有专门管输入的，有专门管显示的;这使得单组件可以完成更复杂的逻辑，同时保持各个组件方便维护
        //通过回调函数实现变更指示“向上流”
        CounterIncrementor(onPressed: _increment),
        const SizedBox(width: 16),
        //当前状态通过参数"向下流"
        CounterDisplay(count: _counter),
      ],
    );
  }
}

//专门负责显示数据的组件
class CounterDisplay extends StatelessWidget {
  const CounterDisplay({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}

//专门负责输入的组件
class CounterIncrementor extends StatelessWidget {
  const CounterIncrementor({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Incrementor'),
    );
  }
}
