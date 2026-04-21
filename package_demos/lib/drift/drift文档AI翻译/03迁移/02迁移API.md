# 迁移器 API

如何执行 `ALTER` 语句和复杂的表迁移

你可以在迁移回调中通过 `customStatement()` 手动编写迁移语句。此外，回调函数还会提供一个 `Migrator`（迁移器）实例作为参数。该类知晓数据库的目标结构，可用于创建、删除和修改结构中的大部分元素。

## 通用技巧

为确保迁移过程中数据库结构保持一致，你可以将迁移逻辑包裹在**事务块**中。但请注意，部分编译指令（包括外键约束）无法在事务内修改。不过，遵循以下操作会很有帮助：

1. 始终在 `beforeOpen` 中重新启用外键约束；
2. 在迁移前禁用外键约束；
3. 在事务内执行迁移逻辑；
4. 通过 `PRAGMA foreign_key_check` 验证迁移后是否存在结构不一致的问题。

结合以上所有操作，迁移回调的完整写法如下：

```dart
return MigrationStrategy(
  onUpgrade: (m, from, to) async {
    // 迁移前禁用外键约束
    await customStatement('PRAGMA foreign_keys = OFF');

    await transaction(() async {
      // 在此处编写你的迁移逻辑
    });

    // 调试模式下：验证迁移后的数据库结构合法性
    if (kDebugMode) {
      final wrongForeignKeys = await customSelect(
        'PRAGMA foreign_key_check',
      ).get();
      assert(
        wrongForeignKeys.isEmpty,
        '发现非法外键：${wrongForeignKeys.map((e) => e.data)}',
      );
    }
  },
  beforeOpen: (details) async {
    // 数据库打开前启用外键约束
    await customStatement('PRAGMA foreign_keys = ON');
    // ....
  },
);
```

---

## 迁移视图、触发器和索引

修改视图、触发器或索引的定义时，最简单的更新方式是**删除后重新创建**该元素。使用迁移器 API 仅需两步：先调用 `await drop(element)` 删除，再调用 `await create(element)` 创建（`element` 为待更新的触发器、视图或索引）。

注意：**即使不修改视图类本身**，Dart 定义的视图也可能发生结构变化。这是因为视图通过 getter 引用表的列，若在表定义中通过 `.named('name')` 重命名列，却未修改对应的 getter，Dart 中的视图定义不变，但底层的 `CREATE VIEW` 语句会发生变化。

解决该问题的最简方案是：在迁移中重新创建所有视图，迁移器提供了 `recreateAllViews` 方法实现此功能。

---

## 复杂迁移

SQLite 仅内置了简单修改的语句，例如添加列、删除整张表。更复杂的迁移需要遵循**12步标准流程**：创建表的副本，并从旧表复制数据。
Drift 2.4 版本引入了 **`TableMigration`（表迁移）API**，可自动完成大部分流程，让复杂迁移更简单、更安全。

执行表迁移时，Drift 会根据目标结构创建新表，然后从旧表复制数据。大多数场景下（例如修改列类型），无法直接无修改地复制每一行数据。此时你可以使用 **`columnTransformer`（列转换器）** 对每行数据进行转换。
`columnTransformer` 是一个**列→SQL表达式**的映射，用于定义从旧表复制列时的转换规则。
例如，若需要在复制前对列进行类型转换，可这样写：

```dart
columnTransformer: {
  todos.category: todos.category.cast<int>(),
}
```

底层实现中，Drift 会使用 `INSERT INTO SELECT` 语句复制旧数据。上述示例对应的原生 SQL 为：

```sql
INSERT INTO temporary_todos_copy SELECT id, title, content, CAST(category AS INT) FROM todos;
```

可见，Drift 会使用 `columnTransformer` 中的表达式转换对应列，未配置的列则直接原样复制。
若在表迁移中**新增列**，务必将其加入 `TableMigration` 的 `newColumns` 参数中。Drift 会确保这些新列要么设置了默认值，要么在 `columnTransformer` 中定义了转换规则；同时，Drift 不会尝试从旧表复制新列的数据。

