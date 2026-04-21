import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/todo_items.dart';

//用这个终端命令生成：dart run build_runner build --delete-conflicting-outputs
part 'database.g.dart';

//指定本数据库类管理的数据库表对象
@DriftDatabase(tables: [TodoItems])
///_$AppDatabase是自动生成的，包含所有增删改查的底层实现
class AppDatabase extends _$AppDatabase {
  ///构造函数：用于初始化数据库连接，可传入测试数据库
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  //表版本，每次修改表结构后手动+1
  @override
  int get schemaVersion => 3;

  static QueryExecutor _openConnection() {
    //flutter提供的drift连接数据库方法，返回数据库连接对象
    return driftDatabase(
      //本地sqlite文件（真正的底层数据库文件）的文件名
      name: 'simple_todo_list_database',
      //native是安卓ios的原生配置
      native: const DriftNativeOptions(
        //指定数据库文件存储目录
        // 默认情况下，drift_flutter 的 driftDatabase 会将数据库文件
        // 存储在 getApplicationSupportDirectory() 目录
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // 如需 Web 支持，请参考官方文档：https://drift.simonbinder.eu/platforms/web/
    );
  }
}
