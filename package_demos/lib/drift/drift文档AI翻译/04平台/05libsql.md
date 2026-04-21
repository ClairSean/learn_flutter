# 远程 sqld 与 Turso

在 Drift 中使用 sqld 数据库服务器

libSQL 是 SQLite 的一个分支，它支持在服务器上托管**兼容 SQLite 格式与语法**的数据库。libSQL 还提供了同步机制：可以在本地打开云端中央数据库，之后将本地的修改上传同步。

通过 `drift_libsql` 和 `drift_hrana` 两个扩展包，我们提供了两种将 Drift 与 libSQL 及 libSQL 服务器集成的方案。
`drift_libsql` 支持与本地数据库副本完成**全量数据同步**；而 `drift_hrana` 用于直接连接 libSQL 服务器（例如 Turso 提供的数据库服务）。

---

## drift_libsql

libSQL 库可以连接到 libSQL 服务器，同时维护一个与服务器保持同步的**本地数据库副本**。
得益于 Andika Tanuwijaya 开发的 `libsql_dart` 和 `drift_libsql` 扩展包，Drift 数据库也可以使用这一能力。

```dart
import 'package:drift/drift.dart';
import 'package:drift_libsql/drift_libsql.dart';

@DriftDatabase(...)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}

void main() async {
  final database = AppDatabase(DriftLibsqlDatabase(
    // 本地副本数据库文件路径
    "${dir.path}/replica.db",
    // 服务器同步地址
    syncUrl: 'hrana url',
    // 身份认证令牌
    authToken: 'your-token',
    // 开启本地写入即时可见
    readYourWrites: true,
    // 同步间隔时间（秒）
    syncIntervalSeconds: 3,
  ));
}
```

---

## drift_hrana

借助 `drift_hrana` 扩展包（名称源自 libSQL 使用的 Hrana 通信协议），Drift 可以直接连接托管版 libSQL 服务器。
所有查询都会直接在服务器上执行，与连接 Postgres、MariaDB 等传统数据库服务器的方式一致。**该模式不包含本地缓存和数据同步功能**。

获取服务器连接地址后，将 `HranaDatabase` 作为参数传入数据库构造函数即可使用：

```dart
import 'package:drift/drift.dart';
import 'package:drift_hrana/drift_hrana.dart';

@DriftDatabase(...)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}

void main() async {
  final database = AppDatabase(HranaDatabase(
    // 服务器连接地址
    Uri.parse('ws://localhost:8080/'),
    // JWT 认证令牌（无则为null）
    jwtToken: null,
  ));
}
```

该方式会让 Drift 通过 **WebSocket** 连接服务器并执行数据库操作。
注意：**流式查询无法在连接同一数据库的不同客户端之间同步**，因为当前 sqld 暂不支持该能力。

---

`drift_hrana` 不属于 Drift 核心项目，而是在独立仓库中维护。
如果你有新功能建议，或在使用中遇到问题，请在该仓库提交 Issue。与 Drift 核心库一样，我们非常欢迎社区贡献代码！
