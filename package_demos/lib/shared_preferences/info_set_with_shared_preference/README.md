# 📱 SharedPreferences MVVM 测试项目

一个基于 **MVVM 架构** 的 Flutter 示例项目，用于测试和学习 SharedPreferences 本地持久化存储。

## 📋 目录

- [功能特性](#-功能特性)
- [项目架构](#-项目架构)
- [文件结构](#-文件结构)
- [依赖包](#-依赖包)
- [快速开始](#-快速开始)
- [详细文档](#-详细文档)
- [扩展指南](#-扩展指南)
- [注意事项](#-注意事项)

---

## ✨ 功能特性

### 📝 数据管理功能

本项目实现了 5 个完整的数据管理功能模块：

| 功能模块     | 数据类型       | 验证规则                             | 特殊处理                    |
| ------------ | -------------- | ------------------------------------ | --------------------------- |
| **用户名**   | `String`       | 不能为空                             | -                           |
| **粉丝数**   | `int`          | 不能为空、不能为负数、必须是有效数字 | -1 表示未保存               |
| **账号权重** | `double`       | 不能为空、必须在 0-1 之间            | 显示时保留 2 位小数         |
| **VIP 状态** | `bool`         | -                                    | 开关控件                    |
| **国家列表** | `List<String>` | -                                    | 可展开/收起、支持 CRUD 操作 |

### 🎨 UI 特性

- ✅ **组件化设计**：所有 UI 元素都拆分为独立组件
- ✅ **响应式更新**：使用 Provider 实现状态管理
- ✅ **加载状态**：操作时显示加载遮罩
- ✅ **消息提示**：底部弹出式消息，自动消失
- ✅ **数据验证**：实时验证用户输入，显示友好提示
- ✅ **主题支持**：可轻松切换主题颜色

### 🏗️ 架构特性

- ✅ **MVVM 架构**：清晰的四层分离（View、ViewModel、Repository、Service）
- ✅ **单向数据流**：数据流向清晰，易于理解和维护
- ✅ **响应式编程**：使用 ChangeNotifier 实现状态通知
- ✅ **依赖注入**：通过 Provider 提供 ViewModel 实例
- ✅ **易于扩展**：添加新功能只需按顺序在四层中添加代码

---

## 🏛️ 项目架构

### 四层架构图

```
┌─────────────────────────────────────────────────────────┐
│                    View 层                               │
│  (ui/home/widgets/home_screen.dart + widgets)           │
│  - 显示 UI                                               │
│  - 接收用户输入                                          │
│  - 监听 ViewModel 状态变化                               │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ onChanged / onPressed
                     ▼
┌─────────────────────────────────────────────────────────┐
│                 ViewModel 层                             │
│  (ui/home/viewmodels/home_viewmodel.dart)               │
│  - 业务逻辑                                              │
│  - 状态管理                                              │
│  - 数据验证                                              │
│  - 调用 Repository                                       │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 调用
                     ▼
┌─────────────────────────────────────────────────────────┐
│                 Repository 层                            │
│  (data/repositories/shared_repository.dart)             │
│  - 数据源抽象                                            │
│  - 连接 ViewModel 和 Service                             │
│  - 便于单元测试                                          │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 委托
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  Service 层                              │
│  (data/services/shared_service.dart)                    │
│  - 直接操作 SharedPreferences                           │
│  - 封装所有持久化操作                                    │
│  - 基础验证                                              │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 调用原生 API
                     ▼
┌─────────────────────────────────────────────────────────┐
│              SharedPreferences                           │
│  (package:shared_preferences)                           │
│  - 跨平台本地存储                                        │
│  - 支持 String, int, double, bool, List<String>         │
└─────────────────────────────────────────────────────────┘
```

### 数据流向

```
用户交互 → View → ViewModel → Repository → Service → SharedPreferences
                ↑                                        │
                └─────────── 状态更新 ───────────────────┘
```

---

## 📁 文件结构

```
lib/shared_preferences/
├── main.dart                        # 应用入口
│
├── data/                            # 数据层
│   ├── services/
│   │   └── shared_service.dart      # Service 层：直接操作 SharedPreferences
│   │
│   └── repositories/
│       └── shared_repository.dart   # Repository 层：数据仓库
│
├── ui/                              # UI 层
│   └── home/
│       ├── viewmodels/
│       │   └── home_viewmodel.dart  # ViewModel 层：业务逻辑和状态管理
│       │
│       └── widgets/                 # View 层：UI 组件
│           ├── home_screen.dart           # 主界面
│           ├── section_title.dart         # 区域标题
│           ├── info_card.dart             # 信息卡片
│           ├── data_input_field.dart      # 数据输入框
│           ├── action_buttons.dart        # 操作按钮组
│           ├── vip_switch.dart            # VIP 开关
│           ├── country_list_card.dart     # 国家列表卡片
│           ├── country_list_item.dart     # 国家列表项
│           ├── add_country_button.dart    # 添加国家按钮
│           └── simple_message_overlay.dart # 底部消息提示
│
├── ARCHITECTURE.md                  # 🏗️ 架构详细说明（推荐先读）
├── README.md                        # 📖 本文件
└── QUICK_START.md                   # 🚀 快速启动指南
```

---

## 📦 依赖包

```yaml
dependencies:
  flutter:
    sdk: flutter

  # 本地持久化存储
  shared_preferences: ^2.5.5

  # 状态管理
  provider: ^6.1.2
```

### 依赖说明

| 依赖包               | 版本   | 用途           |
| -------------------- | ------ | -------------- |
| `shared_preferences` | ^2.5.5 | 本地键值对存储 |
| `provider`           | ^6.1.2 | 响应式状态管理 |

---

## 🚀 快速开始

### 1. 安装依赖

```bash
cd d:\projects\learn_flutter\package_demos
flutter pub get
```

### 2. 运行应用

```bash
# Windows
flutter run -d windows --target=lib/shared_preferences/main.dart

# Android
flutter run -d android --target=lib/shared_preferences/main.dart

# iOS
flutter run -d ios --target=lib/shared_preferences/main.dart
```

### 3. 测试功能

详细测试步骤请查看 [QUICK_START.md](QUICK_START.md)

---

## 📚 详细文档

### 🏗️ [ARCHITECTURE.md](ARCHITECTURE.md) - 架构说明

**适合人群**：想深入理解 MVVM 架构的开发者

**内容包括**：

- 完整架构图和数据流向图
- 四层架构的详细职责说明
- 响应式更新机制
- 错误处理链
- 特殊状态处理（粉丝数 -1 标记、国家列表已保存标记）
- 测试场景详解
- 最佳实践

### 🚀 [QUICK_START.md](QUICK_START.md) - 快速启动指南

**适合人群**：初次接触项目的开发者

**内容包括**：

- 安装和运行步骤
- 完整的功能测试流程
- 代码结构说明
- 修改和实验指南
- 常见问题解答
- 调试技巧

---

## 🔧 扩展指南

### 添加新功能（如：保存邮箱）

按照 MVVM 架构，依次在四层中添加代码：

#### 1️⃣ Service 层

```dart
// data/services/shared_service.dart
Future<void> saveEmail(String email) async {
  await _prefs.setString('email', email);
}

Future<String?> getEmail() async {
  return await _prefs.getString('email');
}

Future<bool> hasEmail() async {
  final email = await _prefs.getString('email');
  return email != null && email.isNotEmpty;
}

Future<void> clearEmail() async {
  await _prefs.remove('email');
}
```

#### 2️⃣ Repository 层

```dart
// data/repositories/shared_repository.dart
Future<void> saveEmail(String email) async {
  await _service.saveEmail(email);
}

Future<String?> getEmail() async {
  return await _service.getEmail();
}

Future<bool> hasEmail() async {
  return await _service.hasEmail();
}

Future<void> clearEmail() async {
  await _service.clearEmail();
}
```

#### 3️⃣ ViewModel 层

```dart
// ui/home/viewmodels/home_viewmodel.dart
String _email = '';
String _inputEmail = '';

String get email => _email;
String get inputEmail => _inputEmail;

Future<void> saveEmail() async {
  // 验证和保存逻辑
}

Future<void> checkEmail() async {
  // 检查逻辑
}

Future<void> clearEmail() async {
  // 清除逻辑
}

void updateInputEmail(String value) {
  _inputEmail = value;
  notifyListeners();
}
```

#### 4️⃣ View 层

```dart
// ui/home/widgets/home_screen.dart
const SectionTitle(title: '邮箱管理'),
const SizedBox(height: 16),
DataInputField(
  label: '邮箱',
  hintText: '请输入邮箱地址',
  initialValue: viewModel.inputEmail,
  onChanged: viewModel.updateInputEmail,
),
const SizedBox(height: 12),
ActionButtons(
  isLoading: viewModel.isLoading,
  onSave: viewModel.saveEmail,
  onCheck: viewModel.checkEmail,
  onClear: viewModel.clearEmail,
  saveColor: Colors.blue,
),
```

### 架构优势

1. **分层清晰**：每层职责明确，易于理解和维护
2. **易于测试**：各层可独立进行单元测试
3. **易于扩展**：添加新功能只需按顺序在四层中添加代码
4. **代码复用**：通用组件（SectionTitle、InfoCard 等）可复用在多个功能中
5. **状态管理**：使用 Provider 实现响应式状态更新

---

## ⚠️ 注意事项

### SharedPreferences 的适用场景

✅ **适合存储**：

- 用户偏好设置（主题、语言等）
- 简单的应用配置
- 少量用户数据
- 布尔标志位

❌ **不适合存储**：

- 大量数据（建议使用数据库）
- 复杂的关系数据
- 需要频繁修改的大文件
- 敏感信息（建议使用加密存储）

### 存储限制

| 平台    | 限制                 |
| ------- | -------------------- |
| Android | 约几 MB              |
| iOS     | 无明确限制，建议少量 |
| Windows | 取决于注册表空间     |
| Web     | 通常 5-10 MB         |

### 数据持久化

- ✅ 数据会永久保存，除非：
  - 用户清除应用数据
  - 卸载应用
  - 手动调用清除方法
  - 设备存储损坏

### 异步操作

所有 SharedPreferences 操作都是异步的：

```dart
// 正确写法
await _prefs.setString('key', 'value');

// 错误写法（不会等待完成）
_prefs.setString('key', 'value');
```

### 状态同步

保存数据后，记得同步 ViewModel 中的状态：

```dart
// 保存后同步
await _repository.saveUsername(username);
_username = username;  // ✅ 同步状态
notifyListeners();     // ✅ 通知 View
```

---

## 🎓 学习路径

### 初级开发者

1. ✅ 运行项目，测试所有功能
2. ✅ 阅读 QUICK_START.md
3. ✅ 理解 MVVM 三层架构
4. ✅ 掌握 SharedPreferences 基本用法

### 中级开发者

1. ✅ 阅读 ARCHITECTURE.md
2. ✅ 理解单向数据流
3. ✅ 掌握响应式编程思想
4. ✅ 学会组件化开发
5. ✅ 尝试添加新的保存项

### 高级开发者

1. ✅ 深入理解架构分层的重要性
2. ✅ 掌握状态同步的技巧
3. ✅ 学习设计模式在项目中的应用
4. ✅ 进行单元测试
5. ✅ 优化和重构代码

---

## 🎯 设计模式

本项目应用了以下设计模式：

1. **MVVM 模式** - 分离 UI、业务逻辑和数据
2. **观察者模式** - ViewModel 通过 ChangeNotifier 通知 View
3. **仓库模式** - Repository 层解耦业务逻辑和数据源
4. **依赖注入** - Provider 提供 ViewModel 实例
5. **单例模式** - SharedPreferencesAsync 在 Service 中

---

## 🐛 常见问题

### Q: 为什么修改代码后需要热重载或重启？

**A:**

- 热重载（Hot Reload）：保留应用状态，快速查看 UI 变化
- 热重启（Hot Restart）：重新初始化应用，清空状态
- 完全重启：重新编译，适用于修改依赖或原生代码

### Q: 消息提示为什么不显示？

**A:** 检查以下几点：

1. ViewModel 中 `_shouldShowMessage` 是否设置为 `true`
2. 是否调用了 `notifyListeners()` 通知 View 更新
3. View 层 `build()` 方法中是否正确检查 `shouldShowMessage`
4. 确保在 `addPostFrameCallback` 中调用 `SimpleMessageOverlay.show()`
5. 检查 `context.mounted` 是否返回 `true`

**常见问题**：

- ❌ 在 `build()` 中直接调用显示方法（会导致无限循环）
- ✅ 应该在 `addPostFrameCallback` 中异步调用
- ❌ 使用全局计数器跟踪消息状态（会导致状态不一致）
- ✅ 使用简单的布尔标志位即可

### Q: 国家列表为什么要区分"未保存"和"保存过空列表"？

**A:** 这是两种不同的业务状态，在某些场景下很重要：

- **未保存**：用户从未点击过保存按钮
- **保存过空列表**：用户明确保存了一个空列表

---

## 📖 相关资源

### 官方文档

- [Flutter 官方文档](https://flutter.dev/docs)
- [Dart 语言指南](https://dart.dev/guides)
- [Provider 包文档](https://pub.dev/packages/provider)
- [SharedPreferences 包文档](https://pub.dev/packages/shared_preferences)

### 学习资源

- [Flutter 状态管理指南](https://flutter.dev/docs/development/data-and-backend/state-mgmt)
- [MVVM 架构模式](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
- [Provider 官方教程](https://pub.dev/packages/provider#example)

---

## 🎉 结语

本项目是一个完整的 MVVM 架构示例，适合：

- ✅ Flutter 初学者学习状态管理
- ✅ 学习 SharedPreferences 的使用
- ✅ 理解 MVVM 架构模式
- ✅ 学习组件化开发
- ✅ 作为小型项目的参考模板

**记住**：理解架构比记住代码更重要！💪

祝你学习愉快！🚀

---

_最后更新：2026-04-20_
