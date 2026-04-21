import 'package:package_demos/drift/simple_todo_list_with_drift/data/database/database.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/data/model/todo_domain_model.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/ui/model/todo_ui_model.dart';

//Todo实体列表扩展类
extension TodoEntityListToDomain on List<TodoItem> {
  //Todo实体列表转换为Todo领域列表
  List<TodoDomainModel> toDomainList() {
    return map((e) => TodoDomainModel.fromEntity(e)).toList();
  }
}

//Todo领域列表扩展类
extension TodoDomainListToUI on List<TodoDomainModel> {
  //Todo领域列表转换为TodoUI列表
  List<TodoUIModel> toUIList() {
    return map((e) => TodoUIModel.fromEntity(e)).toList();
  }
}
