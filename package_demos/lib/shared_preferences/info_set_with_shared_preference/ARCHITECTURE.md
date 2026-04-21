# 🏗️ MVVM 架构数据流图

## 📋 项目架构概览

本项目采用标准的 **MVVM (Model-View-ViewModel)** 架构，实现了 5 个完整的数据管理功能：

| 功能模块     | 数据类型       | 存储键名         | 特殊处理                  |
| ------------ | -------------- | ---------------- | ------------------------- |
| **用户名**   | `String`       | `username`       | 不能为空                  |
| **粉丝数**   | `int`          | `fans_amount`    | -1 表示未保存，不能为负数 |
| **账号权重** | `double`       | `account_weight` | 范围 0-1                  |
| **VIP 状态** | `bool`         | `is_vip`         | 布尔开关                  |
| **国家列表** | `List<String>` | `country_list`   | 支持展开/收起，CRUD 操作  |

## 🏛️ 完整架构图

```
┌─────────────────────────────────────────────────────────────────┐
│                         View 层                                  │
│  lib/shared_preferences/ui/home/widgets/home_screen.dart        │
│                                                                  │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐   │
│  │ 用户名区域 │  │ 粉丝数区域 │  │账号权重区域│  │ VIP 状态区域 │   │
│  └─────┬─────┘  └─────┬─────┘  └─────┬─────┘  └─────┬─────┘   │
│        │              │              │              │           │
│        └──────────────┴──────────────┴──────────────┘           │
│                              │                                   │
│                      ┌───────▼───────┐                          │
│                      │  国家列表区域  │                          │
│                      │  (可展开卡片)  │                          │
│                      └───────┬───────┘                          │
│                              │                                   │
│  ┌───────────────────────────▼───────────────────────────┐     │
│  │              消息提示 (SimpleMessageOverlay)           │     │
│  └───────────────────────────────────────────────────────┘     │
│                                                                  │
│  所有 UI 组件通过 context.watch<HomeViewModel>() 监听状态变化    │
└───────────────────────────┬───────────────────────────────────┘
                            │
                            │ onChanged / onTap / onPressed
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                      ViewModel 层                                │
│      lib/shared_preferences/ui/home/viewmodels/                 │
│              home_viewmodel.dart                                │
│                                                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │                  HomeViewModel                         │    │
│  │  extends ChangeNotifier                                │    │
│  │                                                        │    │
│  │  // 状态数据 (私有)                                     │    │
│  │  String _username           // 已保存的用户名           │    │
│  │  String _inputUsername      // 输入中的用户名          │    │
│  │  int _fansAmount            // 已保存的粉丝数          │    │
│  │  String _inputFansAmount    // 输入中的粉丝数          │    │
│  │  double? _accountWeight     // 已保存的账号权重        │    │
│  │  String _inputAccountWeight // 输入中的账号权重        │    │
│  │  bool _isVip                // 已保存的 VIP 状态        │    │
│  │  bool _inputIsVip           // 输入中的 VIP 状态       │    │
│  │  List<String> _countryList  // 已保存的国家列表        │    │
│  │  List<String> _inputCountryList // 输入中的国家列表    │    │
│  │  bool _isCountryListExpanded  // 国家列表是否展开      │    │
│  │  bool _hasCountryList       // 是否保存过国家列表      │    │
│  │  String _message            // 消息内容                │    │
│  │  bool _shouldShowMessage    // 是否显示消息            │    │
│  │  bool _isLoading            // 是否加载中              │    │
│  │                                                        │    │
│  │  // 用户名方法                                         │    │
│  │  Future<void> saveUsername()                          │    │
│  │  Future<void> checkUsername()                         │    │
│  │  Future<void> clearUsername()                         │    │
│  │  void updateInputUsername(String value)               │    │
│  │                                                        │    │
│  │  // 粉丝数方法                                         │    │
│  │  Future<void> saveFansAmount()                        │    │
│  │  Future<void> checkFansAmount()                       │    │
│  │  Future<void> clearFansAmount()                       │    │
│  │  void updateInputFansAmount(String value)             │    │
│  │                                                        │    │
│  │  // 账号权重方法                                       │    │
│  │  Future<void> saveAccountWeight()                     │    │
│  │  Future<void> checkAccountWeight()                    │    │
│  │  Future<void> clearAccountWeight()                    │    │
│  │  void updateInputAccountWeight(String value)          │    │
│  │                                                        │    │
│  │  // VIP 状态方法                                        │    │
│  │  Future<void> saveIsVip()                             │    │
│  │  Future<void> checkIsVip()                            │    │
│  │  Future<void> clearIsVip()                            │    │
│  │  void updateInputIsVip(bool value)                    │    │
│  │                                                        │    │
│  │  // 国家列表方法                                       │    │
│  │  Future<void> saveCountryList()                       │    │
│  │  Future<void> checkCountryList()                      │    │
│  │  Future<void> clearCountryList()                      │    │
│  │  void toggleCountryListExpanded()                     │    │
│  │  void addCountry()                                    │    │
│  │  void updateCountry(int index, String value)          │    │
│  │  void removeCountry(int index)                        │    │
│  │                                                        │    │
│  │  // 通用方法                                           │    │
│  │  Future<void> init()                                  │    │
│  │  Future<void> refresh()                               │    │
│  │  void clearMessage()                                  │    │
│  └───────────────────┬────────────────────────────────────┘    │
│                      │                                          │
│                      │ 调用                                      │
│                      ▼                                          │
└─────────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────────┐
│                    Repository 层                                 │
│      lib/shared_preferences/data/repositories/                  │
│              shared_repository.dart                             │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  SharedRepository                                        │   │
│  │                                                          │   │
│  │  final SharedService _service                            │   │
│  │                                                          │   │
│  │  // 用户名相关                                           │   │
│  │  Future<void> saveUsername(String username)              │   │
│  │  Future<String?> getUsername()                           │   │
│  │  Future<bool> checkUsername(String username)             │   │
│  │  Future<bool> hasUsername()                              │   │
│  │  Future<void> clearUsername()                            │   │
│  │                                                          │   │
│  │  // 粉丝数相关                                           │   │
│  │  Future<void> saveFansAmount(int fansAmount)             │   │
│  │  Future<int?> getFansAmount()                            │   │
│  │  Future<int> getFansAmountOrDefault()                    │   │
│  │  Future<bool> checkFansAmount(int fansAmount)            │   │
│  │  Future<bool> hasFansAmount()                            │   │
│  │  Future<void> clearFansAmount()                          │   │
│  │                                                          │   │
│  │  // 账号权重相关                                         │   │
│  │  Future<void> saveAccountWeight(double weight)           │   │
│  │  Future<double?> getAccountWeight()                      │   │
│  │  Future<double> getAccountWeightOrDefault()              │   │
│  │  Future<bool> checkAccountWeight(double weight)          │   │
│  │  Future<bool> hasAccountWeight()                         │   │
│  │  Future<void> clearAccountWeight()                       │   │
│  │                                                          │   │
│  │  // VIP 状态相关                                          │   │
│  │  Future<void> saveIsVip(bool isVip)                      │   │
│  │  Future<bool> getIsVip()                                 │   │
│  │  Future<bool> checkIsVip(bool isVip)                     │   │
│  │  Future<bool> hasIsVip()                                 │   │
│  │  Future<void> clearIsVip()                               │   │
│  │                                                          │   │
│  │  // 国家列表相关                                         │   │
│  │  Future<void> saveCountryList(List<String> countries)    │   │
│  │  Future<List<String>> getCountryList()                   │   │
│  │  Future<bool> checkCountryList(List<String> countries)   │   │
│  │  Future<bool> hasCountryList()                           │   │
│  │  Future<void> clearCountryList()                         │   │
│  └────────────────────┬─────────────────────────────────────┘   │
│                       │                                          │
│                       │ 委托调用                                  │
│                       ▼                                          │
└─────────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────────┐
│                      Service 层                                  │
│      lib/shared_preferences/data/services/                      │
│              shared_service.dart                                │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  SharedService                                           │   │
│  │                                                          │   │
│  │  final SharedPreferencesAsync _prefs                     │   │
│  │                                                          │   │
│  │  // 直接操作 SharedPreferences                            │   │
│  │  // 所有方法都对应具体的存储键名                          │   │
│  │  // 并进行基础验证                                        │   │
│  │                                                          │   │
│  │  // 示例方法签名                                         │   │
│  │  Future<void> saveUsername(String username) {            │   │
│  │    await _prefs.setString('username', username);         │   │
│  │  }                                                       │   │
│  │                                                          │   │
│  │  Future<List<String>> getCountryList() async {           │   │
│  │    return await _prefs.getStringList('country_list')     │   │
│  │           ?? [];                                         │   │
│  │  }                                                       │   │
│  └────────────────────┬─────────────────────────────────────┘   │
│                       │                                          │
│                       │ 调用原生 API                             │
│                       ▼                                          │
└─────────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────────┐
│                   SharedPreferencesAsync                         │
│                  (package:shared_preferences)                    │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  支持的数据类型和方法：                                   │   │
│  │                                                          │   │
│  │  Future<void> setString(key, value)                      │   │
│  │  Future<void> setInt(key, value)                         │   │
│  │  Future<void> setDouble(key, value)                      │   │
│  │  Future<void> setBool(key, value)                        │   │
│  │  Future<void> setStringList(key, value)                  │   │
│  │                                                          │   │
│  │  Future<String?> getString(key)                          │   │
│  │  Future<int?> getInt(key)                                │   │
│  │  Future<double?> getDouble(key)                          │   │
│  │  Future<bool?> getBool(key)                              │   │
│  │  Future<List<String>?> getStringList(key)                │   │
│  │                                                          │   │
│  │  Future<bool> remove(key)                                │   │
│  │  Future<bool> clear()                                    │   │
│  │  Future<bool> containsKey(key)                           │   │
│  └────────────────────┬─────────────────────────────────────┘   │
│                       │                                          │
│                       │ 平台原生实现                             │
│                       ▼                                          │
└─────────────────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
    ┌─────────┐          ┌─────────┐         ┌─────────┐
    │ Android │          │   iOS   │         │ Windows │
    │ SharedPreferences│  │ NSUserDefaults│ │ Registry│
    └─────────┘          └─────────┘         └─────────┘
```

