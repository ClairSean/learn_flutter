# 查询（Selects）

在 Dart 中从数据表中查询数据行或单独字段

本文档介绍如何使用 Drift 的 Dart API 编写 `SELECT` 查询语句。为了让示例更易理解，所有示例均基于待办事项应用的两张核心数据表：

```dart
class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  TextColumn get content => text().named('body')();
  IntColumn get category => integer().nullable().references(Categories, #id)();
}

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}
```

在数据库类的 `@DriftDatabase` 注解中声明的每一张表，Drift 都会自动生成对应的表属性，你可以通过该属性执行查询语句：

```dart
@DriftDatabase(tables: [TodoItems, Categories])
class MyDatabase extends _$MyDatabase {
  // 上一章节的 schemaVersion getter 和构造函数已省略

  // 加载所有待办事项
  Future<List<TodoItem>> get allTodoItems => select(todoItems).get();

  // 监听指定分类下的所有待办事项。当底层数据发生变化时，流会自动发出新数据
  Stream<List<TodoItem>> watchEntriesInCategory(Category c) {
    return (select(todoItems)..where((t) => t.category.equals(c.id))).watch();
  }
}
```

Drift 让查询编写变得简单且安全。本文档不仅会讲解基础查询的编写，还会介绍如何使用**连接查询**和**子查询**实现高级查询。

---

## 基础查询

你可以通过 `select(表名)` 创建查询语句，其中表名是 Drift 自动生成的对应属性。数据库中的每一张表都会生成匹配的属性用于执行查询。
所有查询都可以通过 `get()` 执行一次，或通过 `watch()` 转为**自动更新的数据流**。

### 筛选（Where）

通过调用 `where()` 方法为查询添加筛选条件。
`where` 方法接收一个函数，该函数将数据表映射为**布尔类型表达式**。
创建表达式的常用方式是调用字段的 `equals` 方法；整型字段还支持 `isBiggerThan`（大于）和 `isSmallerThan`（小于）比较。
你可以通过 `a & b`（与）、`a | b`（或）、`a.not()`（非）组合表达式。关于表达式的更多细节，参考对应指南。

### 限制条数（Limit）

通过调用 `limit` 方法限制查询返回的结果数量。该方法接收要返回的行数，以及可选的偏移量。

```dart
Future<List<TodoItem>> limitTodos(int limit, {int? offset}) {
  return (select(todoItems)..limit(limit, offset: offset)).get();
}
```

### 排序（Ordering）

在查询语句上调用 `orderBy` 方法实现排序。该方法接收一个函数列表，用于从表中提取排序规则。
你可以使用任意表达式作为排序条件，更多细节参考对应指南。

```dart
Future<List<TodoItem>> sortEntriesAlphabetically() {
  return (select(
    todoItems,
  )..orderBy([(t) => OrderingTerm(expression: t.title)])).get();
}
```

将 `OrderingTerm` 的 `mode` 属性设置为 `OrderingMode.desc`，即可实现**倒序排序**。

### 单条数据查询

如果你确定查询最多返回一行数据，将结果包装在 `List` 中会显得繁琐。
Drift 提供 `getSingle` 和 `watchSingle` 方法简化操作：

```dart
Stream<TodoItem> entryById(int id) {
  return (select(todoItems)..where((t) => t.id.equals(id))).watchSingle();
}
```

如果存在匹配 ID 的数据，会将其发送到流中；否则流会发出 `null`。
如果 `watchSingle` 对应的查询返回了多条数据（本示例中不可能发生），流会发出错误信息。

### 结果映射（Mapping）

在调用 `watch`、`get`（或单条数据查询方法）之前，你可以使用 `map` 转换查询结果。

```dart
Stream<List<String>> contentWithLongTitles() {
  final query = select(todoItems)
    ..where((t) => t.title.length.isBiggerOrEqualValue(16));

  return query.map((row) => row.content).watch();
}
```

### 灵活选择异步/流式查询

如果你希望查询既可以作为 `Future`（一次性执行），也可以作为 `Stream`（实时监听）使用，可以通过 Drift 提供的 `Selectable` 抽象基类定义返回值：

