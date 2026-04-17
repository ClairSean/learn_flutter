# 用户输入与无障碍适配

一款真正的自适应应用，不仅要适配用户的输入方式差异，还需要为有无障碍需求的用户提供支持。

仅仅调整应用的外观是不够的，你还需要支持多样化的用户输入方式。鼠标和键盘带来了触控设备之外的输入类型，例如滚轮、右键点击、悬停交互、Tab键遍历和键盘快捷键。

其中部分功能在 Material 组件中默认生效。但如果你使用了自定义组件，可能需要手动实现这些功能。

一款设计精良的应用所具备的特性，同样能帮助使用辅助技术的用户。例如，除了是优秀的应用设计规范外，Tab键遍历、键盘快捷键等功能，对于使用辅助设备的用户而言至关重要。本章节在创建无障碍应用的通用建议基础上，介绍如何打造**兼具自适应与无障碍特性**的应用。

---

## 自定义组件的滚轮支持

滚动类组件（如 `ScrollView` 或 `ListView`）默认支持滚轮操作；由于几乎所有可滚动的自定义组件都基于这些组件构建，因此它们也能正常支持滚轮。

如果你需要实现自定义滚动行为，可以使用 `Listener` 组件，自定义界面对滚轮操作的响应逻辑。

```dart
return Listener(
  onPointerSignal: (event) {
    if (event is PointerScrollEvent) print(event.scrollDelta.dy);
  },
  child: ListView(),
);
```

---

## Tab键遍历与焦点交互

使用物理键盘的用户，希望可以通过 Tab 键快速浏览应用；有运动或视觉障碍的用户，通常完全依赖键盘导航。

Tab 键交互有两个核心要点：一是焦点在组件间的移动逻辑（即**遍历**），二是组件获得焦点时显示的视觉高亮效果。

大多数内置组件（如按钮、输入框）默认支持遍历和高亮效果。如果你希望自定义组件支持焦点遍历，可以使用 `FocusableActionDetector` 组件创建自定义控件。该组件可以将焦点、鼠标输入和快捷键整合在一起。你可以通过它定义动作、按键绑定，并提供处理焦点和悬停高亮的回调。

```dart
class _BasicActionDetectorState extends State<BasicActionDetector> {
  bool _hasFocus = false;
  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onFocusChange: (value) => setState(() => _hasFocus = value),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<Intent>(
          onInvoke: (intent) {
            print('Enter或Space键被按下！');
            return null;
          },
        ),
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const FlutterLogo(size: 100),
          // 在负边距中显示焦点，实现酷炫效果
          if (_hasFocus)
            const Positioned(
              left: -4,
              top: -4,
              bottom: -4,
              right: -4,
              child: _roundedBorder(),
            ),
        ],
      ),
    );
  }
}
```

---

## 控制遍历顺序

如果你需要更精细地控制用户按 Tab 键时组件的焦点顺序，可以使用 `FocusTraversalGroup` 定义组件树中需要作为整体处理的遍历区域。

例如，你可以设置先遍历表单中的所有输入框，再跳转到提交按钮：

```dart
return Column(
  children: [
    FocusTraversalGroup(child: MyFormWithMultipleColumnsAndRows()),
    SubmitButton(),
  ],
);
```

Flutter 提供多种内置的组件遍历方式，默认使用 `ReadingOrderTraversalPolicy`（阅读顺序遍历策略）。该策略通常能满足需求，你也可以使用其他预定义的遍历策略类，或自定义遍历策略。

---

## 键盘快捷键

除了 Tab 键遍历，桌面端和网页端用户习惯使用各类键盘快捷键执行操作。无论是删除键快速删除内容，还是 `Ctrl+N` 新建文档，都需要满足用户的快捷键使用习惯。键盘是高效的输入工具，尽可能挖掘它的效率，用户会因此受益。

在 Flutter 中，可根据需求通过多种方式实现键盘快捷键：

1. **单个组件监听**
   如果是输入框、按钮等已拥有焦点节点的单个组件，可以用 `KeyboardListener` 或 `Focus` 组件包裹，监听键盘事件：

```dart
@override
Widget build(BuildContext context) {
  return Focus(
    onKeyEvent: (node, event) {
      if (event is KeyDownEvent) {
        print(event.logicalKey);
      }
      return KeyEventResult.ignored;
    },
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: const TextField(
        decoration: InputDecoration(border: OutlineInputBorder()),
      ),
    ),
  );
}
```

2. **大范围组件树快捷键**
   使用 `Shortcuts` 组件为大片组件树绑定一组快捷键：

```dart
// 为每种快捷操作定义对应的意图类
class CreateNewItemIntent extends Intent {
  const CreateNewItemIntent();
}

Widget build(BuildContext context) {
  return Shortcuts(
    // 将按键组合与意图绑定
    shortcuts: const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.keyN, control: true):
          CreateNewItemIntent(),
    },
    child: Actions(
      // 将意图与实际代码方法绑定
      actions: <Type, Action<Intent>>{
        CreateNewItemIntent: CallbackAction<CreateNewItemIntent>(
          onInvoke: (intent) => _createNewItem(),
        ),
      },
      // 子组件树必须包裹焦点节点，才能获取焦点
      child: Focus(autofocus: true, child: Container()),
    ),
  );
}
```