无论你是使用 `TableMigration` 实现复杂迁移，还是手动执行一系列自定义语句，我们都**强烈建议编写集成测试**覆盖迁移逻辑，避免因迁移错误导致数据丢失。

以下示例展示了表迁移 API 的常用场景。这些示例依赖自动生成的分步迁移代码（推荐写法），但该 API 也可脱离分步迁移独立使用。

---

## 修改列的类型

假设 `Todos` 表中的 `category` 列原本是**非空文本类型**，现在需要修改为**可空整型**。为简化示例，我们假设该列原本存储的都是整数，仅需调整存储类型。

修改前的表结构：

```dart
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 10)();
  TextColumn get content => text().named('body')();
  TextColumn get category => text()();
}
```

修改后的表结构：

```dart
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 10)();
  TextColumn get content => text().named('body')();
  IntColumn get category => integer().nullable()();
}
```

重新构建代码并升级数据库版本后，编写迁移逻辑：

```dart
from1To2: (m, schema) async {
  await m.alterTable(
    TableMigration(
      schema.todos,
      columnTransformer: {
        todos.category: schema.todos.category.cast<int>(),
      },
    ),
  );
},
```

核心是 `columnTransformer`：它定义了列的转换规则。映射中的值指向**旧表**，因此我们可以用 `todos.category.cast<int>()` 转换旧数据的类型。未在转换器中声明的列，会直接从旧表原样复制。

---

## 修改列约束

若列约束的修改与现有数据兼容（例如将非空列改为可空列），直接复制数据即可，无需任何转换：

```dart
from1To2: (m, schema) async {
  await m.alterTable(TableMigration(schema.todos));
}
```

---

## 删除列

删除**未被外键引用**的列非常简单：

```dart
from1To2: (m, schema) async {
  await m.alterTable(TableMigration(schema.yourTable));
}
```

若要删除**被外键引用**的列，必须先迁移引用该列的关联表。

---

## 重命名列

在 Dart 中重命名列时，**最简单的兼容方案**是：仅修改 getter 名称，并使用 `named` 保留旧列名：

```dart
TextColumn get newName => text().named('old_name')();
```

这种方式完全兼容旧版本，**无需编写迁移脚本**。

若需要**修改数据库底层的列名**，可使用迁移器的 `renameColumn` API：

```dart
from1To2: (m, schema) async {
  await m.renameColumn(schema.yourTable, 'old_column_name', schema.yourTable.newColumn);
}
```

若需要彻底修改数据库中的列名，可通过 `columnTransformer` 映射旧列名：

```dart
from1To2: (m, schema) async {
  await m.alterTable(
    TableMigration(
      schema.yourTable,
      columnTransformer: {
        schema.yourTable.newColumn: const CustomExpression('old_column_name')
      },
    )
  );
}
```

---

## 合并列

若需要新增一列，其默认值由多个现有列计算得出，可通过表迁移 API 实现：

```dart
await m.alterTable(
  TableMigration(
    schema.yourTable,
    columnTransformer: {
      schema.yourTable.newColumn: Variable.withString('from previous row: ') +
          schema.yourTable.oldColumn1 +
          schema.yourTable.oldColumn2.upper()
    },
  )
)
```

---

## 新增列

新增列的最简方式是使用迁移器的 `addColumn` 方法：

```dart
from1To2: (m, schema) async {
  await m.addColumn(schema.users, schema.users.middleName);
}
```

但在部分场景下，该方法不适用。**若新增列满足以下所有条件**：

1. 非空列；
2. 无数据库默认值（`clientDefault` 不算数据库默认值）；
3. 非自增主键；

则无法安全添加到现有表中（数据库无法为旧行分配值）。
此时可使用 `alterTable` API，**仅为旧行指定默认值**（新插入的数据仍使用 `clientDefault` 或手动传值）：

```dart
await m.alterTable(
  TableMigration(
    schema.yourTable,
    columnTransformer: {
      schema.yourTable.yourNewColumn: Constant('旧行使用的默认值'),
    },
    newColumns: [schema.yourTable.yourNewColumn],
  )
)
```
