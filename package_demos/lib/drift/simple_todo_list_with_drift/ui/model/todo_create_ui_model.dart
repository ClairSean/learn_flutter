//新增待办事项时service和repository通信的数据类
class TodoCreateUIModel {
  String title;
  String content;

  TodoCreateUIModel({required this.title, required this.content});
}
