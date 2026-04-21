import 'package:flutter/material.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/data/repository/todo_repository.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/ui/model/todo_create_ui_model.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/ui/model/todo_ui_model.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/ui/model/todo_update_ui_model.dart';

class HomeViewModel extends ChangeNotifier {
  final TodoRepository _repository = TodoRepository.instance;

  List<TodoUIModel> _todoList = [];
  List<TodoUIModel> get todoList => _todoList;

  List<TodoUIModel> get uncompletedTodos =>
      _todoList.where((todo) => !todo.isCompleted).toList();
  List<TodoUIModel> get completedTodos =>
      _todoList.where((todo) => todo.isCompleted).toList();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// 加载所有待办事项
  Future<void> loadTodos() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _todoList = await _repository.getAll();
    } catch (e) {
      _errorMessage = '加载失败：${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 创建新待办事项
  Future<void> createTodo(String title, String content) async {
    if (title.isEmpty) {
      _errorMessage = '标题不能为空';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _repository.createTodoItem(
        TodoCreateUIModel(title: title, content: content),
      );
      await loadTodos();
    } catch (e) {
      _errorMessage = '创建失败：${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 切换待办事项状态
  Future<void> toggleTodoStatus(TodoUIModel todo) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _repository.updateTodo(
        TodoUpdateUIModel(
          id: todo.id,
          title: todo.title,
          content: todo.content,
          isCompleted: !todo.isCompleted,
        ),
      );
      await loadTodos();
    } catch (e) {
      _errorMessage = '更新失败：${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 删除待办事项
  Future<void> deleteTodo(int id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _repository.deleteById(id);
      await loadTodos();
    } catch (e) {
      _errorMessage = '删除失败：${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 清除错误信息
  void clearErrorMessage() {
    _errorMessage = '';
    notifyListeners();
  }
}
