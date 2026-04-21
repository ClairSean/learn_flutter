# Web

Drift 在 Flutter 与 Dart Web 应用中的支持

借助 WebAssembly、源私有文件系统 API 等现代浏览器接口，你可以在 Flutter、Dart 网页版应用中使用 Drift 数据库。和 Drift 核心 API 一致，网页端支持是**跨平台无关**的：Drift 网页端同时支持 Flutter Web、jaspr、原生 `package:web` 以及其他任意 Dart Web 框架。

虽然官方提供了网页版 sqlite3 编译包，但它体积较大、浏览器兼容性差。Drift 使用自研定制编译的 sqlite3，搭配 Dart 接口并复用大量原生平台代码，实现了更快的运行速度，同时兼容更多浏览器。

## 支持的浏览器

当浏览器支持文件系统访问 API 时，Drift 会使用该接口存储数据库；否则会降级为基于共享线程 IndexedDB 的慢速实现。
这让 Drift 可以运行在所有现代浏览器上，即使是不支持官方网页版 sqlite3 的浏览器也可以。部分浏览器需要额外配置 COOP/COEP 请求头才能开启完整功能（Drift 不配置也能运行，但官方 sqlite3 不行）。

| 浏览器                                       | 配置安全请求头   | 不配置安全请求头     |
| -------------------------------------------- | ---------------- | -------------------- |
| Firefox（测试版本 114）                      | 完整支持         | 完整支持             |
| Chrome（测试版本 114）                       | 完整支持         | 良好（速度略慢）     |
| Chrome 安卓版（测试版本 114）                | 完整支持         | 受限（不支持多标签） |
| Safari（测试版本 16.2）                      | 良好（速度略慢） | 良好（速度略慢）     |
| Safari Technology Preview（测试 172 / 17.0） | 完整支持         | 良好                 |

Firefox 无痕浏览窗口暂不支持文件系统访问 API（IndexedDB 从 115 版本开始支持），因此无痕标签页会降级使用 IndexedDB 或内存数据库。

Chrome 安卓版不支持共享线程；如果缺少必要请求头，无法避免多标签数据竞争，可能导致数据持久化异常。Drift 会告知当前使用的存储模式，你可以根据应用数据重要性，引导用户使用原生 App 或更换浏览器。

### 兼容性检测

本页面内置了编译为 JavaScript 的微型 Drift 数据库，可用于验证 Drift 在目标浏览器是否正常工作。点击按钮会执行功能检测，查看当前浏览器会选择哪种文件系统实现、缺少哪些网页 API。

兼容性检测尚未开始。
下文有检测结果详细说明。

---

## 快速入门

### 前置依赖

所有平台下，Drift 都依赖 sqlite3（C 语言编写的主流数据库）。原生平台 Drift 可以打包 sqlite3 库，或使用系统自带版本。

浏览器没有内置 sqlite3，因此必须随应用打包。Drift 内部依赖的 sqlite3 Dart 包提供了编译工具，可以将 sqlite3 编译为 WebAssembly 供浏览器使用。
你可以从官方发布页下载预编译 `sqlite3.wasm`，也可以自行编译，**并将该文件放入应用 web/ 目录**。

Drift 网页端还需要引入 Drift 网页工作线程文件，该线程会在后台线程托管数据库，提升网页性能；部分存储实现还需要它在多标签间实时共享数据库。你同样可以下载官方预编译文件，或自行编译。

#### 下载对应版本文件

请下载和项目依赖版本一致的 `sqlite3.wasm` 与 `drift_worker.dart.js`（不确定可查看 `pubspec.lock` 精确版本）。
文件一般向前兼容新版依赖包，但注意：Drift 当前依赖 sqlite3 2.x 版本，**3.x 版本的 sqlite3.wasm 不兼容**！

最终 web/ 目录结构如下：

```
web/
├── favicon.png
├── index.html
├── manifest.json
├── drift_worker.dart.js
└── sqlite3.wasm
```