## 🔄 数据流向详解

### 1️⃣ 写入流程（以保存国家列表为例）

```
用户操作：展开卡片 → 添加 3 个国家 → 点击保存
    │
    ▼
View 层调用 viewModel.saveCountryList()
    │
    ▼
ViewModel 设置 _isLoading = true
    │  调用 notifyListeners()
    │  显示加载遮罩
    │
    ▼
调用 _repository.saveCountryList(_inputCountryList)
    │
    ▼
调用 _service.saveCountryList(['中国', '美国', '日本'])
    │
    ▼
调用 _prefs.setStringList('country_list', ['中国', '美国', '日本'])
    │
    ▼
异步写入 SharedPreferences
    │
    ▼
返回 Future<void>
    │
    ▼
ViewModel 更新状态：
  - _countryList = ['中国', '美国', '日本']
  - _hasCountryList = true
  - _isCountryListExpanded = false
  - _message = '国家列表保存成功（3 个国家）'
  - _shouldShowMessage = true
    │
    ▼
调用 notifyListeners()
    │
    ▼
View 层重建：
  - 卡片显示"已保存 3 个国家"
  - 收起列表
  - 底部弹出消息提示
  - 隐藏加载遮罩
```

### 2️⃣ 读取流程（初始化加载）

```
ViewModel.init()
    │
    ▼
调用 _loadData()
    │
    ├─ 调用 _repository.getUsername()
    │     └─ 从 SharedPreferences 读取 'username'
    │
    ├─ 调用 _repository.getFansAmountOrDefault()
    │     └─ 从 SharedPreferences 读取 'fans_amount'，无值返回 -1
    │
    ├─ 调用 _repository.getAccountWeight()
    │     └─ 从 SharedPreferences 读取 'account_weight'
    │
    ├─ 调用 _repository.getIsVip()
    │     └─ 从 SharedPreferences 读取 'is_vip'
    │
    └─ 调用 _repository.getCountryList()
          └─ 从 SharedPreferences 读取 'country_list'
    │
    ▼
所有数据加载完成
    │
    ▼
ViewModel 更新所有状态变量
    │
    ▼
调用 notifyListeners()
    │
    ▼
View 层重建，显示所有已保存的数据
```

