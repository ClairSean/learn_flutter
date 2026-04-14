# 基础组件

## 无障碍

| 类名             | 描述                                                       |
| ---------------- | ---------------------------------------------------------- |
| ExcludeSemantics | 排除后代组件的语义信息，使无障碍工具忽略其子组件           |
| MergeSemantics   | 合并后代组件的语义信息，将多个子组件作为一个整体识别       |
| Semantics        | 自定义组件的语义描述，支持无障碍功能，方便工具识别组件用途 |

## 动画

| 类名                         | 描述                                                     |
| ---------------------------- | -------------------------------------------------------- |
| AlignTransition              | Align 的动画版本，通过动画过渡子组件的对齐方式           |
| AnimatedAlign                | 对齐属性变更时，自动为子组件的对齐方式添加平滑过渡动画   |
| AnimatedBuilder              | 通用型动画构建组件，用于自定义和构建各类动画效果         |
| AnimatedContainer            | 带动画的容器组件，容器属性变化时自动执行平滑过渡动画     |
| AnimatedCrossFade            | 以淡入淡出的动画形式，在两个子组件之间进行切换           |
| AnimatedDefaultTextStyle     | 文本样式变更时，自动为文字样式添加平滑过渡动画           |
| AnimatedList                 | 列表内添加或移除列表项时，自动展示对应的过渡动画         |
| AnimatedListState            | AnimatedList 对应的状态类，负责管理列表项的动画状态      |
| AnimatedModalBarrier         | 带动画效果的模态遮罩层，用于阻挡与下层界面的交互         |
| AnimatedOpacity              | 透明度数值变化时，为子组件添加透明度的平滑渐变动画       |
| AnimatedPhysicalModel        | PhysicalModel 的动画版本，平滑过渡组件的物理样式属性     |
| AnimatedPositioned           | Positioned 的动画版本，组件位置变更时自动执行平滑过渡    |
| AnimatedScale                | 为子组件的缩放比例添加平滑的渐变动画                     |
| AnimatedSize                 | 子组件尺寸发生变化时，自动为大小变化添加平滑过渡动画     |
| AnimatedWidget               | 自定义带动画组件的基础抽象类，监听动画并自动重建 UI      |
| ImplicitlyAnimatedWidget     | 隐式动画组件的基类，属性改变时会自动执行渐变过渡动画     |
| DecoratedBoxTransition       | DecoratedBox 的动画版本，为装饰样式添加动画过渡效果      |
| DefaultTextStyleTransition   | DefaultTextStyle 的动画版本，以动画过渡文本样式属性      |
| FadeTransition               | 为子组件实现透明度的淡入淡出动画效果                     |
| Hero                         | 标记为共享元素，实现页面跳转时的跨页共享动画             |
| MatrixTransition             | 通过 4D 矩阵变换，为子组件实现对应的矩阵动画效果         |
| PositionedTransition         | Stack 中 Positioned 的动画版，组件位置变化时启用动画过渡 |
| RelativePositionedTransition | 基于相对坐标与边界框，通过动画控制子组件的位置           |
| RepeatingAnimatedBuilder     | 可实现循环播放效果的动画构建组件                         |
| RotationTransition           | 为子组件添加旋转角度的动画过渡效果                       |
| ScaleTransition              | 为子组件添加缩放形式的入场、出场动画过渡                 |
| SizeTransition               | 为子组件添加尺寸从无到有（或反之）的展开、收起动画       |
| SlideTransition              | 让子组件相对于自身原始位置，实现滑动过渡动画             |
| SliverFadeTransition         | 专为 Sliver 组件设计，实现透明度的淡入淡出动画           |

## 资源

| 类名        | 描述                                                    |
| ----------- | ------------------------------------------------------- |
| AssetBundle | 应用资源包，承载图片、字符串等资源，资源访问为异步方式  |
| Icon        | Material Design 风格的矢量图标组件                      |
| Image       | 展示本地 / 网络图片的基础组件                           |
| RawImage    | 直接绘制 dart:ui.Image 对象的底层图片组件，极少直接使用 |

## 异步

| 类名          | 描述                                             |
| ------------- | ------------------------------------------------ |
| FutureBuilder | 根据与 Future 交互的最新快照，构建自身 UI 的组件 |
| StreamBuilder | 根据与 Stream 交互的最新快照，构建自身 UI 的组件 |