### 部署 WASM 文件

浏览器要求 `sqlite3.wasm` 必须以 `Content-Type: application/wasm` 响应头提供。
`flutter run` 默认已配置，但部分自定义服务器没有配置。部署网页后，请检查服务器是否为 wasm 文件设置正确响应头。

### 额外请求头

浏览器支持时，Drift 使用**源私有文件系统 API**高效存储数据库。由于该 API 是异步接口，而 sqlite3 要求同步文件系统，因此需要双线程、共享内存、Atomics.wait/notify。
和官方网页版 sqlite3 一致，网站必须配置两个特殊请求头：

1. `Cross-Origin-Opener-Policy: same-origin`
2. `Cross-Origin-Embedder-Policy: require-corp / credentialless`

详细要求可查看 MDN、web.dev 官方文档。
启动命令可附加参数：

```bash
flutter run --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp
```

直接默认运行 Flutter 时，Drift 会自动降级为慢速实现。生产环境建议尽可能配置这两个请求头。
再次提醒：sqlite3.wasm 必须配置 `application/wasm` 响应头，否则浏览器拒绝加载。

### COOP / COEP 头的缺点

虽然该请求头是源私有文件系统必需、且能提升安全性，但存在已知问题：

1. 和部分打开弹窗的依赖包不兼容（如谷歌登录）
2. Safari 16 存在 Bug：配置该头后专用线程无法缓存，但共享线程、服务线程不受影响

请务必测试应用；如果请求头导致应用异常，不要开启，Drift 会自动降级为其他实现。

---

## Dart 端配置

从 Dart 代码角度，Drift 网页端用法和其他平台基本一致，可参考通用快速入门文档。

如果你使用 `package:drift_flutter` 初始化数据库，传入 WebAssembly 路径与 Drift 工作线程路径即可开启网页支持：

```dart
QueryExecutor connectWithDriftFlutter() {
  return driftDatabase(
    name: 'my_app_db',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.dart.js'),
    ),
  );
}
```

需要自定义数据库打开逻辑（如优先指定存储 API），可参考下一页手动配置方案。
网页端全平台可用完整示例见官方仓库。

---

## 原生应用与网页端共用代码

`package:drift_flutter` 提供了一套同时支持原生+网页的数据库打开方法。

如果你不使用该包、需要更高自定义度，依然可以**单代码库支持全平台**。
数据库文件只导入核心 `package:drift/drift.dart`，不要导入原生/网页专属库；数据库父类传入可自定义的 `QueryExecutor` 即可：

```dart
// 共享代码不要导入 drift/wasm.dart / drift/native.dart
import 'package:drift/drift.dart';

@DriftDatabase(/* ... */)
class SharedDatabase extends _$SharedDatabase {
    SharedDatabase(QueryExecutor e): super(e);
}
```

创建条件导出文件：

- `native.dart`：原生平台实现
- `web.dart`：网页端实现
- `unsupported.dart`：兜底占位库
- `shared.dart`：条件导出入口

原生 Flutter 代码：

```dart
// native.dart
import 'package:drift/native.dart';

SharedDatabase constructDb() {
  final db = LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
  return SharedDatabase(db);
}
```

网页端代码：

```dart
// web.dart
import 'package:drift/wasm.dart';

SharedDatabase constructDb() {
  return SharedDatabase(connectOnWeb());
}

DatabaseConnection connectOnWeb() {
  return DatabaseConnection.delayed(Future(() async {
    final result = await WasmDatabase.open(
      databaseName: 'my_app_db',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
    );

    if (result.missingFeatures.isNotEmpty) {
      print('浏览器缺少功能，当前使用实现：${result.chosenImplementation}，缺失：${result.missingFeatures}');
    }

    return result.resolvedExecutor;
  }));
}
```

兜底占位：

```dart
// unsupported.dart
SharedDatabase constructDb() => throw UnimplementedError();
```

