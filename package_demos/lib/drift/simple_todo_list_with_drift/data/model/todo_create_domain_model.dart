//新增待办事项时service和repository通信的数据类
class TodoCreateDomainModel {
  String title;
  String content;

  TodoCreateDomainModel({required this.title, required this.content});
}