## 基础

| 类名           | 描述                                                     |
| -------------- | -------------------------------------------------------- |
| AppBar         | 位于屏幕顶部，用于展示内容与操作项的容器                 |
| Column         | 将子组件沿垂直方向排列布局                               |
| Container      | 整合通用绘制、定位与尺寸控制的便捷容器                   |
| ElevatedButton | Material 风格凸起按钮，按下时呈现高程提升效果            |
| FlutterLogo    | Flutter 标志组件，遵循 IconTheme 样式                    |
| Icon           | Material Design 风格的矢量图标组件                       |
| Image          | 用于展示图片的基础组件                                   |
| Placeholder    | 绘制占位框，用于标记后续组件的摆放位置                   |
| Row            | 将子组件沿水平方向排列布局                               |
| Scaffold       | Material Design 基础视觉布局结构，提供抽屉、提示栏等支持 |
| Text           | 展示单一样式的文本内容                                   |

## 输入

| 类名             | 描述                                                   |
| ---------------- | ------------------------------------------------------ |
| Autocomplete     | 辅助用户输入文本，并从选项列表中快速选择补全           |
| Form             | 用于分组收纳多个表单项组件的可选容器                   |
| FormField        | 单个表单项组件，维护字段状态并可视化展示更新与校验错误 |
| KeyboardListener | 监听键盘按键按下与释放操作，并触发对应回调             |

## 交互

### 触控交互

| 类名                     | 描述                                                        |
| ------------------------ | ----------------------------------------------------------- |
| AbsorbPointer            | 吸收区域内的指针事件，阻止其子组件接收到任何触摸 / 点击事件 |
| Dismissible              | 支持沿指定方向拖动，拖动后可将组件移除                      |
| DragTarget               | 用于接收 Draggable 组件拖拽过来的数据的目标容器             |
| Draggable                | 可被拖动的组件，拖动时显示反馈，可投放至 DragTarget         |
| DraggableScrollableSheet | 可拖动调整大小的滚动容器，先响应拖动缩放，达到限制后再滚动  |
| GestureDetector          | 用于检测各类手势（点击、双击、长按、滑动等）并触发回调      |
| IgnorePointer            | 正常渲染界面，但忽略自身及子组件区域内的所有触摸事件        |
| InteractiveViewer        | 支持对子组件进行平移、缩放交互，常用于图片查看              |
| LongPressDraggable       | 需长按子组件后，才可开始拖动的组件                          |
| Scrollable               | 滚动组件的基础交互模型，负责处理滚动手势识别                |

### 导航

| 类名      | 描述                                                   |
| --------- | ------------------------------------------------------ |
| Hero      | 标记为页面共享元素，实现路由切换时的连贯过渡动画       |
| Navigator | 以路由栈形式管理页面跳转，负责页面入栈、出栈等导航操作 |

## 布局

### 单子组件布局

| 类名                    | 描述                                                         |
| ----------------------- | ------------------------------------------------------------ |
| Align                   | 在自身范围内按指定对齐方式放置子组件，可根据子组件尺寸调整自身大小 |
| AspectRatio             | 强制子组件按照设定的宽高比进行布局                           |
| Baseline                | 基于子组件文本基线定位子组件，无基线时则以子组件底部为准     |
| Center                  | 在自身范围内将子组件居中摆放                                 |
| ConstrainedBox          | 为子组件添加最小 / 最大宽高约束，限制子组件尺寸范围          |
| Container               | 整合通用绘制、定位与尺寸控制的便捷容器                       |
| CustomSingleChildLayout | 通过布局代理为单个子组件实现高度自定义的布局逻辑             |
| Expanded                | 在 Row、Column、Flex 中占用剩余可用空间，拉伸子组件          |
| FittedBox               | 自动缩放、对齐子组件，使其适配自身尺寸范围                   |
| FractionallySizedBox    | 按父容器的宽高比例，设置子组件的尺寸                         |
| IntrinsicHeight         | 将子组件高度调整为其自然固有高度，解决无约束布局下的高度异常 |
| IntrinsicWidth          | 将子组件宽度调整为其自然固有宽度，解决无约束布局下的宽度异常 |
| LimitedBox              | 仅当父组件无尺寸约束时，为子组件设置最大宽高限制             |
| OffStage                | 隐藏子组件（不绘制、不占用布局空间），但仍保留其生命周期状态 |
| OverflowBox             | 允许子组件尺寸超出父容器范围，并可自定义子组件的尺寸约束     |
| Padding                 | 为子组件设置内边距，撑开组件间距                             |
| SizedBox                | 指定固定宽高，可用于占位或限制子组件尺寸                     |
| SizedOverflowBox        | 自身占用固定宽高，同时允许子组件超出自身布局范围             |
| Transform               | 对子组件执行矩阵变换，实现旋转、平移、缩放、倾斜等视觉效果   |