条件导出入口：

```dart
// shared.dart
export 'unsupported.dart'
  if (dart.library.ffi) 'native.dart'
  if (dart.library.js_interop) 'web.dart';
```

官方仓库有完整可运行示例。

---

## 使用已有数据库

可以在网页端 Drift 导入现有数据库，使用 `WasmDatabase.open` 的 `initializeDatabase` 回调。
该回调在数据库不存在时触发，你可以传入初始 sqlite 文件二进制数据：

```dart
return DatabaseConnection.delayed(
  Future(() async {
    final result = await WasmDatabase.open(
      databaseName: 'my_app_db',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
      initializeDatabase: () async {
        final data = await rootBundle.load('my_database');
        return data.buffer.asUint8List();
      },
    );

    return result.resolvedExecutor;
  }),
);
```

注意：仅支持默认日志模式，网页端**不支持 WAL 预写日志**，WAL 数据库也无法通过该方式导入。

---

## 示例

Drift 仓库包含两个网页端示例应用：

- 支持网页端的跨平台 Flutter 应用（源码）

如果你有优秀的开源网页 Drift 项目，欢迎提交 PR 收录。

---

## 高级用法

### 支持的存储实现

打开数据库时，Drift 会检测当前浏览器网页 API 支持情况，自动选择最合适的存储方案（按优先级从高到低排序）。
可通过 `WasmDatabaseResult.chosenImplementation` 查看当前选用方案：

1. **opfsShared**：共享线程中使用源私有文件系统 API，仅 Firefox 实现了该标准
2. **opfsLocks**：源私有文件系统 API，不使用共享线程，需要 COOP/COEP 请求头
3. **sharedIndexedDb**：共享线程中使用 IndexedDB 存储数据块
4. **unsafeIndexedDb**：无共享线程、无多标签同步，多标签同时读写不安全；旧版默认实现，现代浏览器尽量不使用
5. **inMemory**：无持久化 API 时降级为内存数据库

`WasmDatabaseResult.missingFeatures` 会显示缺少的浏览器 API，应用无法手动修改。
如果应用强依赖持久化、Drift 选择了不安全 IndexedDb/内存数据库，请提示用户升级浏览器。

### 自定义数据库打开逻辑

使用 `WasmDatabase.probe` API 可以自定义实现选择，无需直接打开数据库，即可获取当前环境数据库列表、浏览器可用功能。

`probe` 返回 `WasmProbeResult`，可用于：

- 打开数据库 `open()`
- 删除指定数据库 `deleteDatabase()`
- 导出数据库为 Uint8List `exportDatabase()`

### 自定义函数与数据库初始化

原生 `NativeDatabase` 支持初始化回调注册自定义 SQL 函数，但网页端 `WasmDatabase.open` 无法直接支持——因为原生数据库实例运行在网页工作线程，无法直接调用 Dart 回调。

解决方案：编译自定义工作线程，在工作线程内初始化数据库：

```dart
void setupDatabase(CommonDatabase database) {
  database.createFunction(
    functionName: 'my_function',
    function: (args) => args.length,
  );
}

void main() {
  WasmDatabase.workerMainForOpen(setupAllDatabases: setupDatabase);
}
```

应用端打开数据库：

```dart
final result = await WasmDatabase.open(
  databaseName: 'my_app_db',
  sqlite3Uri: Uri.parse('sqlite3.wasm'),
  driftWorkerUri: Uri.parse('my_drift_worker.dart.js'),
  localSetup: setupDatabase,
);
```

`localSetup` 用于非线程运行的内存/IndexedDB 数据库；线程运行数据库会调用工作线程内的 `setupAllDatabases` 创建自定义函数。
下文说明如何编译该 Dart 文件为 JS 工作线程，**无需重新编译 sqlite3.wasm**。

### 编译说明

Drift 和 sqlite3 Dart 包提供预编译工作线程与 WASM 模块，自行编译方式如下：

