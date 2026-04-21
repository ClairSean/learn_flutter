import 'package:package_demos/drift/simple_todo_list_with_drift/data/model/todo_domain_model.dart';

///待办事项全量领域模型
class TodoUIModel {
  ///ID
  final int id;

  ///标题
  final String title;

  ///内容
  final String content;

  ///完成状态
  final bool isCompleted;

  ///创建时间
  final DateTime createdAt;

  TodoUIModel({
    required this.id,
    required this.title,
    required this.content,
    required this.isCompleted,
    required this.createdAt,
  });

  //从实体模型到本领域模型
  TodoUIModel.fromEntity(TodoDomainModel todoItem)
    : id = todoItem.id,
      title = todoItem.title,
      content = todoItem.content,
      isCompleted = todoItem.isCompleted,
      createdAt = todoItem.createdAt;
}
