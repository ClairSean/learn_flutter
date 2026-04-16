import 'package:flutter/material.dart';

const double _colorItemHeight = 48;

//调色板类，包含颜色名、主色板、强调色板、明度阈值
class _Palette {
  const _Palette({
    required this.name,
    required this.primary,
    this.accent,
    this.threshold = 900,
  });

  final String name;
  //安卓风格颜色板，按照明度不同包含10种相关颜色，明度值包含50，100-900
  final MaterialColor primary;
  //安卓风格强调色板，包含100，200，400，700四种明度
  final MaterialAccentColor? accent;
  //显示设置的明度阈值，用于决定文字是黑色还是白色
  final int threshold;
}

//色板列表
const List<_Palette> _allPalettes = [
  _Palette(
    name: 'Red',
    primary: Colors.red,
    accent: Colors.redAccent,
    threshold: 300,
  ),
  _Palette(
    name: 'Pink',
    primary: Colors.pink,
    accent: Colors.pinkAccent,
    threshold: 200,
  ),
  _Palette(
    name: 'Purple',
    primary: Colors.purple,
    accent: Colors.purpleAccent,
    threshold: 200,
  ),
  _Palette(
    name: 'Deep purple',
    primary: Colors.deepPurple,
    accent: Colors.deepPurpleAccent,
    threshold: 200,
  ),
  _Palette(
    name: 'Indigo',
    primary: Colors.indigo,
    accent: Colors.indigoAccent,
    threshold: 200,
  ),
  _Palette(
    name: 'Blue',
    primary: Colors.blue,
    accent: Colors.blueAccent,
    threshold: 400,
  ),
  _Palette(
    name: 'Light blue',
    primary: Colors.lightBlue,
    accent: Colors.lightBlueAccent,
    threshold: 500,
  ),
  _Palette(
    name: 'Cyan',
    primary: Colors.cyan,
    accent: Colors.cyanAccent,
    threshold: 600,
  ),
  _Palette(
    name: 'Teal',
    primary: Colors.teal,
    accent: Colors.tealAccent,
    threshold: 400,
  ),
  _Palette(
    name: 'Green',
    primary: Colors.green,
    accent: Colors.greenAccent,
    threshold: 500,
  ),
  _Palette(
    name: 'Light green',
    primary: Colors.lightGreen,
    accent: Colors.lightGreenAccent,
    threshold: 600,
  ),
  _Palette(
    name: 'Lime',
    primary: Colors.lime,
    accent: Colors.limeAccent,
    threshold: 800,
  ),
  _Palette(name: 'Yellow', primary: Colors.yellow, accent: Colors.yellowAccent),
  _Palette(name: 'Amber', primary: Colors.amber, accent: Colors.amberAccent),
  _Palette(
    name: 'Orange',
    primary: Colors.orange,
    accent: Colors.orangeAccent,
    threshold: 700,
  ),
  _Palette(
    name: 'Deep orange',
    primary: Colors.deepOrange,
    accent: Colors.deepOrangeAccent,
    threshold: 400,
  ),
  _Palette(name: 'Brown', primary: Colors.brown, threshold: 200),
  _Palette(name: 'Grey', primary: Colors.grey, threshold: 500),
  _Palette(name: 'Blue grey', primary: Colors.blueGrey, threshold: 500),
];

//颜色列表项
class _ColorItem extends StatelessWidget {
  const _ColorItem({
    required this.index,
    required this.color,
    this.prefix = '',
  });

