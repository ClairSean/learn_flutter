import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';
import 'section_title.dart';
import 'info_card.dart';
import 'data_input_field.dart';
import 'action_buttons.dart';
import 'simple_message_overlay.dart';
import 'vip_switch.dart';
import 'country_list_card.dart';
import 'country_list_item.dart';
import 'add_country_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..init(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  final _usernameController = TextEditingController();
  final _fansAmountController = TextEditingController();
  final _accountWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<HomeViewModel>();
      _usernameController.text = viewModel.inputUsername;
      _fansAmountController.text = viewModel.inputFansAmount;
      _accountWeightController.text = viewModel.inputAccountWeight;

      // 显示初始消息
      if (viewModel.shouldShowMessage) {
        SimpleMessageOverlay.show(context, viewModel.message);
        viewModel.clearMessage();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 不在这里监听，避免循环调用
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fansAmountController.dispose();
    _accountWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    // 同步 ViewModel 数据到输入框
    _syncController(_usernameController, viewModel.inputUsername);
    _syncController(_fansAmountController, viewModel.inputFansAmount);
    _syncController(_accountWeightController, viewModel.inputAccountWeight);

    // 监听消息变化并显示
    if (viewModel.shouldShowMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          SimpleMessageOverlay.show(context, viewModel.message);
          viewModel.clearMessage();
        }
      });
    }

    return _buildScaffold(context, viewModel);
  }

  Widget _buildScaffold(BuildContext context, HomeViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharedPreferences 测试'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: viewModel.isLoading ? null : viewModel.refresh,
            tooltip: '刷新',
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ========== 用户名区域 ==========
                const SectionTitle(title: '用户名管理'),
                const SizedBox(height: 16),
                InfoCard(
                  icon: Icons.person,
                  title: '已保存的用户名',
                  content: viewModel.username.isEmpty
                      ? '未保存'
                      : viewModel.username,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                DataInputField(
                  controller: _usernameController,
                  labelText: '用户名',
                  hintText: '请输入用户名',
                  onChanged: viewModel.updateInputUsername,
                ),
                const SizedBox(height: 12),
                ActionButtons(
                  isLoading: viewModel.isLoading,
                  onSave: viewModel.saveUsername,
                  onCheck: viewModel.checkUsername,
                  onClear: viewModel.clearUsername,
                  saveColor: Colors.blue,
                ),

                const Divider(height: 32),
                const SizedBox(height: 16),

                // ========== 粉丝数区域 ==========
                const SectionTitle(title: '粉丝数管理'),
                const SizedBox(height: 16),
                InfoCard(
                  icon: Icons.trending_up,
                  title: '已保存的粉丝数',
                  content: viewModel.fansAmount < 0
                      ? '未保存'
                      : viewModel.fansAmount.toString(),
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                DataInputField(
                  controller: _fansAmountController,
                  labelText: '粉丝数',
                  hintText: '请输入粉丝数',
                  keyboardType: TextInputType.number,
                  onChanged: viewModel.updateInputFansAmount,
                ),
                const SizedBox(height: 12),
                ActionButtons(
                  isLoading: viewModel.isLoading,
                  onSave: viewModel.saveFansAmount,
                  onCheck: viewModel.checkFansAmount,
                  onClear: viewModel.clearFansAmount,
                  saveColor: Colors.green,
                ),

                const Divider(height: 32),
                const SizedBox(height: 16),

                // ========== 账号权重区域 ==========
                const SectionTitle(title: '账号权重管理'),
                const SizedBox(height: 16),
                InfoCard(
                  icon: Icons.scale,
                  title: '已保存的账号权重',
                  content: viewModel.accountWeight == null
                      ? '未保存'
                      : viewModel.accountWeight!.toStringAsFixed(2),
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                DataInputField(
                  controller: _accountWeightController,
                  labelText: '账号权重',
                  hintText: '请输入 0-1 之间的数字',
                  keyboardType: TextInputType.number,
                  onChanged: viewModel.updateInputAccountWeight,
                ),
                const SizedBox(height: 12),
                ActionButtons(
                  isLoading: viewModel.isLoading,
                  onSave: viewModel.saveAccountWeight,
                  onCheck: viewModel.checkAccountWeight,
                  onClear: viewModel.clearAccountWeight,
                  saveColor: Colors.orange,
                ),

                const SizedBox(height: 32),

                // ========== VIP 状态区域 ==========
                const SectionTitle(title: 'VIP 状态管理'),
                const SizedBox(height: 16),
                VipSwitch(
                  value: viewModel.inputIsVip,
                  onChanged: viewModel.updateInputIsVip,
                ),
                const SizedBox(height: 12),
                ActionButtons(
                  isLoading: viewModel.isLoading,
                  onSave: viewModel.saveIsVip,
                  onCheck: viewModel.checkIsVip,
                  onClear: viewModel.clearIsVip,
                  saveColor: Colors.amber,
                ),

                const Divider(height: 32),
                const SizedBox(height: 16),

                // ========== 国家列表区域 ==========
                const SectionTitle(title: '国家列表管理'),
                const SizedBox(height: 16),

                // 始终显示卡片
                CountryListCard(
                  countries: viewModel.countryList,
                  hasCountryList: viewModel.hasCountryList,
                  isExpanded: viewModel.isCountryListExpanded,
                  onTap: viewModel.toggleCountryListExpanded,
                ),

                // 展开时显示列表
                if (viewModel.isCountryListExpanded) ...[
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      // 显示所有国家项
                      ...List.generate(viewModel.inputCountryList.length, (
                        index,
                      ) {
                        final country = viewModel.inputCountryList[index];
                        // 使用内容作为 key，确保每个国家有独立的组件状态
                        final uniqueKey = ValueKey('country_${index}_$country');
                        return CountryListItem(
                          key: uniqueKey,
                          index: index,
                          value: country,
                          onChanged: (value) =>
                              viewModel.updateCountry(index, value),
                          onDelete: () => viewModel.removeCountry(index),
                          isFirst: index == 0,
                          isLast:
                              index == viewModel.inputCountryList.length - 1,
                        );
                      }),
                      // 添加按钮
                      AddCountryButton(onAdd: viewModel.addCountry),
                    ],
                  ),
                ],

                const SizedBox(height: 12),
                ActionButtons(
                  isLoading: viewModel.isLoading,
                  onSave: viewModel.saveCountryList,
                  onCheck: viewModel.checkCountryList,
                  onClear: viewModel.clearCountryList,
                  saveColor: Colors.purple,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),

          // 加载遮罩
          if (viewModel.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  /// 同步 Controller 数据（避免循环更新）
  void _syncController(TextEditingController controller, String value) {
    // 当 ViewModel 的值与输入框不一致时才同步
    if (controller.text != value) {
      controller.text = value;
    }
  }
}