```dart
// 提供 get 和 watch 方法
MultiSelectable<TodoItem> pageOfTodos(int page, {int pageSize = 10}) {
  return select(todoItems)..limit(pageSize, offset: page);
}

// 提供 getSingle 和 watchSingle 方法
SingleSelectable<TodoItem> selectableEntryById(int id) {
  return select(todoItems)..where((t) => t.id.equals(id));
}

// 提供 getSingleOrNull 和 watchSingleOrNull 方法
SingleOrNullSelectable<TodoItem> entryFromExternalLink(int id) {
  return select(todoItems)..where((t) => t.id.equals(id));
}
```

这些基类**不包含查询构建和映射方法**，用于告知调用者：查询已构建完成，可直接获取结果。

---

## 连接查询（Joins）

Drift 支持 SQL 连接查询，可同时操作多张数据表。
使用该功能时，先用 `select(table)` 创建基础查询，再通过 `.join()` 添加连接列表。
**内连接**和**左外连接**需要指定 `ON` 关联条件。

```dart
// 定义数据类，同时承载待办事项和关联的分类
class EntryWithCategory {
  EntryWithCategory(this.entry, this.category);

  // 类由 Drift 自动生成，对应连接查询中的每张表
  final TodoItem entry;
  final Category? category;
}

// 在数据库类中，为每个待办事项加载关联分类
Stream<List<EntryWithCategory>> entriesWithCategory() {
  final query = select(todoItems).join([
    leftOuterJoin(categories, categories.id.equalsExp(todoItems.category)),
  ]);

  return query.watch().map((rows) {
    return rows.map((row) {
      return EntryWithCategory(
        row.readTable(todoItems),
        row.readTableOrNull(categories),
      );
    }).toList();
  });
}
```

当然，你也可以连接**多张数据表**：

```dart
/// 搜索与包含指定标题的待办事项同分类的其他待办事项
Future<List<TodoItem>> otherTodosInSameCategory(String titleQuery) async {
  // 由于同一张表需要使用两次（一次筛选标题，一次查找同分类事项）
  // 我们需要别名区分两张表，为其中一张表指定特殊名称
  final otherTodos = alias(todoItems, 'inCategory');

  final query = select(otherTodos).join([
    // 连接查询中，useColumns: false 表示不将连接表的字段加入结果集
    // 此处仅用于在 where 子句中关联表，无需查询其字段
    innerJoin(
      categories,
      categories.id.equalsExp(otherTodos.category),
      useColumns: false,
    ),
    innerJoin(
      todoItems,
      todoItems.category.equalsExp(categories.id),
      useColumns: false,
    ),
  ])..where(todoItems.title.contains(titleQuery));

  return query.map((row) => row.readTable(otherTodos)).get();
}
```

Drift 支持所有连接类型：`innerJoin`（内连接）、`leftOuterJoin`（左外连接）、`rightOuterJoin`（右外连接）、`fullOuterJoin`（全外连接）、`crossJoin`（交叉连接）。

---

## 解析查询结果

带连接的查询调用 `get()` 或 `watch()` 后，会返回 `Future` 或 `Stream` 包装的 `List<TypedResult>`。
每个 `TypedResult` 代表一行数据，可从中读取值：

- `rawData`：获取原始字段数据
- `readTable`：从表中读取自动生成的数据类

以上文的查询为例，我们通过以下方式读取待办事项和分类：

```dart
return query.watch().map((rows) {
  return rows.map((row) {
    return EntryWithCategory(
      row.readTable(todoItems),
      row.readTableOrNull(categories),
    );
  }).toList();
});
```

> **注意**：如果表不存在于当前行中，`readTable` 会抛出参数异常。
> 例如待办事项可能没有关联分类，因此我们使用 `row.readTableOrNull` 读取分类数据。

---

## 自定义字段查询

查询语句不仅限于查询表中的原始字段，你还可以在查询中添加复杂表达式。
数据库引擎会为结果集中的每一行计算这些表达式的值。

```dart
Future<List<(TodoItem, bool)>> loadEntries() {
  // 约定：内容中包含 "important" 的事项为重要事项
  final isImportant = todoItems.content.like('%important%');

  return select(todoItems).addColumns([isImportant]).map((row) {
    final entry = row.readTable(todoItems);
    final entryIsImportant = row.read(isImportant)!;

    return (entry, entryIsImportant);
  }).get();
}
```

注意：模糊匹配（`like`）**不会在 Dart 中执行**，而是交由数据库引擎高效计算。

---

## 表别名（Aliases）

某些场景下，一张表需要在查询中被多次引用。
例如导航系统中存储路线的示例：