  //颜色明度值
  final int index;
  final Color color;
  //明度值前缀
  final String prefix;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      //把子元素文本作为整体，无障碍用户焦点在内部时，朗读所有文本；如果为false，就会朗读选中的独立文本，而不是全部读出来
      container: true,
      child: Container(
        height: _colorItemHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: color,
        child: Row(
          //左右子元素都顶到底
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //垂直居中
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('$prefix$index'),
            //使子元素在主轴上可占用空间灵活调整大小，当空间足够时占用所需空间，当空间小时缩小子元素的空间
            Flexible(child: Text(_argbColorString)),
          ],
        ),
      ),
    );
  }

  //把0-1的色值子项转化为16进制大写字符串
  static String _srgbComponentToHexString(double x) {
    //把0-1的值转变成0-255的值，用与运算来确保数值落在0-255之间
    final value = (x * 255.0).round() & 0xff;
    //把整数转化为16进制大写字符串
    return value.toRadixString(16).toUpperCase();
  }

  //获取颜色透明度和红绿蓝的值的字符串
  String get _argbColorString {
    final a = _srgbComponentToHexString(color.a);
    final r = _srgbComponentToHexString(color.r);
    final g = _srgbComponentToHexString(color.g);
    final b = _srgbComponentToHexString(color.b);
    return '$a$r$g$b';
  }
}

//根据传入的调色板提供标签页组件
class _PaletteTabView extends StatelessWidget {
  const _PaletteTabView({required this.colors});

  //接受一个调色板，包含主色和可选强调色
  final _Palette colors;

  //颜色明度列表
  static const List<int> primaryKeys = [
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
  ];

  //强调色键值
  static const List<int> accentKeys = [100, 200, 400, 700];

  @override
  Widget build(BuildContext context) {
    //获取当前主题
    final textTheme = Theme.of(context).textTheme;
    //白色字体
    final whiteTextStyle = textTheme.bodyMedium!.copyWith(color: Colors.white);
    //黑色字体
    final blackTextStyle = textTheme.bodyMedium!.copyWith(color: Colors.black);
    //自带滚动的列表视图组件
    return ListView(
      //在滚动方向设置列表项的固定高度
      itemExtent: _colorItemHeight,
      //子元素列表项列表
      children: [
        //根据颜色主键创建列表项，是主色调
        for (final key in primaryKeys)
          //为子组件的文本提供样式
          DefaultTextStyle(
            //如果颜色明度大于颜色明度阈值，那么就显示文字为白色（背景比较黑），否则为黑色（背景比较白）
            style: key > colors.threshold ? whiteTextStyle : blackTextStyle,
            child: _ColorItem(
              index: key,
              //显示当前颜色明度对应的颜色
              color: colors.primary[key]!,
            ),
          ),
        if (colors.accent != null)
          //颜色有强调色，现在显示强调色
          for (final key in accentKeys)
            DefaultTextStyle(
              style: key > colors.threshold ? whiteTextStyle : blackTextStyle,
              child: _ColorItem(
                index: key,
                color: colors.accent![key]!,
                //在明度标签前面添加A
                prefix: 'A',
              ),
            ),
      ],
    );
  }
}

//app根组件，颜色展示应用
class ColorsDemo extends StatelessWidget {
  const ColorsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const palettes = _allPalettes; //获取调色板列表
    return MaterialApp(
      //自动管理标签和页面的关系，TabBar内标签子元素顺序需要和TabBarView内页面子元素顺序一致
      home: DefaultTabController(
        //标签/页面对的数量
        length: palettes.length,
        //标签控制器组件的子元素通常是appBar属性内部有TabBar组件的Scaffold
        child: Scaffold(
          //顶部导航栏，包括标题和标签栏
          appBar: AppBar(
            //如果为true，那么非堆栈首页导航栏会自动显示返回按钮，首页不显示；这里设置一下防止首页意外自动显示返回按钮
            automaticallyImplyLeading: false,
            title: const Text('Colors'),
            //顶部导航栏底部的标签栏，用TabBar组件可以简单地让DefaultTabController知道这就是标签栏
            bottom: TabBar(
              //移动端上可滚动组件
              isScrollable: true,
              //Tab组件是用于TabBar的标签组件，每一个Tab对应一个标签
              tabs: [for (final palette in palettes) Tab(text: palette.name)],
            ),
          ),
          //标签视图组件，配合TabBar和DefaultTabController，显示TabBar中选中标签的对应内容（内容与Tab顺序匹配）
          body: TabBarView(
            //每一个子组件对应单个视图
            children: [
              for (final palette in palettes) _PaletteTabView(colors: palette),
            ],
          ),
        ),
      ),
    );
  }
}

void main(List<String> args) {
  runApp(const ColorsDemo());
}
