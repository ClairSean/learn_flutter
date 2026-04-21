import 'package:flutter/material.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/data/database/database.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/data/service/todo_item_service.dart';

class AppInitializer {
  //用私有构造创建的全局单例
  static final AppInitializer instance = AppInitializer._internal();
  //私有构造用于创建全局单例
  AppInitializer._internal();

  late final AppDatabase _database;

  Future<void> init() async {
    //确保flutter底层已初始化完成
    WidgetsFlutterBinding.ensureInitialized();
    //打开本地SQLite数据库，建立连接，自动管理，无需手动关闭
    _database = AppDatabase();
    //其他初始化包代码...
    //依赖管理
    TodoItemService.instance.init(_database);
    return;
  }
}
