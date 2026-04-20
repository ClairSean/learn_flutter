# UI 组件说明

## 📁 组件结构

```
widgets/
├── home_screen.dart           # 主屏幕（组合其他组件）
├── section_title.dart         # 区域标题组件
├── info_card.dart             # 信息卡片组件
├── data_input_field.dart      # 数据输入框组件
├── action_buttons.dart        # 操作按钮组组件
├── message_card.dart          # 消息提示卡片组件（旧版，已弃用）
├── message_snack_bar.dart     # 底部弹出消息提示（新版）✨
└── vip_switch.dart            # VIP 状态切换开关 ✨
```

## 🧩 组件详情

### 1. SectionTitle（区域标题）

**文件**: `section_title.dart`

**用途**: 显示每个功能区的标题

**参数**:

- `title: String` - 标题文本

**示例**:

```dart
const SectionTitle(title: '用户名管理')
```

**特点**:

- 18px 粗体字
- 简洁专注，只负责显示标题

---

### 2. InfoCard（信息卡片）

**文件**: `info_card.dart`

**用途**: 显示已保存的数据信息

**参数**:

- `icon: IconData` - 左侧图标
- `title: String` - 信息标题（小字）
- `content: String` - 主要内容（大字加粗）
- `color: Color` - 主题色

**示例**:

```dart
InfoCard(
  icon: Icons.person,
  title: '已保存的用户名',
  content: '张三',
  color: Colors.blue,
)
```

**特点**:

- 卡片样式
- 图标 + 标题 + 内容三栏布局
- 内容自动加粗显示

---

### 3. DataInputField（数据输入框）

**文件**: `data_input_field.dart`

**用途**: 标准化的数据输入框

**参数**:

- `controller: TextEditingController` - 文本控制器
- `labelText: String` - 标签文本
- `hintText: String` - 提示文本
- `keyboardType: TextInputType?` - 键盘类型
- `onChanged: ValueChanged<String>?` - 值变化回调

**示例**:

```dart
DataInputField(
  controller: _usernameController,
  labelText: '用户名',
  hintText: '请输入用户名',
  onChanged: viewModel.updateInputUsername,
)
```

**特点**:

- 统一的 OutlineInputBorder 边框
- 自带 edit 图标
- 支持自定义键盘类型

---

### 4. ActionButtons（操作按钮组）

**文件**: `action_buttons.dart`

**用途**: 标准化的三个操作按钮（保存、检查、清除）

**参数**:

- `isLoading: bool` - 是否加载中（禁用所有按钮）
- `onSave: VoidCallback` - 保存按钮回调
- `onCheck: VoidCallback` - 检查按钮回调
- `onClear: VoidCallback` - 清除按钮回调
- `saveLabel: String` - 保存按钮文本（默认："保存"）
- `checkLabel: String` - 检查按钮文本（默认："检查"）
- `clearLabel: String` - 清除按钮文本（默认："清除"）
- `saveColor: Color?` - 保存按钮颜色（可选）

**示例**:

```dart
ActionButtons(
  isLoading: viewModel.isLoading,
  onSave: viewModel.saveUsername,
  onCheck: viewModel.checkUsername,
  onClear: viewModel.clearUsername,
  saveColor: Colors.blue,
)
```

**特点**:

- 第一行：保存（ElevatedButton）+ 检查（OutlinedButton）
- 第二行：清除（TextButton）
- 加载时自动禁用所有按钮
- 可自定义保存按钮颜色

---

### 6. MessageSnackBar（底部弹出消息提示）✨ **新版**

**文件**: `message_snack_bar.dart`

**用途**: 从页面底部弹出的气泡框消息提示，3 秒后自动消失

**参数**:

- `message: String` - 消息内容（必填）
- `onDismiss: VoidCallback?` - 关闭回调（可选）

**示例**:

```dart
MessageSnackBar(
  message: viewModel.message,
  onDismiss: () {
    print('消息已关闭');
  },
)
```

**特点**:

- ✨ 从底部滑入动画（SlideTransition）
- ✨ 3 秒后自动消失
- ✨ 可手动点击关闭按钮
- ✨ 智能识别消息类型：
  - ✅ 成功消息 → 绿色背景 + 对勾图标
  - ❌ 错误消息 → 红色背景 + 错误图标
  - ℹ️ 其他消息 → 蓝色背景 + 信息图标
