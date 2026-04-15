import 'package:flutter/material.dart';

class GridListDemo extends StatelessWidget {
  final GridListDemoType type;

  const GridListDemo({super.key, required this.type});

  static const List<_Photo> _photos = [
    _Photo(
      assetName: 'lib/03_layout/01_overview/05_grid_list/images/pic0.jpg',
      title: 'Pondicherry',
      subtitle: 'Fisherman',
    ),
    _Photo(
      assetName: 'lib/03_layout/01_overview/05_grid_list/images/pic1.jpg',
      title: 'Chennai',
      subtitle: 'Flower Market',
    ),
    _Photo(
      assetName: 'lib/03_layout/01_overview/05_grid_list/images/pic2.jpg',
      title: 'Tanjore',
      subtitle: 'Bronze Works',
    ),
    _Photo(
      assetName: 'lib/03_layout/01_overview/05_grid_list/images/pic3.jpg',
      title: 'Tanjore',
      subtitle: 'Market',
    ),
    _Photo(
      assetName: 'lib/03_layout/01_overview/05_grid_list/images/pic4.jpg',
      title: 'Tanjore',
      subtitle: 'Thanjavur Temple',
    ),
    _Photo(
      assetName: 'lib/03_layout/01_overview/05_grid_list/images/pic5.jpg',
      title: 'Tanjore',
      subtitle: 'Thanjavur Temple',
    ),
    _Photo(
      assetName: 'lib/03_layout/01_overview/05_grid_list/images/pic6.jpg',
      title: 'Pondicherry',
      subtitle: 'Salt Farm',
    ),
    _Photo(
      assetName: 'lib/03_layout/01_overview/05_grid_list/images/pic7.jpg',
      title: 'Chennai',
      subtitle: 'Scooters',
    ),
    _Photo(
      assetName: 'lib/03_layout/01_overview/05_grid_list/images/pic8.jpg',
      title: 'Chettinad',
      subtitle: 'Silk Maker',
    ),
    _Photo(
      assetName: 'lib/03_layout/01_overview/05_grid_list/images/pic9.jpg',
      title: 'Chettinad',
      subtitle: 'Lunch Prep',
    ),
    _Photo(
      assetName: 'lib/03_layout/01_overview/05_grid_list/images/pic10.jpg',
      title: 'Tanjore',
      subtitle: 'Market',
    ),
    _Photo(
      assetName: 'lib/03_layout/01_overview/05_grid_list/images/pic11.jpg',
      title: 'Pondicherry',
      subtitle: 'Beach',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Grid view'),
        ),
        body: GridView.count(
          restorationId: 'grid_view_demo_grid_offset',
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: EdgeInsets.all(8),
          childAspectRatio: 1,
          children: _photos.map<Widget>((photo) {
            return _GridDemoPhotoItem(photo: photo, tileStyle: type);
          }).toList(),
        ),
      ),
    );
  }
}

//图片类，包含资源路径、标题、副标题
class _Photo {
  final String assetName;
  final String title;
  final String subtitle;

  const _Photo({
    required this.assetName,
    required this.title,
    required this.subtitle,
  });
}

//用于显示网格元素标题
class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    //自动缩放盒子，让组件根据fit规则适应父组件尺寸
    return FittedBox(
      //使在子组件随父组件缩放，从而完整显示在父组件内部
      fit: BoxFit.scaleDown,
      //对齐方式为起始处居中
      alignment: AlignmentDirectional.centerStart,
      child: Text(text),
    );
  }
}

//网格项组件
class _GridDemoPhotoItem extends StatelessWidget {
  const _GridDemoPhotoItem({required this.photo, required this.tileStyle});

  final _Photo photo;
  //网格项显示模式
  final GridListDemoType tileStyle;

  @override
  Widget build(BuildContext context) {
    //带有无障碍支持的图片
    final Widget image = Semantics(
      label: '${photo.title} ${photo.subtitle}',
      child: Material(
        //方形带圆角
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        clipBehavior: Clip.antiAlias, //裁剪边缘抗锯齿
        child: Image.asset(
          photo.assetName,
          //使图片在完全覆盖区域的情况下尽量小
          fit: BoxFit.cover,
        ),
      ),
    );
    //根据传入的显示模式决定如何显示标题
    return switch (tileStyle) {
      //仅显示图片
      GridListDemoType.imageOnly => image,
      //在header模式，网格项顶部显示标题
      GridListDemoType.header => GridTile(
        header: Material(
          color: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
          clipBehavior: Clip.antiAlias,
          child: GridTileBar(
            title: _GridTitleText(photo.title),
            backgroundColor: Colors.black45,
          ),
        ),
        child: image,
      ),
      //页脚模式在网格项底部显示标题和副标题
      GridListDemoType.footer => GridTile(
        footer: Material(
          color: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
          ),
          clipBehavior: Clip.antiAlias,
          child: GridTileBar(
            title: _GridTitleText(photo.title),
            subtitle: _GridTitleText(photo.subtitle),
            backgroundColor: Colors.black45,
          ),
        ),
        child: image,
      ),
    };
  }
}

//显示模式枚举类，仅图片、顶部标题、底部标题三种模式
enum GridListDemoType { imageOnly, header, footer }

//通过修改这个值来设定显示模式
const GridListDemoType displayType = GridListDemoType.footer;

void main() {
  runApp(const GridListDemo(type: displayType));
}
