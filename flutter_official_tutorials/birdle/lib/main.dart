import 'package:birdle/game.dart';
import 'package:flutter/material.dart';

//所有dart程序的入口
void main() {
  //运行flutter应用的入口方法，传入顶层组件作为应用根组件
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  //初始化父类的key
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Align(alignment: Alignment.centerLeft, child: Text('Birdie')),
        ),
        body: Center(child: GamePage()),
      ),
    );
  }
}

//游戏盘组件
//继承有状态组件，有状态组件对象本身不可变
class GamePage extends StatefulWidget {
  GamePage({super.key});

  //重写创建状态方法
  @override
  State<GamePage> createState() => _GamePageState();
}

//状态组件继承状态类，状态组件可以通知有状态组件重建，从而达到刷新组件（类似于“可变组件”）的效果
class _GamePageState extends State<GamePage> {
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      //界面包含五行
      child: Column(
        spacing: 5.0,
        children: [
          //每一列五行
          for (var guess in _game.guesses)
            Row(
              spacing: 5.0,
              children: [
                //每一行五个tile
                for (var letter in guess) Tile(letter.char, letter.type),
              ],
            ),
          GuessInput(
            onSubmitGuess: (String guess) {
              //使用setState方法通知组件更新
              setState(() {
                _game.guess(guess);
              });
            },
          ),
        ],
      ),
    );
  }
}

//Tile组件
class Tile extends StatelessWidget {
  //tile上猜测的字母
  final String letter;
  //猜测命中的结果
  final HitType hitType;

  //通过参数构建组件是组件能够复用的关键
  const Tile(this.letter, this.hitType, {super.key});

  @override
  Widget build(BuildContext context) {
    //总是返回另一个组件
    //动画组件在组件重绘时提供丝滑的转变
    return AnimatedContainer(
      duration: Duration(milliseconds: 1000),
      curve: Curves.bounceOut,
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          HitType.hit => Colors.green,
          HitType.partial => Colors.yellow,
          HitType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

//处理用户输入
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;
  //文本编辑控制器
  final TextEditingController _textEditingController = TextEditingController();
  // 键盘焦点管理器
  final FocusNode _focusNode = FocusNode();

  //文本框或按钮提交的函数
  void _onSubmit() {
    //使用传进来的回调函数处理输入的文本
    onSubmitGuess(_textEditingController.text.trim());
    //清除文本
    _textEditingController.clear();
    //获取焦点
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    //row
    return Row(
      children: [
        //包围文本控制器
        Expanded(
          //padding
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            //textfild
            child: TextField(
              maxLength: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              //文本控制器，用于读取、清空或修改输入框中的文本
              controller: _textEditingController,
              //焦点管理器
              focusNode: _focusNode,
              //应用启动或提交后自动选中文本框
              autofocus: true,
              //文本框提交后的回调函数
              onSubmitted: (String input) {
                _onSubmit();
              },
            ),
          ),
        ),
        //带图标的按钮
        IconButton(
          onPressed: () {
            _onSubmit();
          },
          icon: Icon(Icons.arrow_circle_up),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