网页工作线程基于 Dart 编写，入口是 Drift 公开稳定 API：

```dart
import 'package:drift/wasm.dart';

void main() => WasmDatabase.workerMainForOpen();
```

官方发布的 JS 文件编译命令：

```bash
dart compile js -O4 web/drift_worker.dart
```

也可使用 `build_web_compilers` 编译；**必须使用 dart2js**，dartdevc 生成模块不适合工作线程。

编译 sqlite3.wasm 需要 WASM 编译工具链，Arch Linux 可使用 clang + wasi-compiler-rt + wasi-libc；其他系统需自行编译 wasi-sdk，同时使用 binaryen 优化。

sqlite3.dart 仓库自带 CMake 编译脚本：

```bash
git clone https://github.com/simolus3/sqlite3.dart.git
cd sqlite3.dart/sqlite3

cmake -S assets/wasm -B .dart_tool/sqlite3_build --toolchain toolchain.cmake
cmake --build .dart_tool/sqlite3_build/ -t output -j
```

会输出发布版 `sqlite3.wasm` 和调试版 `sqlite3.debug.wasm`（控制台打印文件系统日志）。

---

## 从旧版网页数据库迁移

`WasmDatabase.open` 是 Drift 稳定网页 API，基于旧版实验性网页 API 经验重构，可替换以下旧实现：

1. 基于 sql.js 的 `package:drift/web.dart`
2. 手动加载 WASM 的自定义 `WasmDatabase`
3. 自定义工作线程 `package:drift/web/worker.dart`

迁移优势：Drift 自动管理工作线程，自动选用浏览器最优方案，原生支持共享/专用线程，无需手动配置旧版工作线程 API。

### 迁移自定义旧版 WasmDatabase

旧版手动加载 WASM、手动创建 Sqlite3 实例的迁移方式：

```dart
// 旧打开方式
Future<WasmDatabase> customDatabase() async {
  final sqlite3 = await WasmSqlite3.loadFromUrl(Uri.parse('/sqlite3.wasm'));
  final fs = await IndexedDbFileSystem.open(dbName: 'my_app');
  sqlite3.registerVirtualFileSystem(fs, makeDefault: true);

  return WasmDatabase(sqlite3: sqlite3, path: '/app.db');
}

// 新版迁移方式
final result = await WasmDatabase.open(
  databaseName: 'my_app',
  sqlite3Uri: Uri.parse('sqlite3.wasm'),
  driftWorkerUri: Uri.parse('drift_worker.dart.js'),
  initializeDatabase: () async {
    // 打开旧文件系统
    final fs = await IndexedDbFileSystem.open(dbName: 'my_app');
    const oldPath = '/app.db';

    Uint8List? oldDatabase;

    // 旧库存在则复制数据
    if (fs.xAccess(oldPath, 0) != 0) {
      final (file: file, outFlags: _) = fs.xOpen(
        Sqlite3Filename(oldPath),
        0,
      );
      final blob = Uint8List(file.xFileSize());
      file.xRead(blob, 0);
      file.xClose();
      fs.xDelete(oldPath, 0);

      oldDatabase = blob;
    }

    await fs.close();
    return oldDatabase;
  },
);
```

### 迁移 package:drift/web.dart

使用 `initializeDatabase` 回调，数据库不存在时加载旧库数据，无丢失迁移：

```dart
final result = await WasmDatabase.open(
  databaseName: 'my_app',
  sqlite3Uri: Uri.parse('sqlite3.wasm'),
  driftWorkerUri: Uri.parse('drift_worker.dart.js'),
  initializeDatabase: () async {
    final storage = await DriftWebStorage.indexedDbIfSupported('old_db');
    await storage.open();

    final blob = await storage.restore();
    await storage.close();

    return blob;
  },
);
```

`old_db` 为旧版 `WebDatabase` 传入的数据库名称。

---

## 旧版网页支持

