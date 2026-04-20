# 🚀 快速启动指南

## 📋 目录

1. [第一步：安装依赖](#第一步安装依赖)
2. [第二步：运行应用](#第二步运行应用)
3. [第三步：测试功能](#第三步测试功能)
4. [第四步：查看代码结构](#第四步查看代码结构)
5. [第五步：修改和实验](#第五步修改和实验)
6. [常见问题](#常见问题)
7. [调试技巧](#调试技巧)
8. [下一步学习](#下一步学习)

---

## 第一步：安装依赖

```bash
cd d:\projects\learn_flutter\package_demos
flutter pub get
```

确保所有依赖包都已安装：
- `shared_preferences: ^2.5.5` - 本地持久化存储
- `provider: ^6.1.2` - 状态管理

---

## 第二步：运行应用

### Windows 平台
```bash
flutter run -d windows --target=lib/shared_preferences/main.dart
```

### Android 平台
```bash
flutter run -d android --target=lib/shared_preferences/main.dart
```

### iOS 平台
```bash
flutter run -d ios --target=lib/shared_preferences/main.dart
```

---

## 第三步：测试功能

### 📝 测试用户名管理

#### 保存用户名
1. 在"用户名"输入框输入：`张三`
2. 点击 **保存** 按钮（蓝色）
3. 查看：
   - ✅ "已保存的用户名"卡片显示：张三
   - ✅ 底部消息提示：用户名保存成功：张三

#### 检查用户名
1. 修改输入框为：`李四`
2. 点击 **检查** 按钮（橙色）
3. 查看消息：✗ 用户名不匹配（已保存：张三）

#### 清除用户名
1. 点击 **清除** 按钮（红色）
2. 查看：
   - ✅ "已保存的用户名"卡片显示：未保存
   - ✅ 底部消息提示：用户名已清除

#### 验证规则
- ❌ 输入空值 → 提示"用户名不能为空"

---

### 🔢 测试粉丝数管理

#### 保存粉丝数
1. 在"粉丝数"输入框输入：`1000`
2. 点击 **保存** 按钮
3. 查看：
   - ✅ "已保存的粉丝数"卡片显示：1000
   - ✅ 底部消息提示：粉丝数保存成功：1000

#### 检查粉丝数
1. 修改输入框为：`2000`
2. 点击 **检查** 按钮
3. 查看消息：✗ 粉丝数不匹配（已保存：1000）

#### 清除粉丝数
1. 点击 **清除** 按钮
2. 查看：
   - ✅ "已保存的粉丝数"卡片显示：未保存
   - ✅ 底部消息提示：粉丝数已清除

#### 验证规则
- ❌ 输入空值 → 提示"粉丝数不能为空"
- ❌ 输入负数 `-100` → 提示"粉丝数不能为负数"
- ❌ 输入文字 `abc` → 提示"请输入有效的数字"

---

### ⚖️ 测试账号权重管理

#### 保存账号权重
1. 在"账号权重"输入框输入：`0.8`
2. 点击 **保存** 按钮
3. 查看：
   - ✅ "已保存的账号权重"卡片显示：0.80
   - ✅ 底部消息提示：账号权重保存成功：0.80

#### 检查账号权重
1. 修改输入框为：`0.5`
2. 点击 **检查** 按钮
3. 查看消息：✗ 账号权重不匹配（已保存：0.80）

#### 清除账号权重
1. 点击 **清除** 按钮
2. 查看：
   - ✅ "已保存的账号权重"卡片显示：未保存
   - ✅ 底部消息提示：账号权重已清除

#### 验证规则
- ❌ 输入空值 → 提示"账号权重不能为空"
- ❌ 输入 `1.5` → 提示"账号权重必须在 0-1 之间"
- ❌ 输入 `-0.5` → 提示"账号权重必须在 0-1 之间"
- ❌ 输入文字 → 提示"请输入有效的数字"

---

### 👑 测试 VIP 状态管理

#### 切换 VIP 状态
1. 点击 VIP 开关，切换为"开启"状态
2. 点击 **保存** 按钮（黄色）
3. 查看：
   - ✅ 底部消息提示：已保存为 VIP 用户

#### 检查 VIP 状态
1. 切换 VIP 开关为"关闭"状态
2. 点击 **检查** 按钮
3. 查看消息：✗ VIP 状态不匹配（已保存：VIP）

#### 清除 VIP 状态
1. 点击 **清除** 按钮
2. 查看：
   - ✅ 底部消息提示：VIP 状态已清除
   - ✅ 再次检查显示：✗ 未保存过 VIP 状态

---

### 🌍 测试国家列表管理（重点功能）

#### 展开/收起列表
1. 点击"国家列表"卡片
2. 查看：
   - ✅ 卡片右侧箭头从 ▼ 变为 ▲
   - ✅ 下方展开列表区域
   - ✅ 显示"添加国家"按钮

3. 再次点击卡片
4. 查看：
   - ✅ 卡片右侧箭头从 ▲ 变为 ▼
   - ✅ 列表区域收起

#### 添加国家
1. 点击卡片展开列表
2. 点击"添加国家"按钮（绿色）
3. 出现一个新的输入项，显示序号 ①
4. 在输入框中输入：`中国`
5. 点击 **保存** 按钮（紫色）
6. 查看：
   - ✅ 列表收起
   - ✅ 卡片显示：已保存 1 个国家
   - ✅ 底部消息：国家列表保存成功（1 个国家）

#### 继续添加国家
1. 再次点击卡片展开列表
2. 点击"添加国家"按钮
3. 出现第二个输入项，显示序号 ②
4. 输入：`美国`
5. 点击 **保存** 按钮
6. 查看：
   - ✅ 卡片显示：已保存 2 个国家
   - ✅ 再次展开，显示两个国家项

#### 修改国家
1. 展开国家列表
2. 修改"中国"为"中华人民共和国"
3. 点击 **保存** 按钮
4. 查看：
   - ✅ 卡片显示：已保存 2 个国家
   - ✅ 再次展开，显示修改后的名称

#### 删除国家
1. 展开国家列表
2. 点击某个国家项右侧的红色删除按钮
3. 该国家项消失
4. 点击 **保存** 按钮
5. 查看：
   - ✅ 卡片显示：已保存 1 个国家
   - ✅ 剩余国家项序号自动更新为 ①

#### 检查国家列表
1. 展开列表，修改某个国家
2. 但不点击保存，直接点击 **检查** 按钮
3. 查看消息：✗ 国家列表不匹配（已保存 X 个国家）

#### 清除国家列表
1. 点击 **清除** 按钮（红色）
2. 查看：
   - ✅ 列表收起
   - ✅ 卡片显示：未保存
   - ✅ 底部消息：国家列表已清除

#### 边界情况测试

##### 保存空列表
1. 展开卡片，不添加任何国家
2. 点击 **保存** 按钮
3. 查看：
   - ✅ 卡片显示：**已保存 0 个国家**（不是"未保存"）

##### 区分"未保存"和"保存过空列表"
- **从未保存**：卡片显示"未保存"
- **保存过空列表**：卡片显示"已保存 0 个国家"
- **清除后**：卡片显示"未保存"

---

### 🔄 测试刷新功能

1. 修改一些数据并保存
2. 点击右上角的 **刷新** 图标 🔄
3. 应用重新从 SharedPreferences 加载数据
4. 查看：
   - ✅ 所有输入框和卡片显示最新保存的数据
   - ✅ 国家列表自动收起
   - ✅ 底部显示加载成功消息

---

## 第四步：查看代码结构

```
lib/shared_preferences/
├── main.dart                    # 📍 应用入口（运行时的起点）
│
├── data/
│   ├── services/
│   │   └── shared_service.dart  # 🔧 服务层（直接操作 SharedPreferences）
│   │
│   └── repositories/
│       └── shared_repository.dart # 📦 数据仓库（连接 ViewModel 和 Service）
│
└── ui/
    └── home/
        ├── viewmodels/
        │   └── home_viewmodel.dart  # 🧠 业务逻辑和状态管理
        │
        └── widgets/
            ├── home_screen.dart       # 🎨 主界面
            ├── section_title.dart     # 区域标题
            ├── info_card.dart         # 信息卡片
            ├── data_input_field.dart  # 数据输入框
            ├── action_buttons.dart    # 操作按钮组
            ├── vip_switch.dart        # VIP 开关
            ├── country_list_card.dart     # 国家列表卡片
            ├── country_list_item.dart     # 国家列表项
            ├── add_country_button.dart    # 添加国家按钮
            └── simple_message_overlay.dart # 底部消息提示
│
├── ARCHITECTURE.md              # 🏗️ 架构详细说明
├── README.md                    # 📖 项目总览
└── QUICK_START.md               # 🚀 本文件
```

---

## 第五步：修改和实验

### 🎨 修改主题颜色

编辑 `main.dart`：

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,  // 改成紫色主题
  ),
  useMaterial3: true,
),
```

可选颜色：
- `Colors.blue` - 蓝色
- `Colors.green` - 绿色
- `Colors.red` - 红色
- `Colors.orange` - 橙色
- `Colors.purple` - 紫色

### ➕ 添加新的保存项（如：保存邮箱）

按照 MVVM 架构，依次在四层中添加代码：

#### 1. Service 层 (`shared_service.dart`)
```dart
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

#### 2. Repository 层 (`shared_repository.dart`)
```dart
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

#### 3. ViewModel 层 (`home_viewmodel.dart`)
```dart
// 添加状态变量
String _email = '';
String _inputEmail = '';

// 添加 Getter
String get email => _email;
String get inputEmail => _inputEmail;

// 添加方法
Future<void> saveEmail() async {
  if (_inputEmail.trim().isEmpty) {
    _message = '邮箱不能为空';
    _shouldShowMessage = true;
    notifyListeners();
    return;
  }
  
  _isLoading = true;
  notifyListeners();
  
  try {
    await _repository.saveEmail(_inputEmail.trim());
    _email = _inputEmail.trim();
    _message = '邮箱保存成功：$_email';
    _shouldShowMessage = true;
  } catch (e) {
    _message = '保存失败：$e';
    _shouldShowMessage = true;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

Future<void> checkEmail() async {
  // 类似 checkUsername 的实现
}

Future<void> clearEmail() async {
  await _repository.clearEmail();
  _email = '';
  _inputEmail = '';
  _message = '邮箱已清除';
  _shouldShowMessage = true;
  notifyListeners();
}

void updateInputEmail(String value) {
  _inputEmail = value;
  notifyListeners();
}
```

#### 4. View 层 (`home_screen.dart`)
在合适的位置添加：
```dart
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

---

## ❓ 常见问题

### Q: 数据保存在哪里？
**A:** 不同平台保存在不同位置：
- **Windows**: 注册表（Registry）
- **Android**: SharedPreferences 文件（`/data/data/包名/shared_prefs/`）
- **iOS**: NSUserDefaults（沙盒目录）
- **Web**: localStorage（浏览器本地存储）

### Q: 数据会永久保存吗？
**A:** 是的，除非：
- 用户清除应用数据
- 卸载应用
- 手动调用清除方法
- 设备存储损坏

### Q: 可以保存对象吗？
**A:** 不可以直接保存复杂对象。需要：
1. 将对象转为 JSON 字符串（使用 `dart:convert`）
2. 保存字符串
3. 读取时再解析为对象

示例：
```dart
// 保存
final user = {'name': '张三', 'age': 25};
await _prefs.setString('user', jsonEncode(user));

// 读取
final userStr = _prefs.getString('user');
final user = jsonDecode(userStr);
```

### Q: 保存有数量限制吗？
**A:** 有，但很宽松：
- **Android**: 约几 MB（适合存储简单配置）
- **iOS**: 无明确限制，但建议少量数据
- **Windows**: 取决于注册表空间
- **Web**: 通常 5-10 MB（localStorage 限制）

⚠️ **建议**：SharedPreferences 仅适合存储：
- ✅ 用户偏好设置
- ✅ 简单的应用配置
- ✅ 少量用户数据

❌ **不适合**存储：
- 大量数据
- 复杂的关系数据
- 需要频繁修改的大文件

### Q: 为什么加载时看不到数据？
**A:** 检查以下几点：
1. 是否之前保存过数据
2. 是否清除了应用数据
3. 查看控制台是否有错误日志
4. 确认键名是否正确（区分大小写）

### Q: 国家列表为什么要区分"未保存"和"保存过空列表"？
**A:** 这是两种不同的业务状态：
- **未保存**：用户从未点击过保存按钮
- **保存过空列表**：用户明确保存了一个空列表

这种区分在某些场景下很重要，比如：
- 判断用户是否完成某个步骤
- 区分默认状态和用户主动设置的状态

### Q: 粉丝数为什么要用 -1 表示未保存？
**A:** 因为：
1. 粉丝数正常值应该是 >= 0
2. -1 是一个明显的标记值
3. 可以区分"未保存"和"保存了 0"

---

## 🔍 调试技巧

### 查看保存的数据

在 `home_viewmodel.dart` 的保存方法后添加：
```dart
debugPrint('已保存用户名：$_username');
debugPrint('已保存粉丝数：$_fansAmount');
```

### 查看加载过程

在 `_loadData` 方法中添加：
```dart
debugPrint('正在加载数据...');
final username = await _repository.getUsername();
debugPrint('加载的用户名：$username');

final fansAmount = await _repository.getFansAmountOrDefault();
debugPrint('加载的粉丝数：$fansAmount');
```

### 查看错误信息

在 catch 块中：
```dart
catch (e) {
  debugPrint('错误详情：$e');
  debugPrint('错误堆栈：$stackTrace');
  _message = '保存失败：$e';
}
```

### 查看国家列表内容

```dart
debugPrint('国家列表：${_countryList.join(', ')}');
debugPrint('是否保存过：$_hasCountryList');
debugPrint('列表长度：${_countryList.length}');
```

### 调试消息提示

如果消息提示不显示，可以添加调试日志：

**ViewModel 层** (`home_viewmodel.dart`):
```dart
Future<void> saveUsername() async {
  // ... 保存逻辑
  _message = '保存成功';
  _shouldShowMessage = true;
  debugPrint('设置 shouldShowMessage = true, message: $_message');
  notifyListeners();
}

void clearMessage() {
  _shouldShowMessage = false;
  debugPrint('清除消息：shouldShowMessage = false');
  notifyListeners();
}
```

**View 层** (`home_screen.dart`):
```dart
@override
Widget build(BuildContext context) {
  final viewModel = context.watch<HomeViewModel>();
  
  debugPrint('build: shouldShowMessage = ${viewModel.shouldShowMessage}');
  
  if (viewModel.shouldShowMessage) {
    debugPrint('准备显示消息：${viewModel.message}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        debugPrint('context.mounted = true, 显示消息');
        SimpleMessageOverlay.show(context, viewModel.message);
        viewModel.clearMessage();
      } else {
        debugPrint('context.mounted = false, 不显示消息');
      }
    });
  }
  
  return _buildScaffold(context, viewModel);
}
```

**查看控制台输出**：
```
build: shouldShowMessage = true
准备显示消息：保存成功
context.mounted = true, 显示消息
清除消息：shouldShowMessage = false
build: shouldShowMessage = false
```

---

## 📖 下一步学习

完成本快速启动指南后，建议继续学习：

1. ✅ **阅读 `README.md`**
   - 了解项目详细功能
   - 查看依赖包说明
   - 学习扩展建议

2. 🏗️ **阅读 `ARCHITECTURE.md`**
   - 深入理解 MVVM 架构
   - 学习数据流向
   - 掌握设计模式

3. 🔍 **查看官方文档**
   - [SharedPreferences 官方文档](https://pub.dev/packages/shared_preferences)
   - [Provider 包文档](https://pub.dev/packages/provider)
   - [Flutter 状态管理指南](https://flutter.dev/docs/development/data-and-backend/state-mgmt)

4. 🎯 **动手实践**
   - 尝试添加新的保存项（如：邮箱、电话、地址等）
   - 修改主题颜色和 UI 样式
   - 添加数据验证规则
   - 实现数据导入导出功能

5. 📚 **深入学习**
   - Flutter 官方文档：https://flutter.dev/docs
   - Provider 包文档：https://pub.dev/packages/provider
   - Dart 异步编程：https://dart.dev/guides/libraries/futures-error-handling

---

## 🎉 祝你学习愉快！

如果遇到问题，可以：
- 查看控制台错误日志
- 检查代码是否有红色波浪线
- 参考 `ARCHITECTURE.md` 中的架构图
- 对比示例代码检查实现

**记住**：理解架构比记住代码更重要！💪