### 3️⃣ 状态更新流程（响应式）

```
ViewModel 状态变化
    │
    ▼
调用 notifyListeners()
    │
    ▼
Provider 通知所有监听者
    │
    ▼
context.watch<HomeViewModel>() 触发重建
    │
    ▼
Widget 树重新构建
    │
    ├─────────────┬─────────────┬──────────────┐
    ▼             ▼             ▼              ▼
信息卡片      消息提示      加载遮罩      列表项
显示新数据    显示新消息    显示/隐藏     增删改
```

### 4️⃣ 国家列表展开/收起流程

```
用户点击卡片
    │
    ▼
View 层调用 viewModel.toggleCountryListExpanded()
    │
    ▼
ViewModel 切换 _isCountryListExpanded 状态
    │
    ▼
调用 notifyListeners()
    │
    ▼
View 层重建：
  ├─ 卡片箭头方向改变（▲/▼）
  ├─ 列表区域显示/隐藏
  │   ├─ 显示所有国家项（可编辑、删除）
  │   └─ 底部显示"添加国家"按钮
  └─ 操作按钮始终可见（保存/检查/清除）
```

## 🎯 关键设计点

### 1. 单向数据流

```
用户交互 → View → ViewModel → Repository → Service → SharedPreferences
                ↑                                        │
                └─────────── 状态更新 ───────────────────┘
```