- ✨ 圆角卡片 + 阴影效果
- ✨ 始终显示在页面底部，不会被滚动遮挡
- ✨ 使用 `SafeArea` 适配刘海屏

**使用方式**:

```dart
Scaffold(
  // ... 其他内容
  bottomSheet: viewModel.message.isNotEmpty
      ? MessageSnackBar(
          message: viewModel.message,
          onDismiss: () => viewModel.clearMessage(),
        )
      : null,
)
```

---

### 7. VipSwitch（VIP 状态切换开关）✨ **新增**

**文件**: `vip_switch.dart`

**用途**: 显示和切换 VIP 状态

**参数**:

- `value: bool` - 当前 VIP 状态
- `onChanged: ValueChanged<bool>` - 状态变化回调

**示例**:

```dart
VipSwitch(
  value: viewModel.inputIsVip,
  onChanged: viewModel.updateInputIsVip,
)
```

**特点**:

- ✨ 卡片样式
- ✨ 根据状态显示不同图标：
  - ✅ VIP → 金色奖杯图标
  - ❌ 非 VIP → 灰色人物轮廓图标
- ✨ 金色主题色
- ✨ 状态文字说明
- ✨ Switch 切换控件

---

### 5. MessageCard（消息提示卡片）⚠️ **旧版，已弃用**

**文件**: `message_card.dart`

**用途**: 内嵌在页面中的消息提示卡片

**状态**: ⚠️ 已弃用，请使用 `MessageSnackBar` 替代

**原因**:

- 固定在页面底部，滚动时会看不到
- 没有动画效果
- 不会自动消失

---

## 🎯 组件使用流程

### 完整示例（用户名区域）

```dart
// 1. 区域标题
const SectionTitle(title: '用户名管理'),
const SizedBox(height: 16),

// 2. 显示已保存的数据
InfoCard(
  icon: Icons.person,
  title: '已保存的用户名',
  content: viewModel.username.isEmpty ? '未保存' : viewModel.username,
  color: Colors.blue,
),
const SizedBox(height: 16),

// 3. 输入框
DataInputField(
  controller: _usernameController,
  labelText: '用户名',
  hintText: '请输入用户名',
  onChanged: viewModel.updateInputUsername,
),
const SizedBox(height: 12),

// 4. 操作按钮
ActionButtons(
  isLoading: viewModel.isLoading,
  onSave: viewModel.saveUsername,
  onCheck: viewModel.checkUsername,
  onClear: viewModel.clearUsername,
  saveColor: Colors.blue,
),
```

---

## 📊 组件优势

### 1. **单一职责**

每个组件只负责一个功能，代码清晰易懂

### 2. **可复用性**

- `InfoCard` 可用于显示任何信息
- `ActionButtons` 可用于任何需要三个操作的场景
- `MessageCard` 可用于任何消息提示

### 3. **易于维护**

- 修改样式只需改对应组件文件
- 不会影响其他组件
- 便于单元测试

### 4. **类型安全**

所有参数都有明确的类型定义和 required 标记

### 5. **可读性强**

主屏幕代码像搭积木一样清晰

---

## 🔧 扩展建议

### 添加新组件

如果需要添加新的 UI 元素，继续拆分成独立组件：

```dart
// 例如：加载指示器组件
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Container(
      color: Colors.black26,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: const TextStyle(color: Colors.white)),
          ],
        ],
      ),
    );
  }
}
```

---

## 📐 代码行数对比

### 重构前

- `home_screen.dart`: 324 行（所有代码在一个文件）

### 重构后

- `home_screen.dart`: 197 行（主屏幕，组合组件）
- `section_title.dart`: 18 行
- `info_card.dart`: 48 行
- `data_input_field.dart`: 30 行
- `action_buttons.dart`: 62 行
- `message_card.dart`: 52 行
- **总计**: 407 行（但每个文件都很小且专注）

### 优势

- ✅ 主文件从 324 行减少到 197 行（减少 39%）
- ✅ 每个组件文件都很小，易于理解
- ✅ 可以单独测试每个组件
- ✅ 新成员可以快速理解每个组件的作用

---

## 🎨 设计模式

使用了 **组合模式（Composite Pattern）**：

- 小组件组合成大组件
- 大组件组合成完整页面
- 类似乐高积木的搭建方式

这是 Flutter 推荐的最佳实践！
