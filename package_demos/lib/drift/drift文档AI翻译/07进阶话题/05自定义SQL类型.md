# 自定义 SQL 类型

在 Drift 文件和 Dart 代码中使用自定义 SQL 类型

Drift 核心库以 **sqlite3** 为主要目标数据库，这体现在 Drift 开箱即用支持的 SQL 类型上——这些类型由 sqlite3 原生支持，并在 Dart 层做了少量扩展处理。

其他 Drift 有限支持的数据库通常提供更多类型。例如，PostgreSQL 拥有专有的时长类型、JSON 类型、UUID 类型等。在 sqlite3 数据库中，你需要使用**类型转换器**，借助 sqlite3 支持的基础类型存储这些值。
虽然类型转换器也能实现需求，但它会让 Drift 在底层使用普通文本列存储数据。例如，当数据库原生支持 UUID 类型时，使用类型转换器可能导致语句执行效率降低，或与其他操作同一数据库的应用产生兼容问题。

因此，Drift 支持使用**自定义类型**：这类类型不由 Drift 核心库定义，且并非适配所有数据库。

---

## 何时使用自定义类型（总结）

如果你需要为**新的数据库引擎**扩展 Drift 支持，且该数据库拥有 Drift 未覆盖的专属类型，自定义类型是最佳方案。

除非你正在为新数据库包扩展 Drift 功能（这非常棒，欢迎与我们沟通！），否则你通常无需自行实现自定义类型。像 `drift_postgres` 这类扩展包已经为你定义了所需的自定义类型。

---

## 定义类型

举个例子：假设我们使用的数据库通过 `interval` 类型**原生支持 Duration（时长）**值，且数据库驱动也原生支持 Duration 类型——这意味着时长可以直接传入预处理语句，也能直接从查询结果中读取，无需手动转换。

此时，我们可以为 Drift 实现一个支持 Duration 的自定义类型类：

```dart
import 'package:drift/drift.dart';

class DurationType implements CustomSqlType<Duration> {
  const DurationType();

  @override
  String mapToSqlLiteral(Duration dartValue) {
    // 将 Dart 时长转换为 SQL 字面量
    return "interval '${dartValue.inMicroseconds} microseconds'";
  }

  @override
  Object mapToSqlParameter(Duration dartValue) => dartValue;

  @override
  Duration read(Object fromSql) => fromSql as Duration;

  @override
  String sqlTypeName(GenerationContext context) => 'interval';
}
```

该自定义类型定义了核心转换逻辑：

1. **SQL 字面量转换**：当 Duration 值用于 SQL 常量时，格式化为 `interval '微秒数 microseconds'`；
2. **SQL 参数转换**：直接传递 Duration 对象（依赖数据库驱动原生支持）；
3. **结果读取**：直接将数据库返回值强转为 Duration 对象；
4. **表结构定义**：在 `CREATE TABLE` 语句中使用的类型名为 `interval`。

---

## 使用自定义类型

### 在 Dart 代码中

在 Dart 数据表定义中，使用 `customType` 列构建方法绑定自定义类型：

```dart
import 'package:drift/drift.dart';

// 上文定义的 PostgreSQL 专用时长类型
class DurationType implements CustomSqlType<Duration> {
  const DurationType();

  @override
  String mapToSqlLiteral(Duration dartValue) {
    return "interval '${dartValue.inMicroseconds} microseconds'";
  }

  @override
  Object mapToSqlParameter(Duration dartValue) => dartValue;

  @override
  Duration read(Object fromSql) => fromSql as Duration;

  @override
  String sqlTypeName(GenerationContext context) => 'interval';
}

// 兼容 sqlite3 的降级实现（用整数存储微秒数）
class _FallbackDurationType implements CustomSqlType<Duration> {
  const _FallbackDurationType();

  @override
  String mapToSqlLiteral(Duration dartValue) {
    return dartValue.inMicroseconds.toString();
  }

  @override
  Object mapToSqlParameter(Duration dartValue) {
    return dartValue.inMicroseconds;
  }

  @override
  Duration read(Object fromSql) {
    return Duration(microseconds: fromSql as int);
  }

  @override
  String sqlTypeName(GenerationContext context) {
    return 'integer';
  }
}

// 方言感知型自定义类型：自动适配不同数据库
const durationType = DialectAwareSqlType<Duration>.via(
  fallback: _FallbackDurationType(),
  overrides: {SqlDialect.postgres: DurationType()},
);
```

如示例所示，自定义列**仍支持** `clientDefault` 等列约束；如有需要，还可以结合自定义列与类型转换器使用。

基础配置足以支持大部分查询场景，但在高级用法中，你需要补充额外信息。例如，手动用自定义类型创建 `Variable` 或 `Constant` 时，必须将自定义类型作为构造函数的第二个参数传入。
原因：与内置类型不同，Drift 没有统一的注册中心来管理自定义类型的值处理逻辑。

### 在 SQL 文件中

在 Drift SQL 文件中，可以使用**内嵌 Dart 语法**定义自定义类型：

```sql
import 'type.dart';

CREATE TABLE periodic_reminders (
  id INTEGER NOT NULL PRIMARY KEY,
  frequency `const DurationType()` NOT NULL,
  reminder TEXT NOT NULL
);
```

注意：目前 Drift 文件对自定义类型的支持**有限**。例如，`CAST` 表达式暂不支持自定义类型。
如果你需要自定义类型的高级语法分析支持，请提交 Issue 或讨论，描述你的使用场景！

---

## 数据库方言适配

如果自定义类型仅被**部分数据库管理系统**支持，你的数据库将只能在对应系统上运行。
例如，使用上文 `DurationType` 的表无法在 sqlite3 中运行：sqlite3 会将 `interval` 识别为整数，且完全不支持 `interval xyz microseconds` 语法。

从 Drift 2.15 版本开始，支持定义**方言感知型自定义类型**：根据数据库方言执行不同的转换逻辑，可用于为其他数据库实现兼容适配。

首先，定义一个用整数存储时长的降级自定义类型（类似类型转换器）：

```dart
class _FallbackDurationType implements CustomSqlType<Duration> {
  const _FallbackDurationType();

  @override
  String mapToSqlLiteral(Duration dartValue) {
    return dartValue.inMicroseconds.toString();
  }

  @override
  Object mapToSqlParameter(Duration dartValue) {
    return dartValue.inMicroseconds;
  }

  @override
  Duration read(Object fromSql) {
    return Duration(microseconds: fromSql as int);
  }

  @override
  String sqlTypeName(GenerationContext context) {
    return 'integer';
  }
}

// 核心：方言适配类型
const durationType = DialectAwareSqlType<Duration>.via(
  fallback: _FallbackDurationType(), // 默认降级实现
  overrides: {SqlDialect.postgres: DurationType()}, // PostgreSQL 专用实现
);
```

使用 `DialectAwareSqlType` 后：

- PostgreSQL 数据库：自动使用高效的 `interval` 原生类型；
- sqlite3 等其他数据库：自动降级为整数类型存储时长。

在表中使用该方言适配类型：

```dart
Column<Duration> get frequency => customType(durationType)
    .clientDefault(() => Duration(minutes: 15))();
```
