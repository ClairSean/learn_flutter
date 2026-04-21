# PostgreSQL 支持

将 Drift 与 PostgreSQL 数据库服务器结合使用。

尽管 Drift 最初是作为 SQLite 数据库的客户端封装库设计的，但它也可以与 PostgreSQL 数据库服务器配合使用。无需修改你的查询代码，Drift 就能为绝大多数查询生成兼容 Postgres 的 SQL 语句。请注意，部分 Drift API（例如日期时间修改相关接口）**仅支持 SQLite**，但大多数查询无需任何修改即可正常运行。

---

## 配置

首先，将 `drift` 和 `drift_postgres` 添加到你的 `pubspec.yaml` 文件中：

```yaml
dependencies:
  drift: ^2.32.1
  drift_postgres: ^1.3.1

dev_dependencies:
  drift_dev: ^2.32.1
  build_runner: ^2.13.1
```

使用 Postgres 定义数据库与定义 SQLite 数据库**没有区别**——Dart 和 SQL 相关文档页面会介绍如何定义能被 Drift 识别的数据表。

在部分场景下，不同的 SQL 方言需要修改生成的代码。由于大多数 Drift 用户面向的是 SQLite，Drift 默认会生成针对 SQLite 优化的代码。若要同时启用 PostgreSQL 的代码生成功能，请在 `pubspec.yaml` 同级目录下创建 `build.yaml` 文件，内容如下：

```yaml
targets:
  $default:
    builders:
      drift_dev:
        options:
          sql:
            dialects:
              - sqlite # 仅需要 postgres 时可删除此行
              - postgres
```

下面这个数据库示例可以作为你的入门参考：

```dart
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart';

part 'postgres.g.dart';

class Users extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  TextColumn get name => text()();
  Column<PgDate> get birthDate => customType(PgTypes.date).nullable()();
}

@DriftDatabase(tables: [Users])
class MyDatabase extends _$MyDatabase {
  MyDatabase(super.e);

  @override
  int get schemaVersion => 1;
}

void main() async {
  final pgDatabase = PgDatabase(
    endpoint: Endpoint(
      host: 'localhost',
      database: 'postgres',
      username: 'postgres',
      password: 'postgres',
    ),
    settings: ConnectionSettings(
      // 若你需要通过公网连接 Postgres 数据库
      // 请使用 SslMode.verifyFull
      sslMode: SslMode.disable,
    ),
  );

  final driftDatabase = MyDatabase(pgDatabase);

  // 插入新用户
  await driftDatabase.users.insertOne(UsersCompanion.insert(name: 'Simon'));

  // 打印所有用户
  print(await driftDatabase.users.all().get());

  await driftDatabase.close();
}
```

启动数据库服务器后（例如执行命令 `docker run -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres`），你可以运行该示例，查看 Drift 与 Postgres 的交互效果。

---

## 自定义连接与连接池

无参数的 `PgDatabase` 构造函数与 `postgres` 包中 `Endpoint` 类的配置参数保持一致，它会通过该类建立与 PostgreSQL 的连接。在某些场景下（例如你已存在可用的 Postgres 连接，或需要自定义不同于默认 `Endpoint` 的配置），可以使用 `PgDatabase.opened` 搭配 `postgres` 包中已有的 `Session` 对象。

该方法也适用于 Postgres 连接池，因为 `postgres` 包中的 `Pool` 实现了 `Session` 接口：

```dart
Future<void> openWithPool() async {
  final pool = Pool.withEndpoints(yourListOfEndpoints);

  final driftDatabase = MyDatabase(PgDatabase.opened(pool));
  await driftDatabase.users.select().get();

  // 注意：关闭 Drift 数据库时，PgDatabase.opened() 不会关闭底层连接
  await driftDatabase.close();
  await pool.close();
}
```

---

## API 扩展

`postgres` 库提供了一些自定义类型，让你在 Drift 中编写查询时可以使用 PostgreSQL 专属类型。例如，示例中使用的 `PgTypes.uuid` 会映射为 Postgres 原生的 UUID 列类型，Postgres 中的 `gen_random_uuid()` 函数也已对外暴露。

PostgreSQL 提供了极为丰富的函数集，但目前仅有少量函数在 `drift_postgres` 包中导出。你可以通过 `FunctionCallExpression` 调用其他函数——如果你实现了扩展，非常欢迎为 `drift_postgres` 贡献代码！

---

## 避免使用 SQLite 专属的 Drift API

早期版本的 Drift 仅针对 SQLite 设计，对 PostgreSQL 及其他数据库的支持是在后续版本中新增的，这也导致部分 Drift API 是 SQLite 专属的。在未来的重大版本中，这些接口会被迁移到独立的库中以避免混淆，但目前你需要了解这些限制。本节列出了受影响的 API 及其在 PostgreSQL 中的替代方案。

### 数据库迁移

