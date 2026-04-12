# Rolodex

一个 iOS 风格的联系人管理应用，使用 Flutter 的 Cupertino 组件构建。

## 项目说明

这是我在学习 Flutter 时跟着官方教程 [Advanced UI features](https://docs.flutter.cn/learn/pathway/tutorial/advanced-ui) 完成的练习项目。

## 功能

- iOS 风格的 UI 界面（Cupertino 组件）
- 联系人分组显示（按首字母排序）
- 搜索功能
- 深色/浅色主题支持
- 自适应布局（响应式设计）
- Sliver 滚动效果

## 技术栈

- **Flutter SDK**: ^3.11.4
- **Dart**: ^3.11.4
- **Cupertino Icons**: ^1.0.9

## 项目结构

```
lib/
├── main.dart              # 应用入口
├── data/
│   ├── contact.dart       # 联系人数据模型
│   └── contaxt_group.dart # 联系人分组模型
└── screens/
    ├── adaptive_layout.dart  # 自适应布局组件
    ├── contact_groups.dart   # 联系人分组页面
    └── contacts.dart         # 联系人列表页面
```

## 运行项目

确保已安装 Flutter SDK，然后执行：

```bash
flutter pub get
flutter run
```

## 学习要点

本项目涵盖以下 Flutter 高级 UI 知识点：

- **Cupertino 组件**: 使用 `CupertinoApp`、`CupertinoPageScaffold`、`CupertinoListSection` 等 iOS 风格组件
- **Sliver 滚动**: 使用 `CustomScrollView` 和 `SliverList` 实现高级滚动效果
- **自适应布局**: 使用 `LayoutBuilder` 根据屏幕尺寸调整布局
- **主题系统**: 使用 `CupertinoThemeData` 和 `CupertinoDynamicColor` 实现深浅主题
- **状态管理**: 使用 `ValueListenableBuilder` 进行响应式状态更新

## 状态

> ⚠️ 此项目为学习练习项目，未来不会更新维护。