```dart
class GeoPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get latitude => text()();
  TextColumn get longitude => text()();
}

class Routes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  // 存储起点和终点的地理坐标ID
  IntColumn get start => integer()();
  IntColumn get destination => integer()();
}
```

现在我们需要为每条路线同时加载**起点**和**终点**的坐标信息，这就需要对坐标表进行**两次连接查询**。
此时可以使用**表别名**区分同一张表的不同引用：

```dart
class RouteWithPoints {
  final Route route;
  final GeoPoint start;
  final GeoPoint destination;

  RouteWithPoints({
    required this.route,
    required this.start,
    required this.destination,
  });
}

// 在数据库类中
Future<List<RouteWithPoints>> loadRoutes() async {
  // 为坐标表创建别名，实现重复引用
  final start = alias(geoPoints, 's');
  final destination = alias(geoPoints, 'd');

  final rows = await select(routes).join([
    innerJoin(start, start.id.equalsExp(routes.start)),
    innerJoin(destination, destination.id.equalsExp(routes.destination)),
  ]).get();

  return rows.map((resultRow) {
    return RouteWithPoints(
      route: resultRow.readTable(routes),
      start: resultRow.readTable(start),
      destination: resultRow.readTable(destination),
    );
  }).toList();
}
```

Drift 最终生成的 SQL 语句如下：

```sql
SELECT
    routes.id, routes.name, routes.start, routes.destination,
    s.id, s.name, s.latitude, s.longitude,
    d.id, d.name, d.latitude, d.longitude
FROM routes
    INNER JOIN geo_points s ON s.id = routes.start
    INNER JOIN geo_points d ON d.id = routes.destination
```

# 连接查询的排序（ORDER BY）与筛选（WHERE）

与单表查询类似，`orderBy` 和 `where` 同样适用于连接查询。
我们扩展上文的初始示例，仅包含满足指定筛选条件的待办事项，并根据分类ID排序结果：

```dart
Stream<List<EntryWithCategory>> entriesWithCategory(String entryFilter) {
  final query = select(todos).join([
    leftOuterJoin(categories, categories.id.equalsExp(todos.category)),
  ]);
  query.where(todos.content.like(entryFilter));
  query.orderBy([OrderingTerm.asc(categories.id)]);
  // ...
}
```

由于连接查询会涉及多张表，`where` 和 `orderBy` 中的表**必须显式指定**（这与单表查询不同，单表查询的回调函数会默认传入对应表）。

---

# 分组查询（Group by）

有时你需要执行**数据聚合查询**，即从多行数据中整合出所需结果。常见场景包括：

- 每个分类下有多少条待办事项？
- 用户每月完成多少条事项？
- 待办事项的平均长度是多少？

这类查询的共同点是：需要将多行数据合并为一行结果。在 SQL 中，这可以通过**聚合函数**实现，Drift 内置了对聚合函数的支持。

