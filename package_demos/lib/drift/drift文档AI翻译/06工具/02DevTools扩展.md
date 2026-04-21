# DevTools 扩展

在 DevTools 调试工具中查看 Drift 数据库

DevTools 是 Flutter 团队维护的一套面向 Dart、Flutter 应用的**性能分析与调试工具集**。使用 Drift 时，你可以直接在 DevTools 内部查看 Drift 数据库内容！Drift 提供了数据库可视化查看、问题诊断能力，帮助你修复常见问题、调试异常的查询执行结果。

## 配置接入

DevTools 需要连接正在运行的 Dart / Flutter 应用。根据应用启动方式不同，打开 DevTools 的方式也不一样：

1. 使用 `flutter run` 启动应用时，控制台会打印一行提示：`Flutter DevTools 调试器与性能分析器可通过以下地址访问`，附带 DevTools 访问链接。
2. 使用 `dart run` 启动时，需要传入 `--observe` 参数，才会生成 DevTools 链接。
3. VSCode、IntelliJ、Android Studio 在应用启动后，也内置了打开 DevTools 的快捷入口。

Drift 内置了 DevTools 扩展，所有依赖 Drift 的应用都可以使用。**首次使用需要手动启用扩展**：
点击 DevTools 窗口顶部的扩展图标即可打开管理面板。

> 配图说明：DevTools 主窗口，窗口顶部栏高亮标注扩展按钮

在弹出的对话框中，开启 `package:drift` 扩展即可。

> 配图说明：Drift 扩展管理对话框，带有启用开关按钮

## 使用方法

启用扩展后，在 DevTools 中切换到 Drift 标签页即可使用。

> 配图说明：Drift DevTools 扩展界面，列表展示所有已打开数据库与数据表

扩展顶部面板会列出**当前所有处于打开状态的 Drift 数据库**，以及数据库类的定义文件位置。
在列表选中一个数据库后，你可以查看数据表结构、编辑修改表内数据。

该扩展底层基于 Koen Van Looveren 开发的 `drift_db_viewer` 包实现，但你**无需手动添加该依赖**，它仅在 DevTools 调试环境内部运行。

## 数据库结构校验

在测试数据库迁移时很容易出现一种问题：
Drift 新建数据库时通过 `CREATE TABLE` 生成的**预期标准表结构**，和你当前数据库的**实际现有结构**不完全一致。

这类结构不匹配，会导致查询、修改数据时出现难以定位排查的隐性 Bug。

在 DevTools 扩展中，你可以点击 **Validate schema（校验表结构）** 按钮，让 Drift 自动对比预期结构与实际数据库结构，快速预警潜在的结构异常问题。