**核心原则**：

- 数据只能从 ViewModel 流向 View
- View 不能直接修改数据，只能通过方法调用
- 所有状态变更都必须通过 `notifyListeners()` 通知 View

### 2. 关注点分离

| 层级           | 职责                         | 不负责的           |
| -------------- | ---------------------------- | ------------------ |
| **View**       | UI 展示、接收用户输入        | 业务逻辑、数据存储 |
| **ViewModel**  | 业务逻辑、状态管理、数据验证 | UI 细节、平台 API  |
| **Repository** | 数据源抽象、桥梁             | 业务验证、UI 状态  |
| **Service**    | 直接操作 SharedPreferences   | 业务逻辑、状态管理 |

### 3. 响应式更新机制

```dart
// ViewModel 中
void updateInputUsername(String value) {
  _inputUsername = value;  // 更新状态
  notifyListeners();       // 通知 View
}

// View 中
TextField(
  onChanged: viewModel.updateInputUsername,  // 自动触发更新
  controller: TextEditingController(
    text: viewModel.inputUsername  // 从 ViewModel 获取初始值
  ),
)
```

### 4. 错误处理链

```
用户输入 → ViewModel 验证 → Repository 调用 → Service 验证 → 写入
           ↓                                        ↓
        显示错误                                 显示错误
```

**验证层级**：

1. **ViewModel 层**：业务规则验证（如：不能为空、范围限制）
2. **Service 层**：基础验证（如：类型检查）
3. **try-catch**：捕获所有异常，显示友好错误消息

### 5. 特殊状态处理

#### 粉丝数的 -1 标记

```dart
// ViewModel
int _fansAmount = 0;  // 实际值

// 初始化时
final fansAmount = await _repository.getFansAmountOrDefault();
_fansAmount = fansAmount;  // -1 表示未保存

// View 显示
Text(
  viewModel.fansAmount < 0
    ? '未保存'
    : '${viewModel.fansAmount}',
)
```

#### 国家列表的已保存标记

