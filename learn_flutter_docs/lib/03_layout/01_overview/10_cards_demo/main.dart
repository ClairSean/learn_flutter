import 'package:flutter/material.dart';

//卡片类型枚举类
enum CardType { standard, tappable, selectable }

//旅行目的地模型
class TravelDestination {
  final String assetName;
  final String title;
  final String description;
  final String city;
  final String location;
  final CardType cardType;

  const TravelDestination({
    required this.assetName,
    required this.title,
    required this.description,
    required this.city,
    required this.location,
    this.cardType = CardType.standard,
  });
}

//旅行目的地列表
const List<TravelDestination> _destinations = [
  TravelDestination(
    assetName:
        'lib/03_layout/01_overview/10_cards_demo/images/india_thanjavur_market.png',
    title: 'Top 10 Cities to Visit in Tamil Nadu',
    description: 'Number 10',
    city: 'Thanjavur',
    location: 'Thanjavur, Tamil Nadu',
  ),
  TravelDestination(
    assetName:
        'lib/03_layout/01_overview/10_cards_demo/images/india_chettinad_silk_maker.png',
    title: 'Artisans of Southern India',
    description: 'Silk Spinners',
    city: 'Chettinad',
    location: 'Sivaganga, Tamil Nadu',
    cardType: CardType.tappable,
  ),
  TravelDestination(
    assetName:
        'lib/03_layout/01_overview/10_cards_demo/images/india_tanjore_thanjavur_temple.png',
    title: 'Brihadisvara Temple',
    description: 'Temples',
    city: 'Thanjavur',
    location: 'Thanjavur, Tamil Nadu',
    cardType: CardType.selectable,
  ),
  TravelDestination(
    assetName:
        'lib/03_layout/01_overview/10_cards_demo/images/india_thanjavur_market.png',
    title: 'Top 10 Cities to Visit in Tamil Nadu',
    description: 'Number 10',
    city: 'Thanjavur',
    location: 'Thanjavur, Tamil Nadu',
  ),
  TravelDestination(
    assetName:
        'lib/03_layout/01_overview/10_cards_demo/images/india_chettinad_silk_maker.png',
    title: 'Artisans of Southern India',
    description: 'Silk Spinners',
    city: 'Chettinad',
    location: 'Sivaganga, Tamil Nadu',
    cardType: CardType.tappable,
  ),
  TravelDestination(
    assetName:
        'lib/03_layout/01_overview/10_cards_demo/images/india_tanjore_thanjavur_temple.png',
    title: 'Brihadisvara Temple',
    description: 'Temples',
    city: 'Thanjavur',
    location: 'Thanjavur, Tamil Nadu',
    cardType: CardType.selectable,
  ),
];

//旅游目的地内容组件
class TravelDestinationContent extends StatelessWidget {
  final TravelDestination destination;

