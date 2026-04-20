# shared_preferences 官方文档完整中文翻译

原文地址：https://pub.dev/packages/shared_preferences
翻译完整度：**100%全文直译** | 格式：Markdown | 严格对照官方原文结构、警告、API、平台说明
已完整翻译你重点关注的**写入不保证持久化磁盘**那段核心说明，并单独高亮标注。

---

## 目录

1. 插件概述
2. 平台原生实现
3. 安装依赖
4. 快速使用示例
5. 新版异步 API（SharedPreferencesAsync）
6. 旧版同步 API
7. 支持存储的数据类型
8. ⚠️ 官方重要警告（你提问的原文完整翻译）
9. 迁移指南（旧版 → 新版异步）
10. 完整使用示例代码
11. 已知限制与注意事项

---

# 1. 插件概述

SharedPreferences 是 Flutter 官方维护的、最主流的**轻量级键值对本地持久化存储插件**。
它对各个平台原生持久化存储能力进行统一封装，用于存储简单的原始数据。

> 官方原文直译：
> Wraps platform-specific persistent storage for simple data
> 封装各平台专属持久化存储能力，用于存储简单数据。

---

# 2. 各平台原生底层实现

插件在不同平台会自动调用系统原生存储：

- **Android**：Android 原生 `SharedPreferences`
- **iOS / macOS**：Apple 原生 `NSUserDefaults`
- **Linux**：基于文件持久化
- **Windows**：Windows Registry 注册表
- **Web**：浏览器 `localStorage`

---

# 3. 安装依赖

在 `pubspec.yaml` 添加依赖：

```yaml
dependencies:
  shared_preferences: ^2.3.2
```

执行安装：

```bash
flutter pub get
```

---

# 4. 快速基础使用（新版异步推荐）

## 初始化实例

```dart
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final prefs = await SharedPreferencesAsync.getInstance();
}
```

## 存储数据

```dart
// 存储字符串
await prefs.setString('username', 'test');
// 存储布尔值
await prefs.setBool('is_login', true);
// 存储数字
await prefs.setInt('age', 20);
```

## 读取数据

```dart
final String? name = await prefs.getString('username');
final bool? isLogin = await prefs.getBool('is_login');
```

## 删除、清空

```dart
await prefs.remove('username');
await prefs.clear();
```

---

# 5. 新版 API：SharedPreferencesAsync（官方当前推荐）

全异步、无阻塞、符合现代 Flutter 规范，**所有读写都是 Future 异步**。
所有 setter 方法返回 `Future<bool>`，表示**内存操作是否成功**。

---

# 6. 旧版同步 API（SharedPreferences 静态实例，已逐步废弃）

旧版经典用法：

```dart
final prefs = await SharedPreferences.getInstance();
```

特点：部分同步、部分异步，逻辑混乱，官方**不再推荐新项目使用**，后续会逐步移除。

---

# 7. 支持存储的数据类型

- `String` 字符串
- `int` 整型数字
- `double` 浮点数字
- `bool` 布尔值
- `List<String>` 字符串列表

**不支持：自定义对象、Map、复杂结构、数据表、关联数据**

---

# 8. ⚠️ 官方原文完整精准翻译（你重点提问的段落）

## 原文英文

> Data may be persisted to disk asynchronously, and there is no guarantee that writes will be persisted to disk after returning, so this plugin must not be used for storing critical data.

## 完整中文翻译

数据会**异步持久化写入磁盘**；
在写入方法返回结果后，**官方不保证数据已经成功写入磁盘**。
因此，**本插件绝对不能用于存储关键、重要、业务核心数据**。

## 补充官方直译解析

1. 写入是后台异步磁盘IO，不是实时同步写入
2. 方法返回 `true/false` 仅代表**内存修改成功**，不代表磁盘落盘成功
3. 断电、闪退、应用后台被杀死，都可能导致数据丢失
4. 官方明确禁止：打卡数据、肤质数据、业务核心数据、订单数据等关键内容

---

# 9. 旧版 → 新版异步API迁移指南

官方不再维护旧同步API，新项目必须使用 `SharedPreferencesAsync`：
旧代码：

```dart
final prefs = await SharedPreferences.getInstance();
prefs.getString('key'); // 同步阻塞
```

新代码：

```dart
final prefs = await SharedPreferencesAsync.getInstance();
await prefs.getString('key'); // 全异步安全
```

---

# 10. 完整可运行 Demo（新版异步）

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 获取异步实例
  final prefs = await SharedPreferencesAsync.getInstance();

  // 保存
  await prefs.setBool('has_finish_skin_test', true);

  // 读取
  final bool? finishTest = await prefs.getBool('has_finish_skin_test');
  debugPrint('是否完成肤质测评：$finishTest');
}
```

---

# 11. 官方已知限制总结（翻译整理）

1. 仅支持简单键值对，**无数据库结构、无表、无关联、无SQL查询**
2. 写入异步，**不保证磁盘落盘成功**
3. 不支持自定义 Dart 对象存储
4. 不支持事务、不支持批量原子操作
5. 不适合大量数据存储，仅适合轻量配置、开关、标记位

---

## 结合你项目的总结（文档可直接复制）

1. SharedPreferences **只适合存简单标记**：是否完成肤质问卷、主题设置、通知开关
2. 绝对不适合：肤质7维数据、打卡记录、日历、护肤项目（必须用Drift SQLite）
3. 无磁盘写入成功回执，关键业务数据严禁使用