```dart
// ViewModel
bool _hasCountryList = false;  // 区分"未保存"和"保存过空列表"

// 初始化时
_countryList = await _repository.getCountryList();
_hasCountryList = await _repository.hasCountryList();

// View 显示
Text(
  !viewModel.hasCountryList
    ? '未保存'
    : '已保存 ${viewModel.countryList.length} 个国家',
)
```

## 🧪 测试场景

### 场景 1：保存用户名

1. 用户输入 "张三"
2. 点击保存按钮
3. ViewModel 验证输入不为空
4. Repository 调用 Service
5. Service 写入 SharedPreferences（键名：'username'）
6. ViewModel 更新 `_username` 和 `_inputUsername`
7. View 显示成功消息和新的卡片内容

### 场景 2：检查粉丝数

1. 用户输入 "1000"
2. 点击检查按钮
3. ViewModel 验证输入为有效数字
4. Repository 读取已保存的粉丝数
5. 比较输入值和已保存值
6. ViewModel 更新消息：
   - 匹配：✓ 粉丝数匹配
   - 不匹配：✗ 粉丝数不匹配（已保存：XXX）
   - 未保存：✗ 未保存过粉丝数
7. View 显示对应消息

### 场景 3：账号权重验证

1. 用户输入 "1.5"（超出范围）
2. 点击保存按钮
3. ViewModel 验证发现 > 1.0
4. 直接返回，不调用 Repository
5. 更新消息为"账号权重必须在 0-1 之间"
6. View 显示错误消息

### 场景 4：国家列表 CRUD

1. **创建**：
   - 点击卡片展开列表
   - 点击"添加国家"按钮
   - 在输入框中输入"中国"
   - 点击保存按钮
   - 列表保存成功

2. **读取**：
   - 刷新页面
   - 卡片显示"已保存 1 个国家"
   - 展开卡片，显示"中国"

3. **更新**：
   - 展开卡片
   - 修改"中国"为"中华人民共和国"
   - 点击保存
   - 更新成功

4. **删除**：
   - 展开卡片
   - 点击某个国家项的删除按钮
   - 点击保存
   - 删除成功

5. **清除**：
   - 点击清除按钮
   - 卡片显示"未保存"
   - 设备存储中的数据也被删除

### 场景 5：国家列表边界情况

1. **保存空列表**：
   - 展开卡片，不添加任何国家
   - 点击保存
   - 卡片显示"已保存 0 个国家"（不是"未保存"）

2. **区分未保存和空列表**：
   - 从未保存：显示"未保存"
   - 保存过空列表：显示"已保存 0 个国家"
   - 清除后：显示"未保存"

## 📊 数据持久化策略

### 存储键名映射表

| 功能     | 键名             | 数据类型       | 默认值  | 特殊说明           |
| -------- | ---------------- | -------------- | ------- | ------------------ |
| 用户名   | `username`       | `String`       | `null`  | 空字符串视为未保存 |
| 粉丝数   | `fans_amount`    | `int`          | `-1`    | -1 表示未保存      |
| 账号权重 | `account_weight` | `double`       | `null`  | 范围 0-1           |
| VIP 状态 | `is_vip`         | `bool`         | `false` | 布尔值             |
| 国家列表 | `country_list`   | `List<String>` | `[]`    | 需区分 null 和 []  |

### 清除操作实现

```dart
// 清除用户名
Future<void> clearUsername() async {
  await _repository.clearUsername();  // 调用 Repository
  _username = '';                      // 清空内存状态
  _inputUsername = '';
  _message = '用户名已清除';
  _shouldShowMessage = true;
}

// Repository 层
Future<void> clearUsername() async {
  await _service.clearUsername();  // 调用 Service
}

// Service 层
Future<void> clearUsername() async {
  await _prefs.remove('username');  // 从设备存储中删除
}
```

## 🎨 UI 组件架构

### 组件化设计

```
home_screen.dart
├── SectionTitle          (区域标题)
├── InfoCard              (信息卡片)
├── DataInputField        (数据输入框)
├── ActionButtons         (操作按钮组)
├── VipSwitch             (VIP 开关)
├── CountryListCard       (国家列表卡片)
│   └── 可展开/收起
├── CountryListItem       (国家列表项)
│   ├── 序号
│   ├── 输入框
│   └── 删除按钮
├── AddCountryButton      (添加国家按钮)
└── SimpleMessageOverlay  (消息提示)
```

