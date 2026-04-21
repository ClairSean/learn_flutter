# 常见问题（FAQ）

## 关于 Drift 的常见问题解答

---

## 一、数据库的使用

按照入门指南创建 `MyDatabase` 类后，你还需要获取该类的实例。官方推荐**仅使用一个单例实例**，你可以将该实例存储在全局变量中：

### 原生 Flutter 方案

```dart
late MyDatabase database;

void main() {
  database = MyDatabase();
  runApp(MyFlutterApp());
}
```

更规范的方式是使用 `InheritedWidgets`，`provider` 包可以简化这一操作：

### Provider 方案

如果使用 provider 包，可以在顶层组件外层包裹用于管理数据库实例的 Provider：

```dart
void main() {
  runApp(
    Provider<MyDatabase>(
      create: (context) => MyDatabase(),
      child: MyFlutterApp(),
      dispose: (context, db) => db.close(),
   ),
  );
}
```

组件中可通过 `Provider.of<MyDatabase>(context)` 获取数据库实例。

### GetX 方案

如果使用 GetX 包，可以将数据库实例以服务形式注册：

```dart
void main() {
  Get.put(MyDatabase());
  runApp(MyFlutterApp());
}
```

组件中可通过 `Get.find<MyDatabase>().your_method` 获取数据库实例。

### 复杂架构方案

如果严格遵循业务逻辑与组件层分离的架构，通常会使用 `kiwi`、`get_it` 等依赖注入框架管理服务与视图模型。在你常用的 Flutter 依赖注入框架中创建 `MyDatabase` 单例，即可解决实例获取问题。

---

## 二、为什么会出现「无此表（no such table）」错误？

如果应用已安装运行后，你新增了一张数据表，就需要编写**数据迁移脚本**来创建这张表。

如果你处于应用开发阶段，不想编写迁移脚本，也可以卸载并重新安装应用。注意：安卓设备可能会自动备份应用数据，部分设备需要**手动清除应用数据**，而非仅卸载重装。

---

## 三、如何修复生成文件中的代码检查（lint）警告？

根据你的代码检查规则配置，Drift 生成的 `.g.dart` 文件中可能会出现警告。由于代码检查主要针对人工编写的代码，我们建议**对生成文件禁用静态分析**。

在项目根目录创建 `analysis_options.yaml` 文件，添加以下内容：

```yaml
analyzer:
  exclude:
    - "**/*.g.dart"
```

修改后可能需要重启 IDE 才能生效。

---

## 四、如何查看生成的 SQL 语句？

所有数据库实现（`NativeDatabase`、`FlutterQueryExecutor` 等）都提供 `logStatements` 参数，将其设为 `true` 即可启用 SQL 日志打印：
启用后，Drift 会在控制台输出执行的所有 SQL 语句。

---

## 五、如何在应用首次启动时插入初始数据？

你可以通过自定义迁移策略，在应用首次启动时填充初始数据。
在数据库创建时（通常为应用首次运行）插入数据，示例如下：

```dart
MigrationStrategy(
  onCreate: (m) async {
    await m.createAll(); // 创建所有表
    await into(myTable).insert(...); // 首次运行时插入数据
  }
)
```

`onCreate` 回调中还可以使用事务或批量插入操作。

另一种方案：在应用资源中内置**预填充数据库**，直接使用该数据库文件：

```dart
QueryExecutor databaseWithDefaultAsset(File file, String asset) {
  // LazyDatabase 支持异步初始化操作
  return LazyDatabase(() async {
    if (!await file.exists()) {
      // 数据库不存在，从资源中复制默认数据库
      final content = await rootBundle.load(asset);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(content.buffer.asUint8List(0));
    }
  });
}
```

---

## 六、生成的代码使用了同名的其他类？

如果在 `database.dart` 中导入了与待生成类同名的类，运行 `build_runner` 时，生成代码会错误使用导入的同名类，而非 Drift 应生成的类，这是已知问题。

解决方案（条件允许时）：
启用**模块化代码生成**。该方式会小幅改变 Drift 的使用方式，通常只需修改少量文件的导入语句即可适配。
核心区别：模块化生成会让 Drift 输出独立库文件，而非 `part` 文件，独立文件可拥有专属导入声明，即使 `database.dart` 导入了同名类，也能正确使用生成的类。

---

## 七、Drift 与其他数据库库对比如何？

Dart/Flutter 生态中有多款优秀的持久化库，以下是不完全对比（难免带有主观倾向）。如果你有相关使用经验，欢迎为本页面贡献内容。

### sqflite / sqlite3

sqflite 是为 iOS/Android 提供 SQLite API 绑定的 Flutter 包，维护良好、API 稳定。事实上 `moor_flutter`、`drift_sqflite` 均基于 sqflite 构建。
尽管 sqflite 提供了 Dart 侧的简易查询构造 API，但 Drift 具备更多优势：

- 为查询生成**类型安全映射代码**
- 为查询提供**自动更新数据流**
- 自动管理 `CREATE TABLE` 语句与大部分结构迁移
- 更流畅的链式查询 API

对于不需要这些特性的大部分应用，sqflite 仍是合适的持久化方案。
`sqlite3` 包同理：`package:drift/native.dart` 基于该库实现，并在其之上提供了额外能力。

### sqlcool

sqlcool 是基于 sqflite 的轻量级库，简化了查询编写与结构管理，同样支持自动更新数据流。
如果你不需要生成代码解析查询结果，sqlcool 可作为 Drift 的替代方案。

### floor

floor 同样提供自动更新查询、结构迁移等便捷特性，与 Drift 类似：在 Dart 中定义数据库结构，再手写 SQL 查询，由 floor 生成映射代码。
Drift 具备同类能力，且能在**编译期校验 SQL 合法性**；此外 Drift 还支持用 Dart 代码编写部分查询，无需手写 SQL。

两者的区别：
floor 允许你自定义实体类，围绕类生成映射代码；
Drift 默认自动生成大部分数据类，上手更简单，但部分场景下 API 灵活性稍弱（Drift 也支持自定义行数据类）。

### firebase

Realtime Database、Cloud Datastore 均是易用的持久化库，支持离线使用与多端同步，均提供自动更新数据流与简易查询 API。
但两者均**不属于关系型数据库**，不支持聚合函数、联表查询、复杂筛选等 SQL 核心特性。

Firebase 适合以下场景：

- 数据模型可表示为文档，而非关系结构
- 无自建后端，但需要数据同步能力

---

## 八、我可以查看 Drift 数据库吗？

可以！Drift 数据存储在 sqlite3 数据库文件中，可从设备导出并在本地查看。

如需在应用内直接查看 Drift 数据库，可使用 Koen Van Looveren 开发的 `drift_db_viewer` 包。

此外，引入 Drift 后会附带一个**开发中的 DevTools 扩展**，打开 DevTools 即可使用，欢迎反馈与贡献。