`Migrator` API 的大部分功能都是 SQLite 专属的。你虽然可以在 PostgreSQL 中创建表，但 `alterTable` 等方法**仅支持 SQLite**。尽管可以在 PostgreSQL 中使用 Drift 迁移，但目前**推荐的方案**是：导出 Drift 模式，然后使用 PostgreSQL 专用的迁移工具。

在 SQLite 中，当前模式版本存储在数据库文件内。为了让 Drift 的迁移 API 也能在 Postgres 上基于该机制工作，Drift 会创建一个 `__schema` 表来存储当前模式版本。

该迁移机制适用于简单部署场景，但不适用于连接到 Postgres 服务器的多应用服务器大型数据库架构。对于这类场景，成熟的迁移管理工具是更可靠的选择。如果你选择使用其他工具管理迁移，可以在 `PgDatabase` 构造函数中传入 `enableMigrations: false` 来禁用 Drift 的迁移功能。

### 日期时间列

Drift 的 `datetime()` 列是为 SQLite 设计的，而 SQLite 没有专用的日期时间类型。大多数日期时间 API（如 `currentDateAndTime`）**不支持 PostgreSQL**。在 PostgreSQL 中使用 Drift 数据库时，我们建议**避免使用默认的 `dateTime()` 列类型**，改用 `PgTypes.date` 或 `PgTypes.datetime`：

```dart
// 该表使用 Postgres 原生类型存储日期/时间值
class TimeStore extends Table {
  Column<PgDate> get date => customType(PgTypes.date)();
  Column<PgDateTime> get timestampWithTimezone =>
      customType(PgTypes.timestampWithTimezone)();
  Column<PgDateTime> get timestampWithoutTimezone =>
      customType(PgTypes.timestampNoTimezone)();
  Column<Interval> get interval => customType(PgTypes.interval)();
}
```

如果你需要**同时支持 SQLite 和 Postgres**，可以考虑使用方言感知类型：

```dart
class _DialectAwareDateTimeType implements DialectAwareSqlType<PgDateTime> {
  /// 用于 Postgres 数据库的底层类型
  static const _postgres = PgTypes.timestampWithTimezone;

  /// 非 Postgres 数据库的备用类型
  static const _other = DriftSqlType.dateTime;

  const _DialectAwareDateTimeType();

  @override
  String mapToSqlLiteral(GenerationContext context, PgDateTime dartValue) {
    return switch (context.dialect) {
      SqlDialect.postgres => _postgres.mapToSqlLiteral(dartValue),
      _ => context.typeMapping.mapToSqlLiteral(dartValue.dateTime),
    };
  }

  @Override
  Object mapToSqlParameter(GenerationContext context, PgDateTime dartValue) {
    return switch (context.dialect) {
      SqlDialect.postgres => _postgres.mapToSqlParameter(dartValue),
      _ => context.typeMapping.mapToSqlVariable(dartValue.dateTime)!,
    };
  }

  @Override
  PgDateTime read(SqlTypes typeSystem, Object fromSql) {
    return switch (typeSystem.dialect) {
      SqlDialect.postgres => _postgres.read(fromSql),
      _ => PgDateTime(typeSystem.read(_other, fromSql)!),
    };
  }

  @Override
  String sqlTypeName(GenerationContext context) {
    return switch (context.dialect) {
      SqlDialect.postgres => _postgres.sqlTypeName(context),
      _ => _other.sqlTypeName(context),
    };
  }
}

const dateTime = _DialectAwareDateTimeType();

class DialectAwareTime extends Table {
  // Postgres 中使用 timestamp with timezone 类型
  // SQLite 中回退到默认日期类型（整数或文本）
  Column<PgDateTime> get timeValue => customType(dateTime)();
}
```

---

## 当前状态

Drift 对 PostgreSQL 的支持是稳定的，当前 API 几乎不会发生破坏性变更。不过，这是一个较新的实现，PostgreSQL 的集成测试覆盖范围不如 SQLite 数据库全面。此外，Drift 为 SQLite 支持的大多数函数提供了类型安全封装，而 `drift_postgres` 仅暴露了 PostgreSQL 高级运算符和函数的一小部分。

如果你在使用 Postgres 数据库时遇到问题或漏洞，请通过提交 Issue 或发起讨论告知我们。我们也非常欢迎为 PostgreSQL 函数扩展封装的代码贡献。

---

### 总结

1. **核心能力**：Drift 无需修改代码即可兼容 PostgreSQL，支持原生类型、连接池、双数据库方言；
2. **配置关键**：需添加 `drift_postgres` 依赖，并在 `build.yaml` 启用 PostgreSQL 方言；
3. **注意事项**：迁移、日期时间接口为 SQLite 专属，Postgres 需使用专用类型和独立迁移工具；
4. **兼容性**：支持自定义连接/连接池，可通过方言感知类型实现 SQLite+Postgres 双兼容。