Drift 2019 年最初网页支持基于 sql.js JS 库，至今仍兼容。该实现将数据库放在内存，定期持久化到本地存储。
近年浏览器与 Dart 生态出现更优方案，旧 API 仍为实验性；新版 `WasmDatabase.open` 更稳定高效，旧 API 仅作历史参考保留。

---

## 调试

开启 `WebDatabase` 的 `logStatements` 参数，可在控制台查看 Drift 下发的所有 SQL 语句。
调试模式开启断言时，Drift 会将底层数据库对象挂载到 `window.db`，可直接执行 `db.exec(sql)` 查看数据库状态。
旧版本地存储数据库可通过 `localStorage.clear()` 清空。

网页端支持现已稳定，欢迎提交 Issues 反馈问题。

---

## 使用 IndexedDb

默认 `WebDatabase` 使用本地存储保存数据库二进制文件；支持 IndexedDb 的浏览器可改用 IndexedDb，容量更大、无需二进制转字符串、性能更好。

替换代码：

```dart
WebDatabase.withStorage(await DriftWebStorage.indexedDbIfSupported(name))
```

Drift 会自动从本地存储迁移数据到 IndexedDb。

---

## 使用网页工作线程

可将数据库放到后台线程（Web Worker），Drift 支持**共享工作线程**，实现多标签查询流、数据更新无缝同步。

网页工作线程无法使用本地存储，必须使用 `DriftWebStorage.indexedDb`。

### 原生 Dart Web 工作线程示例

> 注意：本段为**旧版实验 API**，建议迁移至 `package:drift/wasm.dart`（内置工作线程支持）

web/worker.dart：

```dart
import 'dart:html';

import 'package:drift/drift.dart';
import 'package:drift/web.dart';
import 'package:drift/web/worker.dart';

void main() {
  // 加载 sql.js
  WorkerGlobalScope.instance.importScripts('sql-wasm.js');

  driftWorkerMain(() {
    return WebDatabase.withStorage(
      DriftWebStorage.indexedDb(
        'worker',
        migrateFromLocalStorage: false,
        inWebWorker: true,
      ),
    );
  });
}
```

应用端连接：

```dart
DatabaseConnection connectToWorker() {
  return DatabaseConnection.delayed(
    connectToDriftWorker(
      'worker.dart.js',
      mode: DriftWorkerMode.shared,
    ),
  );
}
```

官方仓库有完整示例。

### Flutter Web 工作线程配置

Flutter Web 不会自动编译 web 目录 Dart 文件，也不会使用 build_web_compilers 生成 JS，需要手动编译工作线程。

1. 添加依赖：

```yaml
dev_dependencies:
  build_web_compilers: ^3.2.1
```

2. build.yaml 配置：

```yaml
targets:
  $default:
    builders:
      build_web_compilers:entrypoint:
        generate_for:
          - web/**.dart
        options:
          compiler: dart2js
        dev_options:
          dart2js_args:
            - --no-minify
        release_options:
          dart2js_args:
            - -O4
```

3. 编译并复制文件：

```bash
# 调试版
dart run build_runner build --delete-conflicting-outputs -o web:build/web/
cp -f build/web/worker.dart.js web/worker.dart.js

# 发布版
dart run build_runner build --release --delete-conflicting-outputs -o web:build/web/
cp -f build/web/worker.dart.js web/worker.dart.min.js
```

4. Flutter 连接工作线程：

```dart
import 'dart:js_interop';

import 'package:drift/drift.dart';
import 'package:drift/remote.dart';
import 'package:drift/web.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart';

DatabaseConnection connectToWorker(String databaseName) {
  final worker = SharedWorker(
      (kReleaseMode ? 'worker.dart.min.js' : 'worker.dart.js').toJS,
      databaseName.toJS);

  return DatabaseConnection.delayed(
      connectToRemoteAndInitialize(worker.port.channel()));
}
```

将该连接传入数据库构造函数即可。
