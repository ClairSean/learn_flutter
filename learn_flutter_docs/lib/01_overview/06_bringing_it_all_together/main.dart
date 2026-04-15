import 'package:flutter/material.dart';

//有商品、是否在购物车两个参数的函数别名，购物车发生变化时回调
typedef CartChangedCallback = void Function(Product product, bool inCart);

//数据层产品类，只有名称属性
class Product {
  final String name;

  const Product({required this.name});
}

//购物清单项类
class ShoppingListItem extends StatelessWidget {
  //有商品、是否在购物车、购物车变化函数这三个属性
  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  ShoppingListItem({
    required this.product,
    required this.inCart,
    required this.onCartChanged,
  }) : super(key: ObjectKey(product));
  //把商品对象作为购物清单项的键，列表中每一项根据对象的key来区分，而不是位置，这样一来列表项的逻辑就不会错位

  //根据清单项是否在购物车内获取不同颜色
  Color _getColor(BuildContext context) {
    return inCart ? Colors.black54 : Theme.of(context).primaryColor;
  }

  //根据清单项是否在购物车内返回不同字体风格
  TextStyle? _getTextStyle(BuildContext context) {
    if (!inCart) return null;
    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    //可点击的列表项
    return ListTile(
      onTap: () {
        //点击后触发回调函数
        onCartChanged(product, inCart);
      },
      //显示商品名首字母的圆形图标
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0]),
      ),
      title: Text(product.name, style: _getTextStyle(context)),
    );
  }
}

//商品列表
class ShoppingList extends StatefulWidget {
  //用商品列表初始化该对象
  const ShoppingList({required this.products, super.key});

  final List<Product> products;

  //创建状态后，一直使用这个状态，而不是每次都重建
  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

//状态子类一般是私有的，他们实现私有的细节
class _ShoppingListState extends State<ShoppingList> {
  final _shoppingCart = <Product>{};

  //如果商品不在购物车就添加进列表，否则就移除
  //改变widget中的值
  void _handleCartChanged(Product product, bool inCart) {
    //先设置状态，然后更新组件
    //通过setstate方法通知框架刷新组件
    setState(() {
      if (!inCart) {
        //商品不在购物车，就添加
        _shoppingCart.add(product);
      } else {
        //商品在购物车，就移除
        _shoppingCart.remove(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping List')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        //用widget来访问组件的属性，如果组件重建，那么状态对象也会重建，并且使用新的组件值，重写didUpdateWidget方法会传回oldwidget来对比数据变化
        children: widget.products.map((product) {
          //每次重建
          return ShoppingListItem(
            product: product,
            inCart: _shoppingCart.contains(product), //设置商品是否在购物车
            onCartChanged: _handleCartChanged,
          );
        }).toList(),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      title: 'Shopping App',
      home: ShoppingList(
        products: [
          Product(name: 'Eggs'),
          Product(name: 'Flour'),
          Product(name: 'Chocolate chips'),
        ],
      ),
    ),
  );
}
