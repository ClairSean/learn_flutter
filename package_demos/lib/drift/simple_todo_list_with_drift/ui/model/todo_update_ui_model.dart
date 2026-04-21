//更新领域模型
class TodoUpdateUIModel {
  ///ID
  final int id;

  ///标题
  final String title;

  ///内容
  final String content;

  ///完成状态
  final bool isCompleted;

  TodoUpdateUIModel({
    required this.id,
    required this.title,
    required this.content,
    required this.isCompleted,
  });
}
