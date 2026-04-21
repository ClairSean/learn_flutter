# Drift 文件

全面了解 `.drift` 文件——一款用于以 SQL 定义数据库的强大工具

Drift 文件是一项全新功能，支持你使用 SQL 编写全部数据库代码。与普通数据库客户端接收的原生 SQL 字符串不同，Drift 文件中的所有代码都会经过框架内置的强大 SQL 分析器校验。这让你编写的 SQL 查询更安全：Drift 会在构建阶段发现代码错误，并为查询生成**类型安全**的 Dart API，无需手动解析查询结果。

---

## 快速上手

使用该功能，我们需要创建两个文件：`database.dart` 和 `tables.drift`。
Dart 文件仅包含数据库初始化的最小代码：

```dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'database.g.dart';

@DriftDatabase(include: {'tables.drift'})
class MyDb extends _$MyDb {
  // 本示例创建了一个简易的内存数据库（无持久化存储）
  // 如需持久化数据，请参考其他入门指南中的数据库配置
  MyDb() : super(NativeDatabase.memory());

  @override
  获得 schemaVersion => 1;
}
```

现在我们可以在 Drift 文件中声明数据表和查询语句：

```sql
CREATE TABLE todos (
    id INT NOT NULL PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    category INTEGER REFERENCES categories(id)
);

CREATE TABLE categories (
    id INT NOT NULL PRIMARY KEY AUTOINCREMENT,
    description TEXT NOT NULL
) AS Category; -- 表名后的 AS 语法用于指定生成的数据类名称

-- 你也可以在 Drift 文件中创建索引或触发器
CREATE INDEX categories_description ON categories(description);

-- 我们还可以在这里编写命名 SQL 查询：
createEntry: INSERT INTO todos (title, content) VALUES (:title, :content);
deleteById: DELETE FROM todos WHERE id = :id;
allTodos: SELECT * FROM todos;
```

执行命令运行构建器：

```bash
dart run build_runner build
```

Drift 会生成包含 `_$MyDb` 父类的 `database.g.dart` 文件。生成的核心内容如下：

1. **自动生成的数据类与伴随类**
   生成 `Todo` 和 `Category` 数据类，以及用于插入数据的伴随类。
   默认规则：Drift 会自动去除表名末尾的 `s` 作为类名。这也是我们为第二张表添加 `AS Category` 的原因——否则会生成错误的 `Categorie` 类名。

2. **查询方法**
   - `Future<int> createEntry(String title, String content)`：创建待办事项并返回其 ID
   - `Future<int> deleteById(int id)`：根据 ID 删除待办事项，返回受影响行数
   - `Selectable<AllTodosResult> allTodos()`：查询所有待办事项，支持 `get()` 和 `watch()`

3. **自定义查询结果类**
   对于不匹配单表的查询，Drift 会生成专用结果类（如示例中的 `AllTodosResult`）。

---

### 优化编辑器支持的注释语法

Drift 文件本质是 SQL，但导入语句、命名查询等语法会导致部分编辑器无法识别。
从 Drift 2.32 开始，你可以使用注释语法编写 Drift 文件：

```sql
-- import 'tables.drift';

-- 命名查询：
-- createEntry:
INSERT INTO todos (title, content) VALUES (:title, :content);

-- deleteById:
DELETE FROM todos WHERE id = :id;

-- allTodos:
SELECT * FROM todos;
```

将编辑器配置为将 `.drift` 文件识别为 SQL 文件，即可获得语法高亮和格式化支持。

---

## 变量

在命名查询中，你可以像原生 SQL 一样使用变量：

- 普通变量：`?`
- 索引变量：`?123`
- 命名变量：`:id`

**不支持** `@` 或 `$` 开头的变量。
分析器会根据上下文自动推断变量类型，并生成类型安全的 Dart 方法参数。

### 显式声明变量类型

当类型无法自动推断时，你可以手动指定：

```sql
-- 声明文本类型变量
myQuery(:variable AS TEXT): SELECT :variable;

-- 声明可空变量
myNullableQuery(:variable AS TEXT OR NULL): SELECT :variable;

-- 声明必传变量（需开启命名参数构建选项）
myRequiredQuery(REQUIRED :variable AS TEXT OR NULL): SELECT :variable;
```

---

## 数组参数

如需判断值是否在数组中，可使用 `IN ?` 语法（Drift 运行时会自动解析）：

```sql
entriesWithId: SELECT * FROM todos WHERE id IN ?;
```

Drift 会生成方法：`Selectable<Todo> entriesWithId(List<int> ids)`

### 限制条件

1. 不支持显式索引：`id IN ?2` 会被构建器拒绝
2. 变量后不支持显式索引：`id IN ? OR title = ?2` 会被拒绝

---

## 定义数据表

在 `.drift` 文件中，使用标准 `CREATE TABLE` 语句定义数据表。

### 支持的列类型

兼容 SQLite 原生类型，同时扩展了 Drift 专用类型：

