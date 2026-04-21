import 'package:drift/drift.dart';

///定义待办事项数据表
class TodoItems extends Table {
  ///ID：唯一自增整数主键，drift把integer().autoIncrement()()的id自动作为主键看待
  IntColumn get id => integer().autoIncrement()();

  ///标题：长度1-32的文本
  TextColumn get title => text().withLength(min: 1, max: 32)();

  ///内容：非空文本，可为空字符串，最大长度1000
  TextColumn get content => text().withLength(max: 1000)();

  ///完成状态：完成状态（布尔值，默认 false）
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  ///创建时间：自动生成
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