`Shortcuts` 组件的优势：仅当当前组件树或其子组件获得焦点且可见时，快捷键才会生效。

3. **全局监听**
   用于实现应用级常驻快捷键，或面板在可见时始终响应快捷键（无论是否获得焦点）。使用 `HardwareKeyboard` 可快速添加全局监听：

```dart
@override
void initState() {
  super.initState();
  HardwareKeyboard.instance.addHandler(_handleKey);
}

@override
void dispose() {
  HardwareKeyboard.instance.removeHandler(_handleKey);
  super.dispose();
}
```

在全局监听中判断组合键，可使用 `HardwareKeyboard.instance.logicalKeysPressed` 集合。示例方法用于检测指定按键是否被按下：

```dart
static bool isKeyDown(Set<LogicalKeyboardKey> keys) {
  return keys
      .intersection(HardwareKeyboard.instance.logicalKeysPressed)
      .isNotEmpty;
}
```

结合以上逻辑，可在按下 `Shift+N` 时执行操作：

```dart
bool _handleKey(KeyEvent event) {
  bool isShiftDown = isKeyDown({
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
  });

  if (isShiftDown && event.logicalKey == LogicalKeyboardKey.keyN) {
    _createNewItem();
    return true;
  }
  return false;
}
```

**注意**：使用全局监听时，用户在输入框打字、或关联组件隐藏时，通常需要禁用监听。这一点需要你手动管理（`Shortcuts` 和 `KeyboardListener` 无需手动处理）。例如，绑定了删除键快捷键后，需要避免与输入框的删除功能冲突。

---

## 自定义组件的鼠标进入、退出与悬停

在桌面端，通常会通过改变鼠标光标样式，提示用户悬停内容的功能。例如，悬停在按钮上显示手型光标，悬停在文本上显示I型光标。

Flutter 的 Material 按钮默认处理了基础的焦点状态和光标样式（唯一例外：手动修改按钮样式，将 `overlayColor` 设置为透明）。

你需要为应用中的自定义按钮、手势检测器实现焦点状态。如果修改了 Material 按钮的默认样式，建议测试键盘焦点状态，并按需自定义。

在自定义组件中修改光标，使用 `MouseRegion`：

```dart
// 显示手型光标
return MouseRegion(
  cursor: SystemMouseCursors.click,
  // 点击时请求焦点
  child: GestureDetector(
    onTap: () {
      Focus.of(context).requestFocus();
      _submit();
    },
    child: Logo(showBorder: hasFocus),
  ),
);
```

`MouseRegion` 也可用于实现自定义的悬停效果：

```dart
return MouseRegion(
  onEnter: (_) => setState(() => _isMouseOver = true),
  onExit: (_) => setState(() => _isMouseOver = false),
  onHover: (e) => print(e.localPosition),
  child: Container(
    height: 500,
    color: _isMouseOver ? Colors.blue : Colors.black,
  ),
);
```

如需参考按钮获得焦点时显示边框的示例，可以查看 Wonderous 应用的按钮代码。该应用通过判断 `FocusNode.hasFocus` 属性，为获得焦点的按钮添加边框。

---

## 视觉密度

例如，你可以扩大组件的**触控区域**，以适配触控屏幕。

不同输入设备的精准度不同，需要不同尺寸的触控区域。Flutter 的 `VisualDensity`（视觉密度）类，可以轻松调整整个应用的界面密度。例如，在触控设备上放大按钮，让点击更轻松。

为 `MaterialApp` 设置视觉密度后，所有支持该特性的 Material 组件都会自动适配并带动画效果。默认情况下，水平和垂直密度均为 `0.0`，你可以设置任意正负值。通过切换密度值，即可快速调整界面。

---

## 自适应脚手架

设置自定义视觉密度，只需将密度配置注入 `MaterialApp` 的主题中：

```dart
double densityAmt = touchMode ? 0.0 : -1.0;
VisualDensity density = VisualDensity(
  horizontal: densityAmt,
  vertical: densityAmt,
);
return MaterialApp(
  theme: ThemeData(visualDensity: density),
  home: MainAppScaffold(),
  debugShowCheckedModeBanner: false,
);
```

在自定义组件中使用视觉密度，可通过主题获取：

```dart
VisualDensity density = Theme.of(context).visualDensity;
```

容器不仅会自动响应密度变化，还会在密度改变时播放动画。这让自定义组件和内置组件保持一致，实现全应用流畅的过渡效果。

如上所示，视觉密度是**无单位**的，不同界面可自定义其含义。示例中1个密度单位等于6像素，具体规则可自行定义。无单位的特性让它通用性极强，适用于大多数场景。

值得注意的是，Material 组件中，每个视觉密度单位通常对应约4个逻辑像素。更多支持的组件信息可查看 `VisualDensity` API 文档；通用的密度设计原则，可参考 Material Design 指南。
