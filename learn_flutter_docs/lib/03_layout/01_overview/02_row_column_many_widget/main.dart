import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('横向或纵向布局多个组件')),
        body: Center(child: allContent),
      ),
    );
  }
}

//页面里所有内容，列布局
final allContent = Column(
  children: [
    SizedBox(height: 50, child: row),
    SizedBox(height: 1, child: Container(color: Colors.black)),
    SizedBox(height: 100, child: columnInRow),
    restaurantCard,
  ],
);

/*
行与列
*/
//使用行布局
final row = Row(
  //主轴对齐方式
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Image.asset(
      'lib/03_layout/01_overview/02_row_column_many_widget/images/pic1.jpg',
    ),
    Image.asset(
      'lib/03_layout/01_overview/02_row_column_many_widget/images/pic2.jpg',
    ),
    Image.asset(
      'lib/03_layout/01_overview/02_row_column_many_widget/images/pic3.jpg',
    ),
  ],
);

//使用列布局
final column = Column(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    //用expanded让组件自适应宽高
    Expanded(
      child: Image.asset(
        'lib/03_layout/01_overview/02_row_column_many_widget/images/pic1.jpg',
      ),
    ),
    Expanded(
      child: Image.asset(
        'lib/03_layout/01_overview/02_row_column_many_widget/images/pic2.jpg',
      ),
    ),
    Expanded(
      child: Image.asset(
        'lib/03_layout/01_overview/02_row_column_many_widget/images/pic3.jpg',
      ),
    ),
  ],
);

//使用expanded的flex属性来调节子元素的空间占比
final interestingColumn = Column(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Expanded(
      child: Image.asset(
        'lib/03_layout/01_overview/02_row_column_many_widget/images/pic1.jpg',
      ),
    ),
    //设置弹性系数，也就是子元素间占用空间的比例，默认值为1
    Expanded(
      flex: 2,
      child: Image.asset(
        'lib/03_layout/01_overview/02_row_column_many_widget/images/pic2.jpg',
      ),
    ),
    Expanded(
      child: Image.asset(
        'lib/03_layout/01_overview/02_row_column_many_widget/images/pic3.jpg',
      ),
    ),
  ],
);

//列在行里
final columnInRow = Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [column, interestingColumn, column],
);

/**
 * 嵌套行与列
 */
//星级评价
final stars = Row(
  //将子项紧密贴合在一起
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(Icons.star, color: Colors.green[500]),
    Icon(Icons.star, color: Colors.green[500]),
    Icon(Icons.star, color: Colors.green[500]),
    Icon(Icons.star, color: Colors.black),
    Icon(Icons.star, color: Colors.black),
  ],
);

//星级与评价数
final ratings = Container(
  padding: const EdgeInsets.all(20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      stars,
      const Text(
        '170 Views',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
          fontSize: 20,
        ),
      ),
    ],
  ),
);

//餐厅基础信息图标列表使用的
//餐厅描述字体样式
const descTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w800,
  fontFamily: 'Roboto',
  letterSpacing: 0.5,
  fontSize: 18,
  height: 2,
);

//餐厅名的字体样式
const titleTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w700,
  fontFamily: 'Roboto',
  letterSpacing: 0.5,
  fontSize: 28,
  height: 2,
);

//餐厅名的字体样式
const subTitleTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontFamily: 'Roboto',
  letterSpacing: 0.5,
  fontSize: 16,
  height: 2,
);

//餐厅基础信息图标项
Widget iconItem(IconData icon, String action, String amount) {
  return Column(
    children: [
      Icon(icon, color: Colors.green[500]),
      Text('$action:'),
      Text(amount),
    ],
  );
}

//餐厅基础信息图标列表
final iconList = DefaultTextStyle(
  style: descTextStyle,
  child: Container(
    padding: const EdgeInsets.all(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        iconItem(Icons.kitchen, 'PREP', '25 min'),
        iconItem(Icons.timer, 'COOK', '1 hr'),
        iconItem(Icons.restaurant, 'FEEDS', '4-6'),
      ],
    ),
  ),
);

//餐厅名称标题
final titleText = Text(
  'Strawberry Pavlova',
  style: titleTextStyle,
  textAlign: TextAlign.center,
);

//餐厅副标题
final subTitle = Text(
  'Pavlova is a meringue-based dessertnamed after the Russianballerina Anna Pavlova. Pavlovafeatures a erisp erust and soft,light inside, topped with fruit andwhipped eream.',
  style: subTitleTextStyle,
  textAlign: TextAlign.center,
);

//左半边餐厅介绍和信息
final leftColumn = Container(
  padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
  child: Column(children: [titleText, subTitle, ratings, iconList]),
);

//右侧图片
final mainImage = Image.asset(
  'lib/03_layout/01_overview/02_row_column_many_widget/images/pavlova.jpg',
);

//餐厅卡片整体
final restaurantCard = Container(
  margin: const EdgeInsets.fromLTRB(0, 40, 0, 30),
  height: 600,
  child: Card(
    color: Colors.pinkAccent[100],
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 1, child: leftColumn),
        Expanded(flex: 2, child: mainImage),
      ],
    ),
  ),
);
