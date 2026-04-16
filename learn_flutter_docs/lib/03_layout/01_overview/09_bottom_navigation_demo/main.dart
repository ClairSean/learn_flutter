import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

void main(List<String> args) {
  runApp(
    const BottomNavigationDemo(
      type: BottomNavigationDemoType.withLabels,
      restorationId: 'bottom_natigation_labels_demo',
    ),
  );
}

//用于设置底部菜单栏菜单项在未选中时是否显示标签
enum BottomNavigationDemoType { withLabels, withoutLabels }

//底部导航栏demo有状态组件类
class BottomNavigationDemo extends StatefulWidget {
  const BottomNavigationDemo({
    super.key,
    required this.restorationId,
    required this.type,
  });

  final String restorationId;
  final BottomNavigationDemoType type;

  @override
  State<BottomNavigationDemo> createState() {
    return _BottomNavigationDemoState();
  }
}

//底部导航栏demo组件状态类
class _BottomNavigationDemoState extends State<BottomNavigationDemo>
        //用于实现状态恢复的混入
        with
        RestorationMixin {
  //能实现临时状态恢复的值，例如用户切换后台应用再切换回来后，能够恢复这个值，而不是变成初始值
  final RestorableInt _currentIndex = RestorableInt(0);

  //widget指向本状态类对应的BottomNavigationDemo组件实例
  //在混入中恢复使用的登记码，登记码标识状态桶
  @override
  String get restorationId => widget.restorationId;

  //应用从后台恢复后自动调用的方法
  @override
  void restoreState(
    //切应用之前保存的状态桶
    RestorationBucket? oldBucket,
    //true表示应用首次启动，false表示从后台恢复
    bool initialRestore,
  ) {
    //登记恢复对象，第一个参数是要恢复的状态对象，第二个参数是用来在状态桶中查找数据的标识
    registerForRestoration(_currentIndex, 'bottom_natigation_labels_demo');
  }

  //页面销毁时清理恢复相关的资源，防止内存泄漏
  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //获取当前主题颜色方案
    final colorScheme = Theme.of(context).colorScheme;
    //获取当前主题文字主题
    final textTheme = Theme.of(context).textTheme;
    //设置底部导航栏菜单项组件列表
    //BottomNavigationBarItem是flutter内置的菜单项组件
    var bottomNavigationBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.add_comment),
        label: 'Comments',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        label: 'Calender',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'Account',
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.alarm_on), label: 'Alarm'),
      const BottomNavigationBarItem(
        icon: Icon(Icons.camera_enhance),
        label: 'Camera',
      ),
    ];
    //切换底部菜单栏是否显示标签
    if (widget.type == BottomNavigationDemoType.withLabels) {
      //如果显示标签，那么只显示前三个菜单项
      bottomNavigationBarItems = bottomNavigationBarItems.sublist(
        0,
        bottomNavigationBarItems.length - 2,
      );
      //确保_currentIndex的值在菜单可用索引范围内
      _currentIndex.value = _currentIndex.value
          .clamp(0, bottomNavigationBarItems.length - 1)
          .toInt();
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          //不自动显示返回按钮
          automaticallyImplyLeading: false,
          title: Text(switch (widget.type) {
            //表示持久标签
            BottomNavigationDemoType.withLabels => 'Persistent labels',
            //表示选中标签
            BottomNavigationDemoType.withoutLabels => 'Selected label',
          }),
        ),
        body: Center(
          //页面切换时显示动画
          child: PageTransitionSwitcher(
            transitionBuilder: (child, animation, secondaryAnimation) {
              //用淡入淡出的动画
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            //主页面组件
            child: _NavigationDestinationView(
              //用key标识新旧组件，动画组件需要通过key的变化来确定播放动画
              key: UniqueKey(),
              //对应菜单项
              item: bottomNavigationBarItems[_currentIndex.value],
            ),
          ),
        ),
        //底部导航栏
        bottomNavigationBar: BottomNavigationBar(
          //控制是否显示未选中项的标签
          showUnselectedLabels:
              //当类型为withLabels时显示所有标签，否则只显示选中项标签
              widget.type == BottomNavigationDemoType.withLabels,
          //导航栏的菜单项列表
          items: bottomNavigationBarItems,
          //当前选中的索引
          currentIndex: _currentIndex.value,
          //导航栏类型：固定模式（所有项始终显示）
          type: BottomNavigationBarType.fixed,
          //选中项的字体大小
          selectedFontSize: textTheme.bodySmall!.fontSize!,
          //未选中项的字体大小
          unselectedFontSize: textTheme.bodySmall!.fontSize!,
          //点击导航项使用的回调，index是菜单项索引，从0开始
          onTap: (index) {
            //更新状态
            setState(() {
              //设置当前选中的索引
              _currentIndex.value = index;
            });
          },
          //选中项的颜色
          selectedItemColor: colorScheme.onPrimary,
          //未选中项的颜色（设置透明度为38%）
          unselectedItemColor: colorScheme.onPrimary.withValues(alpha: 0.38),
          //导航栏的背景颜色
          backgroundColor: colorScheme.primary,
        ),
      ),
    );
  }
}

class _NavigationDestinationView extends StatelessWidget {
  const _NavigationDestinationView({super.key, required this.item});
  //BottomNavigationBarItem是flutter内置的菜单项组件，传入值有icon和label
  final BottomNavigationBarItem item;

  @override
  Widget build(BuildContext context) {
    //栈组件
    return Stack(
      children: [
        //没有无障碍支持
        ExcludeSemantics(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              //圆角矩形
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'lib/03_layout/01_overview/09_bottom_navigation_demo/images/bottom_navigation_background.png',
                ),
              ),
            ),
          ),
        ),
        //居中的图标
        Center(
          child: IconTheme(
            data: const IconThemeData(color: Colors.white, size: 80),
            child: Semantics(
              label: 'Placeholder for ${item.label} tab',
              child: item.icon,
            ),
          ),
        ),
      ],
    );
  }
}