### 多子组件布局

| 类名                   | 描述                                                         |
| ---------------------- | ------------------------------------------------------------ |
| Column                 | 将多个子组件沿垂直方向线性排列                               |
| CustomMultiChildLayout | 通过布局代理，对多个子组件实现完全自定义的布局控制           |
| CarouselView           | 轮播展示子组件列表，支持循环滑动，子组件尺寸可随布局动态变化 |
| Flow                   | 高性能多子组件自定义布局，通过代理控制子组件的位置与尺寸     |
| GridView               | 可滚动的二维网格布局，用于展示多列子组件                     |
| IndexedStack           | 以栈结构管理所有子组件，仅显示指定索引的子组件，并保留全部子组件状态 |
| LayoutBuilder          | 根据父组件传递的布局约束信息，动态构建子组件布局             |
| ListBody               | 线性排列子组件，功能简单，实际开发中常被 ListView 或 Column 替代 |
| ListView               | 可滚动的线性列表布局，适合展示大量子组件                     |
| Row                    | 将多个子组件沿水平方向线性排列                               |
| Stack                  | 层叠堆叠子组件，可通过定位组件控制子组件位置                 |
| Table                  | 以表格形式排列子组件的二维不可滚动布局                       |
| Wrap                   | 流式布局，子组件超出一行 / 列后自动换行 / 换列排列           |

### Sliver组件

| 类名                          | 描述                                                         |
| ----------------------------- | ------------------------------------------------------------ |
| CupertinoSliverNavigationBar  | iOS 风格大标题导航栏，需配合 CustomScrollView 使用，大标题会随滚动折叠 |
| CupertinoSliverRefreshControl | iOS 风格的下拉刷新控件，用于 Sliver 滚动视图中               |
| CustomScrollView              | 可组合多种 Sliver 组件，实现统一连贯的滚动效果               |
| SliverAppBar                  | 可滚动收起、展开折叠的应用栏，常用于顶部导航                 |
| SliverChildBuilderDelegate    | 以 builder 懒加载方式，为 Sliver 列表创建子组件的代理        |
| SliverChildListDelegate       | 直接传入子组件列表，为 Sliver 提供子组件的代理               |
| SliverFillRemaining           | 填充 CustomScrollView 中剩余的可视空间，常用于占满底部空白   |
| SliverFixedExtentList         | 子项高度 / 宽度固定的高性能 Sliver 列表                      |
| SliverGrid                    | Sliver 版可滚动网格布局，实现二维网格展示                    |
| SliverList                    | Sliver 版可滚动线性列表，实现一维列表展示                    |
| SliverPadding                 | 为 Sliver 组件设置内边距                                     |
| SliverPersistentHeader        | 可悬浮吸顶、拉伸收缩的持久化头部组件                         |
| SliverToBoxAdapter            | 将普通盒模型（Box）组件转为 Sliver，使其可放入 CustomScrollView |

## 绘制

| 类名                  | 描述                                                         |
| --------------------- | ------------------------------------------------------------ |
| BackdropFilter        | 对背景内容应用滤镜（模糊 / 变色），再绘制子组件，常用于毛玻璃效果 |
| ClipOval              | 将子组件裁剪为椭圆形 / 圆形                                  |
| ClipPath              | 自定义路径裁剪子组件                                         |
| ClipRect              | 将子组件裁剪为矩形区域                                       |
| CustomPaint           | 提供自定义画板，可绘制任意图形、图案                         |
| DecoratedBox          | 为子组件添加背景、边框、渐变等装饰效果                       |
| FractionalTranslation | 按比例偏移子组件的绘制位置                                   |
| Opacity               | 设置子组件的透明度                                           |
| RotatedBox            | 将子组件旋转固定角度                                         |
| Transform             | 对子组件执行矩阵变换，实现旋转、缩放、平移、倾斜等视觉效果   |