### 组件复用

- **SectionTitle**：所有区域的标题
- **InfoCard**：用户名、粉丝数、账号权重的展示
- **DataInputField**：所有输入框
- **ActionButtons**：所有操作按钮组（保存/检查/清除）

### 专属组件

- **VipSwitch**：VIP 状态的布尔开关
- **CountryListCard**：国家列表的展开/收起卡片
- **CountryListItem**：国家列表的可编辑项
- **AddCountryButton**：国家列表的添加按钮
- **SimpleMessageOverlay**：底部弹出的消息提示 ✨

## 📢 消息提示系统详解

### 架构设计

消息提示系统采用 **Overlay 独立显示** 方案，不依赖主 UI 重建：

```
┌─────────────────────────────────────────────────────────┐
│                    ViewModel                            │
│  - _message: String           // 消息内容               │
│  - _shouldShowMessage: bool   // 是否显示消息          │
│                                                         │
│  saveUsername() {                                     │
│    // ... 保存逻辑                                     │
│    _message = "保存成功";                              │
│    _shouldShowMessage = true;                          │
│    notifyListeners();  // 通知 View                    │
│  }                                                      │
│                                                         │
│  clearMessage() {                                     │
│    _shouldShowMessage = false;                         │
│    notifyListeners();  // 清理状态                     │
│  }                                                      │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ notifyListeners()
                     ▼
┌─────────────────────────────────────────────────────────┐
│                    View 层                              │
│  build() {                                              │
│    if (viewModel.shouldShowMessage) {                   │
│      // 在帧结束后异步显示，避免 build 中直接调用       │
│      WidgetsBinding.instance.addPostFrameCallback((_) { │
│        SimpleMessageOverlay.show(context, message);     │
│        viewModel.clearMessage();                        │
│      });                                                │
│    }                                                    │
│  }                                                      │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ 插入到 Overlay
                     ▼
┌─────────────────────────────────────────────────────────┐
│              SimpleMessageOverlay                       │
│  - 独立的 Overlay 弹窗                                   │
│  - 不依赖主 UI 状态                                      │
│  - 3 秒后自动消失                                        │
│  - 支持多个消息堆叠显示                                 │
└─────────────────────────────────────────────────────────┘
```

### 关键实现要点

#### ✅ 正确做法

```dart
// View 层 build 方法中
if (viewModel.shouldShowMessage) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) {
      SimpleMessageOverlay.show(context, viewModel.message);
      viewModel.clearMessage();
    }
  });
}
```

#### ❌ 错误做法

```dart
// ❌ 错误 1: 在 build 中直接调用（会导致无限循环）
if (viewModel.shouldShowMessage) {
  SimpleMessageOverlay.show(context, viewModel.message);
  viewModel.clearMessage();
}

// ❌ 错误 2: 使用复杂的状态跟踪（会导致状态不一致）
String? _lastMessageId;
int _messageCount = 0;
if (viewModel.shouldShowMessage) {
  final messageId = '$_messageCount-${viewModel.message}';
  if (_lastMessageId != messageId) {
    // ... 复杂逻辑
  }
}

// ❌ 错误 3: 在 didChangeDependencies 中监听（会循环调用）
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  final viewModel = Provider.of<HomeViewModel>(context, listen: true);
  if (viewModel.shouldShowMessage) {
    // 这会触发 rebuild，rebuild 又会调用这里，无限循环
  }
}
```

### 常见问题排查

**Q: 消息不显示？**

检查清单：

1. ✅ ViewModel 中 `_shouldShowMessage = true`
2. ✅ 调用了 `notifyListeners()`
3. ✅ View 层 `build()` 中检查了 `shouldShowMessage`
4. ✅ 在 `addPostFrameCallback` 中调用
5. ✅ `context.mounted` 返回 `true`

**Q: 为什么第一次点击不显示，第二次才显示？**

可能原因：

