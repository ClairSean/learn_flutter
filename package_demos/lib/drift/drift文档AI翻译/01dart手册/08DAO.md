# DAOs

通过数据访问对象（DAO）实现数据库代码的模块化

当你编写了大量查询语句时，将所有代码塞进同一个类中会变得难以维护。你可以将部分查询逻辑抽离到独立的类中，主数据库类可以直接调用这些类，从而解决这个问题。参考以下示例代码：

```dart
part 'todos_dao.g.dart';

// _TodosDaoMixin 会由 drift 自动生成，它包含了操作数据表所需的所有字段。
// 泛型 <AppDatabase> 用于标注使用该 DAO 的主数据库类
@DriftAccessor(tables: [TodoItems])
class TodosDao extends DatabaseAccessor<AppDatabase> with _$TodosDaoMixin {
  // 该构造函数是必需的，用于让主数据库创建此 DAO 的实例
  TodosDao(super.attachedDatabase);

  // 根据内容筛选待办事项，返回实时更新的数据流
  Stream<List<TodoItem>> findTodos(String? contentFilter) {
    final query = select(todoItems);
    // 如果传入了筛选条件，添加 where 筛选语句
    if (contentFilter case final filter?) {
      query.where((item) => item.content.contains(filter));
    }

    return query.watch();
  }
}
```

接下来，我们将主数据库类 `AppDatabase` 上的注解修改为：
`@DriftDatabase(tables: [TodoItems], daos: [TodosDao])`

重新执行代码生成后，drift 会自动生成一个名为 `todosDao` 的 getter 方法，你可以通过它直接访问该 DAO 的实例。
