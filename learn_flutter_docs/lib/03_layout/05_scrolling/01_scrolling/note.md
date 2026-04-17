# 📖 Flutter 官方文档：滚动 逐章节笔记

原文地址：<https://docs.flutter.cn/ui/layout/scrolling>

***

## 1. 介绍

滚动组件用于**展示超出屏幕可视区域的内容**，是 Flutter 最常用的布局类型之一。
所有滚动组件都遵循 Flutter 布局核心规则：

- **主轴方向**：无界约束（内容可以无限延伸）
- **交叉轴方向**：有界约束（必须匹配父容器尺寸）

滚动组件核心分为两类：

1. 简单滚动：`SingleChildScrollView`、`ListView`、`GridView`
2. 高级滚动：`CustomScrollView` + Sliver 系列组件

***

## 2. SingleChildScrollView

### 2.1 用途

包裹**单个子组件**，实现基础滚动，最常用于：

- 长表单页面
- 内容超出屏幕的详情页
- 替代 `Column` 防止内容溢出

### 2.2 基础示例

```dart
SingleChildScrollView(
  child: Column(
    children: [
      for (int i = 0; i < 30; i++)
        Container(
          height: 100,
          color: Colors.primaries[i % Colors.primaries.length],
        ),
    ],
  ),
)
```

### 2.3 关键参数

- `scrollDirection`：滚动方向（`Axis.vertical` / `Axis.horizontal`）
- `reverse`：是否反向滚动
- `physics`：滚动物理效果
- `padding`：内边距

### 2.4 限制

- 只能有**一个子组件**
- 不支持懒加载，内容过多会卡顿
- 子组件中**不能使用** **`Expanded`**（主轴无界约束冲突）

***

## 3. ListView

`ListView` 是最常用的滚动列表，支持多子组件 + 懒加载，是长列表首选。

### 3.1 四种构造方式

#### ① 默认构造 `ListView(children: [])`

- 一次性创建所有列表项
- 适合**少量固定内容**（<50 条）
- 长列表会严重卡顿

#### ② `ListView.builder`（推荐，必抄）

- **懒加载**：只创建屏幕可见项
- 适合海量数据（10万+ 无压力）

```dart
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('Item $index'),
    );
  },
)
```

#### ③ `ListView.separated`

- 懒加载 + 自动添加分割线
- 无需在 item 中手动写分隔组件

```dart
ListView.separated(
  itemCount: 100,
  itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
  separatorBuilder: (context, index) => Divider(height: 1),
)
```

#### ④ `ListView.custom`

- 完全自定义子项生成逻辑
- 日常开发极少使用

### 3.2 关键参数

- `itemCount`：列表总数量
- `itemExtent`：固定子项高度（大幅提升性能）
- `prototypeItem`：用示例组件定义子项尺寸
- `cacheExtent`：预加载区域大小
- `shrinkWrap`：是否根据内容适配自身高度（长列表禁用）

***

## 4. GridView

网格滚动列表，用于展示多列布局内容。

### 4.1 常用构造方式

#### ① `GridView.count`

指定交叉轴数量（列数）

```dart
GridView.count(
  crossAxisCount: 2,
  mainAxisSpacing: 10,
  crossAxisSpacing: 10,
  children: [
    for (int i = 0; i < 20; i++)
      Container(color: Colors.primaries[i % 17]),
  ],
)
```

#### ② `GridView.extent`

根据子项最大宽度自动计算列数

```dart
GridView.extent(
  maxCrossAxisExtent: 150,
  children: [...],
)
```

#### ③ `GridView.builder`（长网格首选）

懒加载网格列表

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
  ),
  itemCount: 1000,
  itemBuilder: (context, index) => Container(
    color: Colors.primaries[index % 17],
  ),
)
```

### 4.2 核心：gridDelegate

控制网格布局规则：

- `SliverGridDelegateWithFixedCrossAxisCount`：固定列数
- `SliverGridDelegateWithMaxCrossAxisExtent`：固定子项宽度

***

## 5. CustomScrollView

支持**多种滚动组件组合**的高级滚动容器，基于 Sliver 机制实现。
可以把：

- 折叠导航栏（`SliverAppBar`）
- 网格（`SliverGrid`）
- 列表（`SliverList`）
  合并为**同一个连续滚动视图**。

### 基础示例（必抄）

```dart
CustomScrollView(
  slivers: [
    SliverAppBar(
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(title: Text('Sliver AppBar')),
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(title: Text('Item $index')),
        childCount: 50,
      ),
    ),
  ],
)
```

***

## 6. 滚动物理效果（ScrollPhysics）

控制滚动到边界时的行为，决定“手感”。

### 常用类型

1. **`BouncingScrollPhysics`**
   弹性回弹（iOS 风格），越界拉伸后回弹
2. **`ClampingScrollPhysics`**
   到边界直接停止（Android 默认风格）
3. **`AlwaysScrollableScrollPhysics`**
   即使内容不足一屏，也允许滚动
4. **`NeverScrollableScrollPhysics`**
   禁止滚动（嵌套滚动时常用）

### 使用方式

```dart
ListView(
  physics: BouncingScrollPhysics(),
  children: [...],
)
```

***

## 7. 滚动控制（ScrollController）

用于：

- 监听滚动位置
- 跳转到指定偏移
- 控制滚动状态

### 基础示例（必抄）

```dart
final ScrollController _controller = ScrollController();

@override
void dispose() {
  _controller.dispose(); // 必须释放
  super.dispose();
}

ListView(
  controller: _controller,
  children: [...],
)

// 跳转到指定位置
_controller.animateTo(
  500,
  duration: Duration(milliseconds: 300),
  curve: Curves.easeInOut,
);
```

***

## 8. 嵌套滚动

滚动组件内部再嵌套滚动组件时，需要处理冲突：

- 内层列表禁用滚动：`physics: NeverScrollableScrollPhysics()`
- 内层列表自适应高度：`shrinkWrap: true`

示例：

```dart
SingleChildScrollView(
  child: Column(
    children: [
      Text('顶部内容'),
      ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [...],
      ),
    ],
  ),
)
```

***

## 9. 性能最佳实践

1. **长列表必须用** **`.builder`** **构造**
2. 固定子项尺寸：使用 `itemExtent` / `prototypeItem`
3. 避免在列表中使用 `shrinkWrap: true`
4. 图片列表使用缓存图片、固定宽高
5. 复杂 item 拆分为独立 `StatelessWidget`
6. 避免在 `itemBuilder` 中执行复杂计算

***

## 10. 常见问题

### 10.1 溢出报错

`Vertical viewport was given unbounded height`
原因：滚动组件父容器约束无界
解决：用 `Expanded` / 固定高度包裹

### 10.2 Expanded 报错

原因：`SingleChildScrollView` → `Column` → `Expanded`
解决：移除 `Expanded`，不使用弹性布局

### 10.3 嵌套滚动卡顿

原因：多层滚动冲突
解决：内层禁用滚动 + 自适应高度