## 滚动

### 滚动组件

| 类名                     | 描述                                                         |
| ------------------------ | ------------------------------------------------------------ |
| CarouselView             | 轮播展示子组件列表，支持循环滑动，子组件尺寸可随布局动态变化 |
| CustomScrollView         | 可组合多种 Sliver 组件，实现统一、连贯的整体滚动效果         |
| DraggableScrollableSheet | 可拖动调整高度的滚动面板，拖动至边界限制后转为正常滚动       |
| GridView                 | 可滚动的二维网格布局，用于多列展示子组件                     |
| ListView                 | 可滚动的线性列表布局，适合展示大量子项                       |
| NestedScrollView         | 支持嵌套多层滚动视图，协调内外滚动行为，避免滚动冲突         |
| NotificationListener     | 监听滚动等视图通知事件，可捕获并处理滚动状态变化             |
| PageView                 | 全屏分页式滚动容器，支持横向 / 纵向翻页切换子组件            |
| RefreshIndicator         | Material 风格的下拉刷新指示器，触发下拉刷新动画              |
| ReorderableListView      | 支持长按拖拽调整子项顺序的可滚动列表                         |
| ScrollConfiguration      | 统一配置滚动组件的滚动行为、特效与平台样式                   |
| Scrollable               | 滚动功能的基础抽象组件，负责处理滚动手势与滚动逻辑           |
| Scrollbar                | Material 风格滚动条，用于指示滚动位置                        |
| SingleChildScrollView    | 容纳单个子组件的可滚动容器，用于解决内容溢出屏幕的问题       |

### Sliver组件

| 类名                          | 描述                                                         |
| ----------------------------- | ------------------------------------------------------------ |
| CupertinoSliverNavigationBar  | iOS 风格大标题导航栏，需配合 CustomScrollView 使用，大标题会随滚动折叠 |
| CupertinoSliverRefreshControl | iOS 风格的下拉刷新控件，用于 Sliver 滚动视图中               |
| CustomScrollView              | 可组合多种 Sliver 组件，实现统一连贯的滚动效果               |
| SliverAppBar                  | 可滚动收起、展开折叠的应用栏，常用于顶部导航                 |
| SliverChildBuilderDelegate    | 以 builder 懒加载方式，为 Sliver 列表创建子组件的代理        |
| SliverChildListDelegate       | 直接传入子组件列表，为 Sliver 提供子组件的代理               |
| SliverFillRemaining           | 填充 CustomScrollView 中剩余的可视空间，常用于占满底部空白   |
| SliverFixedExtentList         | 子项高度 / 宽度固定的高性能 Sliver 列表                      |
| SliverGrid                    | Sliver 版可滚动网格布局，实现二维网格展示                    |
| SliverList                    | Sliver 版可滚动线性列表，实现一维列表展示                    |
| SliverPadding                 | 为 Sliver 组件设置内边距                                     |
| SliverPersistentHeader        | 可悬浮吸顶、拉伸收缩的持久化头部组件                         |
| SliverToBoxAdapter            | 将普通盒模型（Box）组件转为 Sliver，使其可放入 CustomScrollView |

## 样式

| 类名       | 描述                                                     |
| ---------- | -------------------------------------------------------- |
| MediaQuery | 获取设备尺寸、屏幕方向、像素密度等媒体信息，用于设备适配 |
| Padding    | 为子组件设置内边距，控制组件内部间距                     |
| Theme      | 统一管理应用主题样式，配置全局颜色、字体、主题数据并复用 |

## 文本

| 类名             | 描述                                                     |
| ---------------- | -------------------------------------------------------- |
| DefaultTextStyle | 为子组件树提供默认文本样式，子组件未指定样式时继承该设置 |
| RichText         | 支持在一段文本内混合多种不同样式，实现富文本展示         |
| Text             | 展示单一风格的文本内容，是最基础的文本组件               |