| SQL 类型   | Dart 类型 | 存储格式             |
| ---------- | --------- | -------------------- |
| BOOLEAN    | bool      | 整数（0/1）          |
| DATETIME   | DateTime  | 时间戳/ISO 字符串    |
| INT64      | BigInt    | 整数（兼容 JS 大数） |
| ENUM()     | Dart 枚举 | 枚举索引（整数）     |
| ENUMNAME() | Dart 枚举 | 枚举名称（文本）     |

#### 枚举存储示例

Dart 枚举：

```dart
enum Status { none, running, stopped, paused }
```

Drift 文件：

```sql
import 'status.dart';

CREATE TABLE tasks (
  id INTEGER NOT NULL PRIMARY KEY,
  status ENUM(Status)
);
```

---

## Drift 专属语法

为适配 Dart API，Drift 在标准 SQL 基础上扩展了专用语法（执行时会自动剔除）：

1. **自定义行类**

   ```sql
   -- 指定生成的类名
   CREATE TABLE ... AS DesiredName;
   -- 使用自定义 Dart 类
   CREATE TABLE ... WITH CustomClass;
   ```

2. **列约束**
   - `MAPPED BY`：应用类型转换器
   - `JSON KEY`：指定 JSON 序列化键名
   - `AS getterName`：重写 Dart 中列的属性名

---

## 导入

在 Drift 文件顶部可使用导入语句：

```sql
import 'tables.drift'; -- 必须使用单引号
```

- 导入其他 Drift 文件：共享表和查询
- 导入 Dart 文件：使用 Dart 定义的数据表
- 导入具有**传递性**，无导出机制

---

## 嵌套结果

使用 `表名.**` 语法，将关联表的查询结果嵌套为对象，避免字段冲突：

```sql
-- 普通查询（会生成 id1, lat1 等无意义字段）
SELECT r.id, r.name, f.*, t.* FROM saved_routes r
  INNER JOIN coordinates f ON f.id = r."from"
  INNER JOIN coordinates t ON t.id = r."to";

-- 嵌套结果（生成清晰的 Dart 对象）
routesWithNestedPoints: SELECT r.id, r.name, f.** AS "from", t.** AS "to" FROM saved_routes r
  INNER JOIN coordinates f ON f.id = r."from"
  INNER JOIN coordinates t ON t.id = r."to";
```

生成的 Dart 类：

```dart
class RoutesWithNestedPointsResult {
  final int id;
  final String name;
  final Point from;
  final Point to;
}
```

---

## LIST 子查询

Drift 1.4.0+ 支持 `LIST()` 语法，将子查询结果转为**列表**：

```sql
routeWithPoints: SELECT
    route.**,
    LIST(SELECT coordinates.* FROM route_points
      INNER JOIN coordinates ON id = point
      WHERE route = route.id
      ORDER BY index_on_route
    ) AS points
  FROM saved_routes route;
```

生成结果：包含 `SavedRoute` 对象和 `List<Point>` 列表。

---

## Dart 互操作

Drift 文件与 Dart API 完美兼容：

1. 可为 SQL 定义的表编写 Dart 查询
2. 可在 SQL 中使用 Dart 定义的表
3. 生成的查询方法支持事务、自动更新流

### Dart 模板（动态查询）

使用 `$变量` 实现运行时动态拼接 SQL：

```sql
filterTodos: SELECT * FROM todos WHERE $predicate;
```

生成的 Dart 方法支持动态传入查询条件：

```dart
Stream<List<Todo>> watchInCategory(int category) {
  return filterTodos((todos) => todos.category.equals(category)).watch();
}
```

---

## 类型转换器

在列上使用 `MAPPED BY` 应用 Dart 编写的类型转换器：

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  preferences TEXT MAPPED BY `const PreferenceConverter()`
);
```

---

## 自定义行类

使用 `WITH` 语法指定已有的 Dart 类作为行类：

```sql
import 'row_class.dart';

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name TEXT
) WITH User;
```

---

## Dart 文档注释

Drift 文件中列上方的注释，会自动生成为 Dart 类的文档注释：

```sql
CREATE TABLE friends (
  -- 发送好友请求的用户
  user_a INTEGER NOT NULL REFERENCES users(id),
  -- 接收请求的用户
  user_b INTEGER NOT NULL REFERENCES users(id),
  PRIMARY KEY (user_a, user_b)
);
```

---

## 自定义结果类名

为查询指定结果类名：

```sql
routesWithNestedPoints AS FullRoute: SELECT ...;
```

相同结果集的查询可共用一个结果类。

---

## 支持的语句

1. **导入语句**：`import 'file.drift'`
2. **数据定义语句**：`CREATE TABLE`/`VIEW`/`INDEX`/`TRIGGER`
3. **数据操作语句**：`INSERT`/`SELECT`/`UPDATE`/`DELETE`

---

## 规范

所有**导入语句**必须放在最前面，其次是数据定义语句，最后是命名查询。
如你需要更多语句支持，或认为 Drift 错误拒绝了合法查询，请提交 Issue。
