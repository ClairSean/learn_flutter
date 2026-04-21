import 'package:drift/drift.dart';

import '../database/database.dart';
import '../model/todo_create_domain_model.dart';
import '../model/todo_domain_model.dart';
import '../model/todo_update_domain_model.dart';

import 'package:package_demos/drift/simple_todo_list_with_drift/utils/list_extension.dart';

class TodoItemService {
  static final TodoItemService instance = TodoItemService._internal();
  TodoItemService._internal();

  void init(AppDatabase database) {
    _database = database;
  }

  late final AppDatabase _database;

  /// 查询所有待办事项
  Future<List<TodoDomainModel>> getAll() async {
    List<TodoItem> todoEntityList = await _database
        .select(_database.todoItems)
        .get();
    //将实体模型列表转换为领域模型列表
    return todoEntityList.toDomainList();
  }

  /// 根据传入的id删除行，返回删除的行数
  Future<int> deleteById(int id) async {
    return await (_database.delete(
      _database.todoItems,
    )..where((t) => t.id.equals(id))).go();
  }

  /// 根据传入的领域更新待办事项对象更新行
  Future<int> updateTodo(TodoUpdateDomainModel todoUpdateDomainModel) async {
    return await (_database.update(
      _database.todoItems,
    )..where((t) => t.id.equals(todoUpdateDomainModel.id))).write(
      TodoItemsCompanion(
        title: Value(todoUpdateDomainModel.title),
        content: Value(todoUpdateDomainModel.content),
        isCompleted: Value(todoUpdateDomainModel.isCompleted),
      ),
    );
  }

  /// 插入一条待办数据，返回ID，新增失败抛异常
  Future<int> createTodoItem(TodoCreateDomainModel todo) async {
    return await _database
        //创建插入语句，指定插入操作的表
        .into(_database.todoItems)
        //把实体创建行插入到表
        .insert(
          //创建实体行
          TodoItemsCompanion.insert(title: todo.title, content: todo.content),
        );
  }
}
