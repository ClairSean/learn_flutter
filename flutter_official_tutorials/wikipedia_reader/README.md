# Wikipedia Reader

这是一个跟随 Flutter 官方教程完成的学习项目，用于学习 Flutter 数据处理和状态管理。

> **教程链接**: [Set up your project](https://docs.flutter.cn/learn/pathway/tutorial/set-up-state-project)
>
> **注意**: 本项目为学习项目，不再更新维护。

## 项目简介

这是一个简单的 Wikipedia 随机文章阅读器，通过调用 Wikipedia API 获取并展示随机文章的摘要信息。

## 学习内容

通过这个项目，我学习了以下 Flutter 核心概念：

- **HTTP 请求**: 使用 `http` 包进行网络请求
- **状态管理**: 使用 `ChangeNotifier` 和 `ListenableBuilder` 管理应用状态
- **MVVM 架构**: Model-View-ViewModel 架构模式的实践
- **响应式 UI**: 当数据变化时自动更新用户界面
- **Dart 3.0+ 特性**: 使用 switch 表达式和模式匹配

## 功能特点

- 🔄 随机获取 Wikipedia 文章
- 📖 显示文章标题、描述、摘要和图片
- ⚡ 加载状态和错误处理
- � 跨平台支持（Android、iOS、Web、Windows、macOS、Linux）

## 技术栈

- Flutter 3.0+
- Dart 3.0+
- http 包
- Material Design

## 项目结构

```
wikipedia_reader/
├── lib/
│   ├── main.dart        # 主应用代码（MVVM 架构）
│   └── summary.dart     # Wikipedia 数据模型
├── pubspec.yaml         # 项目配置
└── README.md            # 项目说明
```

## 运行项目

### 前置条件

- Flutter SDK 3.0+
- Dart SDK 3.0+

### 安装和运行

1. 克隆项目

   ```bash
   git clone https://github.com/your-username/wikipedia_reader.git
   cd wikipedia_reader
   ```

2. 安装依赖

   ```bash
   flutter pub get
   ```

3. 运行项目
   ```bash
   flutter run
   ```

## API 使用

使用 Wikipedia REST API 获取随机文章：

```
GET https://en.wikipedia.org/api/rest_v1/page/random/summary
```

## 架构设计

项目采用 MVVM 架构模式：

- **Model**: `ArticleModel` - 负责数据获取
- **ViewModel**: `ArticleViewModel` - 负责业务逻辑和状态管理
- **View**: `ArticleView`, `ArticlePage`, `ArticleWidget` - 负责 UI 展示

## 许可证

MIT License