  const TravelDestinationContent({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.headlineSmall!.copyWith(
      color: Colors.white,
    );
    final descriptionStyle = theme.textTheme.titleMedium!;

    return Column(
      //子元素左对齐
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //图片与底部文字
        SizedBox(
          height: 184,
          child: Stack(
            children: [
              //图片
              Positioned.fill(
                child: Ink.image(
                  image: AssetImage(destination.assetName),
                  fit: BoxFit.cover,
                  child: Container(),
                ),
              ),
              //底部文字
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Semantics(
                    container: true,
                    header: true,
                    child: Text(destination.title, style: titleStyle),
                  ),
                ),
              ),
            ],
          ),
        ),
        //下方三行文字
        Semantics(
          //将组件视作整体
          container: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: DefaultTextStyle(
              softWrap: false,
              //文字越界就省略
              overflow: TextOverflow.ellipsis,
              style: descriptionStyle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      destination.description,
                      style: descriptionStyle.copyWith(color: Colors.black54),
                    ),
                  ),
                  Text(destination.city),
                  Text(destination.location),
                ],
              ),
            ),
          ),
        ),
        //标准卡片显示两个按钮
        if (destination.cardType == CardType.standard)
          Padding(
            padding: const EdgeInsets.all(8),
            //按钮布局专用组件
            child: OverflowBar(
              alignment: MainAxisAlignment.start,
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Share',
                    semanticsLabel: 'Share ${destination.title}',
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Explore',
                    semanticsLabel: 'Explore ${destination.title}',
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

//列表项第一行标题，在卡片上面
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}

//标准列表项
class TravelDestinationItem extends StatelessWidget {
  static const double height = 360;
  final TravelDestination destination;
  final ShapeBorder? shape;

  const TravelDestinationItem({
    super.key,
    required this.destination,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false, //不预留上方安全边距
      bottom: false, //不预留底部安全边距
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            //标题
            const SectionTitle(title: 'Normal'),
            //固定高度的盒子
            SizedBox(
              height: height,
              //卡片布局
              child: Card(
                elevation: 24,
                //边缘抗锯齿
                clipBehavior: Clip.antiAlias,
                //卡片形状
                shape: shape,
                child: Semantics(
                  label: destination.title,
                  //卡片内部内容组件
                  child: TravelDestinationContent(destination: destination),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//可点击的列表项
class TappableTravelDestinationItem extends StatelessWidget {
  static const double height = 298;
  final TravelDestination destination;
  final ShapeBorder? shape;

  const TappableTravelDestinationItem({
    super.key,
    required this.destination,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SectionTitle(title: 'Tappable'),
            SizedBox(
              height: height,
              child: Card(
                elevation: 24,
                //裁剪边缘抗锯齿
                clipBehavior: Clip.antiAlias,
                shape: shape,
                //Material风格带水波纹效果可点击组件
                child: InkWell(
                  onTap: () {},
                  //水波纹效果颜色
                  splashColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.12),
                  //无长按高亮颜色
                  highlightColor: Colors.transparent,
                  child: Semantics(
                    label: destination.title,
                    child: TravelDestinationContent(destination: destination),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//可选中列表项
class SelectableTravelDestinationItem extends StatelessWidget {
  final TravelDestination destination;
  final ShapeBorder? shape;
  final bool isSelected;
  final VoidCallback onSelected;

  static const double height = 298;

  const SelectableTravelDestinationItem({
    super.key,
    required this.destination,
    required this.isSelected,
    required this.onSelected,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final String selectedStatus = isSelected ? "Selected" : "Not selected";
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SectionTitle(title: 'Selectable (long press)'),
            SizedBox(
              height: height,
              //卡片组件
              child: Card(
                elevation: 24,
                //边缘抗锯齿
                clipBehavior: Clip.antiAlias,
                shape: shape,
                child: InkWell(
                  //长按执行回调
                  onLongPress: onSelected,
                  splashColor: colorScheme.onSurface.withValues(alpha: 0.12),
                  highlightColor: Colors.transparent,
                  child: Stack(
                    children: [
                      //背景，选中时会变色
                      Container(
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.2)
                            : Colors.transparent,
                      ),
                      Semantics(
                        label: '${destination.title}, $selectedStatus',
                        //告诉视障用户长按会发生什么
                        onLongPressHint: isSelected ? 'Deselected' : 'Select',
                        child: TravelDestinationContent(
                          destination: destination,
                        ),
                      ),
                      //右上角选中标记
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.check_circle,
                            color: isSelected
                                ? colorScheme.primary
                                : Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//根组件，包含列表
class CardsDemo extends StatefulWidget {
  const CardsDemo({super.key});
  @override
  State<StatefulWidget> createState() {
    return _CardsDemoState();
  }
}

class _CardsDemoState extends State<CardsDemo> with RestorationMixin {
  final RestorableBool _isSelected = RestorableBool(false);

  @override
  String? get restorationId => 'cards_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_isSelected, 'is_selected');
  }

  @override
  void dispose() {
    _isSelected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Cards'),
        ),
        body: ListView(
          restorationId: 'cards_demo_list_view',
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          children: [
            for (final destination in _destinations)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: switch (destination.cardType) {
                  CardType.standard => TravelDestinationItem(
                    destination: destination,
                  ),
                  CardType.tappable => TappableTravelDestinationItem(
                    destination: destination,
                  ),
                  CardType.selectable => SelectableTravelDestinationItem(
                    destination: destination,
                    isSelected: _isSelected.value,
                    //长按执行的回调，切换选中状态
                    onSelected: () {
                      setState(() {
                        _isSelected.value = !_isSelected.value;
                      });
                    },
                  ),
                },
              ),
          ],
        ),
      ),
    );
  }
}

void main(List<String> args) {
  runApp(const CardsDemo());
}