> 补充信息：你可以参考[这里](https://www.w3schools.com/sql/sql_groupby.asp)的 SQL 分组查询教程。

我们可以使用 `count` 函数实现第一个需求（统计每个分类的事项数量）。
我们将查询所有分类，并关联每个分类下的待办事项。特别之处在于，我们在连接上设置了 `useColumns: false`，因为我们不关心待办事项的具体字段，只关心其数量。
默认情况下，如果待办事项出现在连接查询中，Drift 会尝试读取它的所有字段。

```dart
Future<void> countTodosInCategories() async {
  final amountOfTodos = todoItems.id.count();

  final query = select(categories).join([
    innerJoin(
      todoItems,
      todoItems.category.equalsExp(categories.id),
      useColumns: false,
    ),
  ]);
  query
    ..addColumns([amountOfTodos])
    ..groupBy([categories.id]);

  final result = await query.get();

  for (final row in result) {
    print(
      '分类 ${row.readTable(categories)} 中有 ${row.read(amountOfTodos)} 条待办事项',
    );
  }
}
```

若要查询待办事项的平均长度，我们使用 `avg` 函数。
本例中无需使用连接查询，因为所有数据都来自单表（待办事项表）。
但这里存在一个问题：在连接查询中，我们通过 `useColumns: false` 忽略单条事项的字段；而单表聚合查询没有这个参数可用。
针对这种场景，Drift 提供了专用方法 `selectOnly` 替代 `select`。
`selectOnly` 的含义是：**仅查询通过 `addColumns` 添加的自定义字段**。
常规的 `select` 会默认查询表的所有字段，这适用于大多数场景。

```dart
Stream<double> averageItemLength() {
  final avgLength = todoItems.content.length.avg();
  final query = selectOnly(todoItems)..addColumns([avgLength]);

  return query.map((row) => row.read(avgLength)!).watchSingle();
}
```

---

# 查询结果插入（Using selects as inserts）

在 SQL 中，`INSERT INTO SELECT` 语句可以高效地将查询结果批量插入数据表。
在 Drift 中，你可以通过 `insertFromSelect` 方法构建这类语句。

本示例展示：为所有未分配分类的待办事项，自动创建对应的新分类：

```dart
Future<void> createCategoryForUnassignedTodoEntries() async {
  final newDescription = Variable<String>('category for: ') + todoItems.title;
  final query = selectOnly(todoItems)
    ..where(todoItems.category.isNull())
    ..addColumns([newDescription]);

  await into(
    categories,
  ).insertFromSelect(query, columns: {categories.name: newDescription});
}
```

`insertFromSelect` 的第一个参数是作为数据源的查询语句；
第二个参数 `columns` 是一个映射关系：将**目标表的列**对应到**查询语句的列/表达式**。
示例中，`newDescription` 表达式作为查询字段添加到语句中，然后通过映射将新分类的 `description` 字段赋值为该表达式。

---

# 子查询（Subqueries）

从 Drift 2.11 版本开始，你可以使用 `Subquery` 将已有的查询语句作为复杂连接查询的一部分。

以下代码使用子查询，统计**标题长度前10的待办事项**中，每个分类的数量：
首先创建查询语句获取前10条最长事项（不立即执行），然后将该子查询连接到按分类分组的主查询中。

```dart
Future<List<(Category, int)>> amountOfLengthyTodoItemsPerCategory() async {
  final longestTodos = Subquery(
    select(todoItems)
      ..orderBy([(row) => OrderingTerm.desc(row.title.length)])
      ..limit(10),
    's',
  );

  // 主查询中，我们需要统计每个分类在 longestTodos 中的事项数量
  // 无法直接访问 todos.title，因为主查询的数据源不是 todos 表
  // 我们使用 Subquery.ref 读取子查询中的列
  final itemCount = longestTodos.ref(todoItems.title).count();
  final query =
      select(categories).join([
          innerJoin(
            longestTodos,
            // 再次使用 .ref() 访问子查询中的分类字段
            longestTodos.ref(todoItems.category).equalsExp(categories.id),
            useColumns: false,
          ),
        ])
        ..addColumns([itemCount])
        ..groupBy([categories.id]);

  final rows = await query.get();

  return [
    for (final row in rows) (row.readTable(categories), row.read(itemCount)!),
  ];
}
```

**任意查询语句都可以作为子查询**。
但需要注意：与子查询表达式不同，完整的子查询**不能使用外层查询中的表**。

# JSON 支持

sqlite3 对 JSON 操作符提供了完善的支持，该功能在 Drift 中同样可用（需额外导入 `package:drift/extensions/json1.dart`）。
当你需要存储**最适合用 JSON 表示的动态结构**，或需要兼容已有的 JSON 结构（例如从文档型数据库迁移而来）时，JSON 支持会非常实用。

举个例子，假设一个通讯录应用最初使用 JSON 结构存储联系人数据：

```dart
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ContactData {
  final String name;
  final List<String> phoneNumbers;

  ContactData(this.name, this.phoneNumbers);

  factory ContactData.fromJson(Map<String, Object?> json) =>
      _$ContactDataFromJson(json);

  Map<String, Object?> toJson() => _$ContactDataToJson(this);
}
```

为了方便地将该联系人对象存储到 Drift 数据库中，我们可以使用 **JSON 列** + **类型转换器**：

```dart
class _ContactsConverter extends TypeConverter<ContactData, String> {
  @override
  ContactData fromSql(String fromDb) {
    return ContactData.fromJson(json.decode(fromDb) as Map<String, Object?>);
  }

  @override
  String toSql(ContactData value) {
    return json.encode(value.toJson());
  }
}

class Contacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get data => text().map(_ContactsConverter())();

  // 生成列：从 JSON 中实时提取 name 字段
  TextColumn get name => text().generatedAs(data.jsonExtract(r'$.name'))();
}
```

注意这里的 `name` 列：它通过 `generatedAs` 结合 `jsonExtract` 函数，**从 JSON 值中实时提取名称字段**。
JSON 路径参数的完整语法可在 sqlite3 官方文档中查看。

---

我们再增加一个复杂场景：新增一张表存储通话记录：

```dart
class Calls extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get incoming => boolean()();
  TextColumn get phoneNumber => text()();
  DateTimeColumn get callTime => dateTime()();
}
```

假设我们需要为每一通通话匹配对应的联系人（如果存在匹配的手机号）。
在 SQL 中实现该需求，需要将每行联系人数据展开为多个手机号行。
幸运的是，sqlite3 的 `json_each` 函数可以实现这个功能，并且 Drift 已经封装了该 API：

```dart
Future<List<(Call, Contact)>> callsWithContact() async {
  // 从联系人的 JSON 数据中遍历所有手机号
  final phoneNumbersForContact = contacts.data.jsonEach(
    this,
    r'$.phoneNumbers',
  );
  final phoneNumberQuery = selectOnly(phoneNumbersForContact)
    ..addColumns([phoneNumbersForContact.value]);

  // 连接查询：匹配通话记录与联系人手机号
  final query = select(calls).join([
    innerJoin(contacts, calls.phoneNumber.isInQuery(phoneNumberQuery)),
  ]);

  return query
      .map((row) => (row.readTable(calls), row.readTable(contacts)))
      .get();
}
```

---

# 无表查询

有些查询完全不需要 `FROM` 子句，仅直接查询一些表达式结果。
典型场景：使用子查询表达式判断表中是否存在任意数据：

```dart
Future<bool> hasTodoItem() async {
  final todoItemExists = existsQuery(select(todoItems));
  final row = await selectExpressions([todoItemExists]).getSingle();
  return row.read(todoItemExists)!;
}
```

`selectExpressions` API 与 `selectOnly` 类似，**唯一区别是它完全不需要依赖任何数据表**。
传递给该方法的表达式会在独立查询中执行，结果可通过返回的 `TypedResult` 类读取。

---

# 复合查询

通过复合查询，你可以**一次性返回多个查询语句的结果**。
Drift 支持对查询结果进行集合操作，操作符包括：

- `UNION ALL` / `UNION`：合并两个查询的结果，前者保留重复数据，后者自动去重
- `EXCEPT`：返回仅在第一个查询中出现、且未在第二个查询中出现的所有行
- `INTERSECT`：返回两个查询共同返回的所有行

---

### 示例

沿用之前的待办事项表和分类表，假设你需要查询：

1. 每个分类下的待办事项数量
2. **未分类**的待办事项数量

第一个查询可以通过对分类表分组 + 子查询计数实现。但分组查询**不会自动生成空分类行**，因此我们可以编写第二个查询，并使用 `unionAll` 合并结果：

```dart
Future<List<(String?, int)>> todoItemsInCategory() async {
  // 子查询：统计每个分类下的事项数量
  final countWithCategory = subqueryExpression<int>(
    selectOnly(todoItems)
      ..addColumns([countAll()])
      ..where(todoItems.category.equalsExp(categories.id)),
  );

  // 子查询：统计未分类的事项数量
  final countWithoutCategory = subqueryExpression<int>(
    selectOnly(todoItems)
      ..addColumns([countAll()])
      ..where(todoItems.category.isNull()),
  );

  // 主查询：分组统计所有分类
  final query = db.selectOnly(categories)
    ..addColumns([categories.name, countWithoutCategory])
    ..groupBy([categories.id]);

  // 合并：添加未分类的统计行
  query.unionAll(
    db.selectExpressions([
      const Constant<String>(null),
      countWithoutCategory,
    ]),
  );

  return query
      .map((row) => (row.read(categories.name), row.read(countWithCategory)!))
      .get();
}
```

该查询会为每个分类返回一行数据（统计对应事项数），同时额外返回一行**无分类**的统计数据。

---

### 复合查询规则

1. 所有参与合并的查询**必须返回兼容的行结构**（列数量、类型完全一致），因为最终会合并为一个结果集
2. 可以为复合查询添加 `LIMIT` 和 `ORDER BY`，但**仅能作用于第一个查询**（即调用 `union`/`unionAll`/`except`/`intersect` 的查询）