- ❌ 使用了全局计数器跟踪状态（计数器不一致）
- ❌ 在 `build()` 中直接调用（导致无限循环）
- ❌ `clearMessage()` 调用时机不对（在 overlay 显示前就清除了）

**解决方案**：

```dart
// ✅ 简单可靠的方案
if (viewModel.shouldShowMessage) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) {
      SimpleMessageOverlay.show(context, viewModel.message);
      viewModel.clearMessage();  // 在 overlay 开始显示后清除
    }
  });
}
```

**Q: 为什么消息会重复显示？**

可能原因：

- ❌ `clearMessage()` 没有调用 `notifyListeners()`
- ❌ `addPostFrameCallback` 中缺少 `context.mounted` 检查

**解决方案**：

```dart
// ✅ ViewModel 层
void clearMessage() {
  _shouldShowMessage = false;
  notifyListeners();  // 必须调用！
}

// ✅ View 层
WidgetsBinding.instance.addPostFrameCallback((_) {
  if (context.mounted) {  // 必须检查！
    SimpleMessageOverlay.show(context, viewModel.message);
    viewModel.clearMessage();
  }
});
```

### 设计优势

1. **独立性**：Overlay 独立于主 UI，不受其他状态影响
2. **简单性**：只用一个布尔标志位，没有复杂状态跟踪
3. **可靠性**：每次都是全新的 overlay，不会状态混乱
4. **异步性**：使用 `addPostFrameCallback` 确保在正确的时机显示
5. **安全性**：`context.mounted` 检查避免内存泄漏

---

## 🔧 扩展性设计

### 添加新功能（如：保存邮箱）

按照以下顺序依次添加：

#### 1. Service 层

```dart
// shared_service.dart
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

#### 2. Repository 层

```dart
// shared_repository.dart
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

#### 3. ViewModel 层

```dart
// home_viewmodel.dart
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

#### 4. View 层

```dart
// home_screen.dart
const SectionTitle(title: '邮箱管理'),
const SizedBox(height: 16),
DataInputField(
  label: '邮箱',
  hintText: '请输入邮箱',
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
4. **代码复用**：通用组件可复用在多个功能中
5. **状态管理**：使用 Provider 实现响应式状态更新

## 📝 最佳实践

### 1. 命名规范

- **状态变量**：`_` + 驼峰命名（如：`_username`）
- **输入变量**：`_input` + 驼峰命名（如：`_inputUsername`）
- **方法命名**：动词 + 名词（如：`saveUsername`）
- **Getter**：与状态变量同名（如：`username`）

### 2. 状态同步

```dart
// 保存成功后，同步已保存状态和输入状态
_username = _inputUsername.trim();

// 清除后，清空所有相关状态
_username = '';
_inputUsername = '';
```

### 3. 消息提示

```dart
// 成功消息：具体明确
_message = '用户名保存成功：$_username';

// 失败消息：包含错误原因
_message = '保存失败：$e';

// 验证消息：指导用户
_message = '用户名不能为空';
```

### 4. 加载状态

```dart
// 开始时设置加载状态
_isLoading = true;
notifyListeners();

try {
  // 执行异步操作
  await _repository.saveUsername(username);
} catch (e) {
  // 处理错误
} finally {
  // 结束时清除加载状态
  _isLoading = false;
  notifyListeners();
}
```

## 🎓 学习要点

### 初级

- ✅ 理解 MVVM 三层架构
- ✅ 掌握 SharedPreferences 基本用法
- ✅ 学会使用 Provider 进行状态管理

### 中级

- ✅ 理解单向数据流
- ✅ 掌握响应式编程思想
- ✅ 学会组件化开发

### 高级

- ✅ 理解架构分层的重要性
- ✅ 掌握状态同步的技巧
- ✅ 学会设计可扩展的架构

## 📚 相关资源

- [Flutter 官方文档](https://flutter.dev/docs)
- [Provider 包文档](https://pub.dev/packages/provider)
- [SharedPreferences 包文档](https://pub.dev/packages/shared_preferences)
- [MVVM 架构模式](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
