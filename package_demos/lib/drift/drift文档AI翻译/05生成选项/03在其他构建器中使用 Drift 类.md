# 在其他构建器中使用 Drift 类

配置你的构建流程，使其他构建器能够识别 Drift 生成的数据类。

你可以在其他构建器中使用 Drift 生成的类。由于 Dart 构建系统和 `source_gen` 库的技术限制，这种用法需要自定义构建配置。对于此类复杂的构建场景，我们推荐以**模块化模式**运行 Drift。该模式对大型构建项目效率更高，你可以在 `pubspec.yaml` 同级目录下创建 `build.yaml` 文件，写入以下配置启用该模式：

```yaml
targets:
  drift:
    auto_apply_builders: false
    builders:
      drift_dev:analyzer:
        enabled: true
        options: &options
          # Drift 构建选项，参考文档：
          # https://drift.simonbinder.eu/docs/advanced-features/builder_options/
          store_date_time_values_as_text: true
          named_parameters: true
          sql:
            dialect: sqlite
            options:
              version: "3.39"
              modules: [fts5]
      drift_dev:modular:
        enabled: true
        # 使用 YAML 锚点为两个构建器配置相同的选项
        options: *options

  $default:
    dependencies:
      # 优先运行 Drift 的构建器
      - ":drift"
    builders:
      # 该构建器默认启用，但我们已在独立目标中使用模块化构建器替代
      drift_dev:
        enabled: false
```

使用模块化生成模式后，你需要将数据库文件中的 `part` 语句替换为对 `文件名.drift.dart` 的导入。同时，你的数据库类将继承自 `$数据库名`（不再以**下划线**开头）。

通过生成独立的库文件，Drift 可以自主管理导入依赖。在 `build.yaml` 中声明依赖关系后，构建系统会确保：在 `built_value` 或其他需要读取 Drift 生成文件的构建器运行之前，Drift 的文件已生成完成。

完整的示例代码可在 Drift 的代码仓库中查看。

如果你在使用该方案时遇到任何问题，欢迎在 Drift 仓库提交 Issue。

---

## 技术原理解析

几乎所有代码生成包都使用 `source_gen` 提供的**共享部分文件**方案。这是一套通用协议，允许互不相关的构建器向同一个 `.g.dart` 文件中写入代码。为实现该功能，每个构建器会先生成以自身命名的 `.part` 文件。例如，若你在项目中同时使用 Drift 和 `built_value`，对应的部分文件会是 `.drift.part` 和 `.built_value.part`。随后，公共的 `source_gen` 包会将这些部分文件合并为最终的 `.g.dart` 文件。

该方案适用于绝大多数场景，但存在一个缺陷：**每个构建器都无法读取最终的 `.g.dart` 文件，也无法使用其中定义的类或方法**。为解决这个问题，Drift 提供了专用构建器——`drift_dev|not_shared` 和 `drift_dev|modular`，它们会生成仅包含 Drift 代码的独立文件。因此，核心解决方案就是：禁用 Drift 默认生成器，改用非共享生成器。

最后，我们需要让构建系统**优先运行 Drift**，再执行其他所有构建器。这也是我们将构建器拆分为多个目标的原因：第一个目标仅运行 Drift，第二个目标依赖于第一个目标，会执行其余所有构建器。

---

## 使用 `drift_dev:not_shared` 构建器

对于需要让其他构建器读取 Drift 代码的复杂构建场景，我们**推荐使用 `drift_dev:modular` 构建器**。但启用模块化构建器需要修改代码（例如将 `part` 语句替换为导入语句）。`drift_dev` 提供的 `not_shared` 构建器是更简便的替代方案。

它的用法与默认配置完全一致，唯一区别是：它会生成 `.drift.dart` 部分文件，而非共享的 `.g.dart` 文件——因此你仅需修改一行 `part` 语句即可完成迁移。

启用该构建器时，需同时开启 `drift_dev:analyzer` 构建器和 `has_separate_analyzer` 选项：

```yaml
targets:
  drift:
    auto_apply_builders: false
    builders:
      drift_dev:analyzer:
        enabled: true
        options: &options
          has_separate_analyzer: true # 使用 not_shared 时必须启用该选项
          # 其余构建选项...
      drift_dev:not_shared:
        enabled: true
        # 使用 YAML 锚点为两个构建器配置相同的选项
        options: *options

  $default:
    dependencies:
      # 优先运行 Drift 的构建器
      - ":drift"
    builders:
      # 该构建器默认启用，但我们已在独立目标中使用非共享构建器替代
      drift_dev:
        enabled: false
```

---

### 总结

1. **核心需求**：让其他构建器（如 built_value）识别 Drift 生成的类，需自定义构建配置；
2. **推荐方案**：模块化模式（`modular`），效率更高，适配大型项目，需修改 `part` 语句和继承类；
3. **简易方案**：`not_shared` 构建器，仅需修改一行代码，无需大幅调整业务代码；
4. **关键配置**：通过 `build.yaml` 拆分构建目标，确保 Drift 优先生成代码。
