# 支持的SQLite扩展

## 在Drift文件中关于JSON1和FTS5扩展的支持说明

分析`.drift`文件时，代码生成器会识别数据库中可能启用的SQLite3扩展。但生成器无法获知你的应用所对接的SQLite3库版本，因此**默认采用悲观假设**：使用未启用任何扩展的旧版SQLite3。在绝大多数场景下，`sqlite3`包会将新版SQLite3与你的应用打包集成，且默认启用了JSON1和FTS5扩展。你可以通过配置**构建选项**告知生成器这一情况。

---

# JSON1

若要在Drift文件和编译查询中启用JSON1扩展，需修改构建选项，在`sqlite_module`配置项中添加`json1`。

该SQLite扩展无需创建专用数据表，可直接作用于所有文本类型列。启用扩展后，Drift文件和编译查询中即可使用全部JSON函数。

由于JSON扩展为可选功能，在Dart中使用需导入专用依赖：`package:drift/extensions/json1.dart`。以下是在Dart中使用JSON函数的示例代码：

```dart
import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';

class Contacts extends Table {
    IntColumn get id => integer().autoIncrement()();
    TextColumn get data => text()();
}

@DriftDatabase(tables: [Contacts])
class Database extends _$Database {
  // 为简洁起见，省略构造函数和schemaVersion

  Future<List<Contacts>> findContactsWithNumber(String number) {
    return (select(contacts)
      ..where((row) {
        // 假设电话号码存储在data列的json键中
        final phoneNumber = row.data.jsonExtract<String, StringType>('phone_number');
        return phoneNumber.equals(number);
      })
    ).get();
  }
}
```

你可以在 [sqlite.org](https://sqlite.org) 官网查阅JSON1扩展的完整文档。

---

# FTS5

FTS5扩展为SQLite数据表提供**全文检索**能力。若要在Drift文件和编译查询中启用FTS5扩展，需修改构建选项，在`sqlite_module`配置项中添加`fts5`。

与原生SQLite用法一致，你可以在Drift文件中通过`CREATE VIRTUAL TABLE`语句创建FTS5虚拟表：

```sql
CREATE VIRTUAL TABLE email USING fts5(sender, title, body);
```

对FTS5表的查询语法与原生SQLite完全兼容：

```sql
emailsWithFts5: SELECT * FROM email WHERE email MATCH 'fts5' ORDER BY rank;
```

FTS5内置的`bm25`、`highlight`（高亮）和`snippet`（片段提取）函数也可在自定义查询中使用。

**限制**：无法在Dart代码中声明FTS5表，也无法编写针对FTS5表的Dart查询。你可以在 [sqlite.org](https://sqlite.org) 官网查阅FTS5扩展的完整文档。

---

# Geopoly

Geopoly模块是R树扩展的替代接口，它采用**GeoJSON格式（RFC-7946标准）** 描述二维多边形。Geopoly内置了多种实用函数：可检测多边形的包含/重叠关系、计算多边形面积、对多边形进行线性变换、将多边形渲染为SVG格式，以及其他同类几何操作。

若要在Drift文件和编译查询中启用Geopoly扩展，需修改构建选项，在`sqlite_module`配置项中添加`geopoly`。

使用该扩展创建虚拟表的示例：

```sql
create virtual table geo using geopoly(geoID, a, b);
```

SQLite允许虚拟表的附加列（如上例中的`geoID`、`a`、`b`）使用任意数据类型，因此Drift会为这些列生成`DriftAny`类型，使用体验较差。为避免该问题，你可以显式为列指定数据类型：

```sql
create virtual table geo using geopoly (
    geoID INTEGER not null,
    a INTEGER,
    b
);
```

显式指定类型会为列添加类型提示，最终生成的Dart代码会更易用。

你可以在 [sqlite.org](https://sqlite.org) 官网查阅Geopoly扩展的完整文档。

---

### 总结

1. 核心用途：为Drift框架启用SQLite三大扩展（**JSON1** 处理JSON数据、**FTS5** 实现全文检索、**Geopoly** 处理二维几何图形）；
2. 启用方式：统一通过构建配置的 `sqlite_module` 字段声明扩展；
3. 使用限制：FTS5表仅能在Drift的SQL文件中定义，无法在Dart代码中声明；
4. 优化技巧：Geopoly虚拟表建议显式指定列类型，避免生成不便捷的 `DriftAny` 类型。
