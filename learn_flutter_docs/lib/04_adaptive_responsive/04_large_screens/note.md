# 大屏设备

在将应用适配到大屏设备时，需要牢记的一些事项。

本页提供针对应用的优化指导，以提升其在大屏设备上的使用体验。

Flutter 与 Android 一样，将大屏设备定义为平板、折叠屏设备以及运行 Android 系统的 ChromeOS 设备。除此之外，Flutter 还将网页端、桌面端以及 iPad 设备也归为大屏设备范畴。

## 为什么大屏设备格外重要？

用户对大屏设备的需求持续增长。截至 2024 年 1 月，运行 Android 系统的活跃大屏及折叠屏设备已超过 2.7 亿台，iPad 用户数量也超过 1490 万。

让应用支持大屏设备，还能带来额外收益。对应用进行优化以充分利用屏幕空间，能够：

- 提升应用的用户参与度指标
- 提高应用在 Google Play 商店中的曝光度。Play 商店近期更新后，会按设备类型展示评分，并标注应用是否支持大屏
- 确保应用符合 iPadOS 的提交规范，顺利通过 App Store 审核

## 使用 GridView 进行布局

参考下面这款应用的截图。该应用使用 `ListView` 展示界面内容：
左侧图片是应用在手机设备上的运行效果；
右侧图片是应用**未采用本页优化方案**时，在大屏设备上的运行效果。

![大屏示例](https://docs.flutter.cn/assets/images/docs/ui/adaptive-responsive/large-screens-listview-large.png)

这样的展示效果并不理想。

Android 大屏应用质量规范以及对应的 iOS 设计规范均指出：文本和容器都不应该铺满整个屏幕宽度。
那么该如何用自适应的方式解决这个问题？

一种常用方案是使用 `GridView`，下一节会详细说明。

### GridView

你可以使用 `GridView` 组件，将现有的 `ListView` 改造为尺寸更合理的列表项。

`GridView` 与 `ListView` 组件功能相似，但 `ListView` 仅支持线性排列组件，而 `GridView` 可以将组件以二维网格的形式排列。

`GridView` 也拥有与 `ListView` 相似的构造函数：`ListView` 的默认构造函数对应 `GridView.count`，`ListView.builder` 与 `GridView.builder` 功能相近。

`GridView` 还提供了额外的构造函数，用于实现更自定义的布局。如需了解更多，可查阅 `GridView` API 文档。

例如，如果你的原应用使用了 `ListView.builder`，可以直接替换为 `GridView.builder`。如果应用包含大量列表项，推荐使用该构造函数，仅构建屏幕上实际可见的列表项组件。

两个组件的大部分构造参数是相同的，因此替换操作十分简便。但你需要为 `gridDelegate`（网格代理）配置合适的参数。

Flutter 提供了两款功能强大的预制网格代理，分别是：

- `SliverGridDelegateWithFixedCrossAxisCount`
  允许你为网格指定固定的列数。
- `SliverGridDelegateWithMaxCrossAxisExtent`
  允许你定义列表项的最大宽度。

**不要**直接使用这些网格代理类设置列数，更不要根据设备是否为平板等类型硬编码列数。列数应基于**应用窗口尺寸**，而非物理设备的尺寸。

这个区别至关重要，因为很多移动设备支持多窗口模式，这会导致应用在小于物理屏幕的区域内渲染。此外，Flutter 应用还可以运行在网页和桌面端，窗口尺寸多种多样。因此，应使用 `MediaQuery` 获取应用窗口尺寸，而非物理设备尺寸。

## 其他解决方案

另一种解决该问题的方法是使用 `BoxConstraints` 的 `maxWidth` 属性，具体操作如下：

1. 将 `GridView` 包裹在 `ConstrainedBox` 中，并为其设置带有最大宽度的 `BoxConstraints`。
2. 如果你需要设置背景色等其他功能，可以使用 `Container` 替代 `ConstrainedBox`。

关于最大宽度值的选择，建议参考 Material 3 布局指南中推荐的数值。

## 折叠屏设备

如前文所述，Android 和 Flutter 均在设计规范中建议**不要锁定屏幕方向**，但部分应用仍会选择锁定屏幕方向。请注意，这种做法会导致应用在折叠屏设备上运行时出现问题。

应用在折叠屏设备上运行时，设备折叠状态下可能显示正常；但当设备展开后，你会发现应用出现**黑边居中（letterboxed）**的问题。

正如 SafeArea 与 MediaQuery 章节中所描述的，黑边居中指的是应用窗口被固定在屏幕中央，四周被黑色区域包围。

### 为什么会出现这种情况？

当使用 `MediaQuery` 获取应用窗口尺寸时，就可能出现该问题。设备折叠时，系统会将方向限制为竖屏模式。在底层逻辑中，`setPreferredOrientations` 方法会导致 Android 启用竖屏兼容模式，应用便会以黑边居中的状态显示。在这种状态下，`MediaQuery` 永远无法获取到设备展开后的更大窗口尺寸，因此 UI 无法扩展适配。

### 解决方案

你可以通过以下两种方式解决该问题：

1. 支持所有屏幕方向；
2. 使用**物理屏幕**的尺寸参数。事实上，这是少数需要使用物理屏幕尺寸、而非应用窗口尺寸的场景之一。

### 如何获取物理屏幕尺寸？

你可以使用 `Display` API，它包含物理设备的尺寸、像素比和刷新率等信息。

以下示例代码用于获取 `Display` 对象：

```dart
/// 应用状态对象
ui.FlutterView? _view;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _view = View.maybeOf(context);
}

void didChangeMetrics() {
  final ui.Display? display = _view?.display;
}
```

核心要点是找到你所需视图对应的物理屏幕参数。该 API 具备前瞻性，能够兼容当前及未来的多显示器、多视图设备。

# 自适应输入

增加对更多屏幕的支持，也意味着需要扩展输入控制方式。

Android 设计规范中描述了**大屏设备支持的三个等级**。

### 大屏设备支持的三个等级

第三级（最低支持等级）要求应用支持鼠标和触控笔输入（对应 Material 3 设计规范、Apple 设计规范）。

如果你的应用使用了 Material 3 及其内置的按钮、选择器组件，那么应用已经自带了对多种额外输入状态的支持。

但如果你使用了**自定义组件**该怎么办？请查阅**用户输入**章节，获取为组件添加输入支持的相关指导。

---

# 导航

在适配各种尺寸不同的设备时，导航功能会面临独特的挑战。
通常情况下，你需要根据可用的屏幕空间，在**底部导航栏（BottomNavigationBar）**和**侧边导航轨（NavigationRail）**之间切换。

如需了解更多信息（以及对应的示例代码），请查阅《为大屏开发 Flutter 应用》文章中的「问题：导航轨」章节。
