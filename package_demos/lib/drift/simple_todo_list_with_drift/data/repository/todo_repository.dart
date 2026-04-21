import 'package:package_demos/drift/simple_todo_list_with_drift/data/model/todo_create_domain_model.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/data/model/todo_domain_model.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/data/model/todo_update_domain_model.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/ui/model/todo_create_ui_model.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/ui/model/todo_ui_model.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/ui/model/todo_update_ui_model.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/utils/list_extension.dart';

import '../service/todo_item_service.dart';

class TodoRepository {
  static TodoRepository instance = TodoRepository._internal();
  TodoRepository._internal();

  late final TodoItemService _service = TodoItemService.instance;

  /// 查询所有待办事项
  Future<List<TodoUIModel>> getAll() async {
    List<TodoDomainModel> list = await _service.getAll();
    return list.toUIList();
  }

  /// 根据传入的id删除行，返回删除的行数
  Future<int> deleteById(int id) async {
    return await _service.deleteById(id);
  }

  /// 根据传入的UI更新对象，更新待办事项
  Future updateTodo(TodoUpdateUIModel todo) async {
    return await _service.updateTodo(
      TodoUpdateDomainModel(
        id: todo.id,
        title: todo.title,
        content: todo.content,
        isCompleted: todo.isCompleted,
      ),
    );
  }

  /// 插入一条待办数据，返回ID，新增失败抛异常
  Future<int> createTodoItem(TodoCreateUIModel todo) async {
    return await _service.createTodoItem(
      TodoCreateDomainModel(title: todo.title, content: todo.content),
    );
  }
}
