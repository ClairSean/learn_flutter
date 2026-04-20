import 'package:flutter/foundation.dart';
import '../../../data/repositories/shared_repository.dart';

/// ViewModel：负责业务逻辑和状态管理
class HomeViewModel extends ChangeNotifier {
  final SharedRepository _repository = SharedRepository();

  // ========== 状态数据 ==========

  String _username = '';
  String _inputUsername = '';
  int _fansAmount = 0;
  String _inputFansAmount = '';
  double? _accountWeight;
  String _inputAccountWeight = '';
  String _message = '';
  bool _shouldShowMessage = false;
  bool _isLoading = false;
  bool _isVip = false;
  bool _inputIsVip = false;
  List<String> _countryList = [];
  List<String> _inputCountryList = [];
  bool _isCountryListExpanded = false;

  // ========== Getter ==========

  String get username => _username;
  String get inputUsername => _inputUsername;
  int get fansAmount => _fansAmount;
  String get inputFansAmount => _inputFansAmount;
  double? get accountWeight => _accountWeight;
  String get inputAccountWeight => _inputAccountWeight;
  String get message => _message;
  bool get shouldShowMessage => _shouldShowMessage;
  bool get isLoading => _isLoading;
  bool get isVip => _isVip;
  bool get inputIsVip => _inputIsVip;
  List<String> get countryList => _countryList;
  List<String> get inputCountryList => _inputCountryList;
  bool get isCountryListExpanded => _isCountryListExpanded;
  bool _hasCountryList = false;
  bool get hasCountryList => _hasCountryList;

  // ========== 初始化 ==========

  Future<void> init() async {
    await _loadData();
  }

  // ========== 加载数据 ==========

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 加载用户名
      final username = await _repository.getUsername();
      if (username != null) {
        _username = username;
        _inputUsername = username;
      }

      // 加载粉丝数
      final fansAmount = await _repository.getFansAmountOrDefault();
      _fansAmount = fansAmount;
      _inputFansAmount = fansAmount.toString();

      // 加载账号权重
      final accountWeight = await _repository.getAccountWeight();
      if (accountWeight != null) {
        _accountWeight = accountWeight;
        _inputAccountWeight = accountWeight.toString();
      }

      // 加载 VIP 状态
      _isVip = await _repository.getIsVip();
      _inputIsVip = _isVip;

      // 加载国家列表（创建独立副本，避免引用问题）
      final countryListFromRepo = await _repository.getCountryList();
      _countryList = List.from(countryListFromRepo);
      _inputCountryList = List.from(countryListFromRepo);
      _hasCountryList = await _repository.hasCountryList();

      _message = '数据加载成功';
      _shouldShowMessage = true;
    } catch (e) {
      _message = '加载数据失败：$e';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ========== 用户名操作 ==========

  /// 保存用户名
  Future<void> saveUsername() async {
    if (_inputUsername.trim().isEmpty) {
      _message = '用户名不能为空';
      _shouldShowMessage = true;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.saveUsername(_inputUsername.trim());
      _username = _inputUsername.trim();
      _message = '用户名保存成功：$_username';
      _shouldShowMessage = true;
    } catch (e) {
      _message = '保存失败：$e';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 检查用户名
  Future<void> checkUsername() async {
    if (_inputUsername.trim().isEmpty) {
      _message = '请输入要检查的用户名';
      _shouldShowMessage = true;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final isMatch = await _repository.checkUsername(_inputUsername.trim());
      if (isMatch) {
        _message = '✓ 用户名匹配';
        _shouldShowMessage = true;
      } else {
        final hasUsername = await _repository.hasUsername();
        if (hasUsername) {
          _message = '✗ 用户名不匹配（已保存：$_username）';
          _shouldShowMessage = true;
        } else {
          _message = '✗ 未保存过用户名';
          _shouldShowMessage = true;
        }
      }
    } catch (e) {
      _message = '检查失败：$e';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 清除用户名
  Future<void> clearUsername() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.clearUsername(); // ✅ 清除设备存储中的数据
      _username = '';
      _inputUsername = ''; // ✅ 清除输入状态
      _message = '用户名已清除';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 更新输入的用户名（由 View 层调用）
  void updateInputUsername(String value) {
    _inputUsername = value;
    notifyListeners();
  }

  // ========== 粉丝数操作 ==========

  /// 保存粉丝数
  Future<void> saveFansAmount() async {
    if (_inputFansAmount.trim().isEmpty) {
      _message = '粉丝数不能为空';
      _shouldShowMessage = true;
      notifyListeners();
      return;
    }

    final fansAmount = int.tryParse(_inputFansAmount.trim());
    if (fansAmount == null) {
      _message = '请输入有效的数字';
      _shouldShowMessage = true;
      notifyListeners();
      return;
    }

    if (fansAmount < 0) {
      _message = '粉丝数不能为负数';
      _shouldShowMessage = true;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.saveFansAmount(fansAmount);
      _fansAmount = fansAmount;
      _message = '粉丝数保存成功：$_fansAmount';
      _shouldShowMessage = true;
    } catch (e) {
      _message = '保存失败：$e';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 检查粉丝数
  Future<void> checkFansAmount() async {
    if (_inputFansAmount.trim().isEmpty) {
      _message = '请输入要检查的粉丝数';
      _shouldShowMessage = true;
      notifyListeners();
      return;
    }

    final inputFansAmount = int.tryParse(_inputFansAmount.trim());
    if (inputFansAmount == null) {
      _message = '请输入有效的数字';
      _shouldShowMessage = true;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final isMatch = await _repository.checkFansAmount(inputFansAmount);
      if (isMatch) {
        _message = '✓ 粉丝数匹配';
        _shouldShowMessage = true;
      } else {
        final hasFansAmount = await _repository.hasFansAmount();
        if (hasFansAmount) {
          _message = '✗ 粉丝数不匹配（已保存：$_fansAmount）';
          _shouldShowMessage = true;
        } else {
          _message = '✗ 未保存过粉丝数';
          _shouldShowMessage = true;
        }
      }
    } catch (e) {
      _message = '检查失败：$e';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 清除粉丝数
  Future<void> clearFansAmount() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.clearFansAmount(); // ✅ 清除设备存储中的数据
      _fansAmount = -1;
      _inputFansAmount = ''; // ✅ 清除输入状态
      _message = '粉丝数已清除';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 更新输入的粉丝数（由 View 层调用）
  void updateInputFansAmount(String value) {
    _inputFansAmount = value;
    notifyListeners();
  }

  // ========== 账号权重操作 ==========

  /// 保存账号权重
  Future<void> saveAccountWeight() async {
    if (_inputAccountWeight.trim().isEmpty) {
      _message = '账号权重不能为空';
      _shouldShowMessage = true;
      notifyListeners();
      return;
    }

    final weight = double.tryParse(_inputAccountWeight.trim());
    if (weight == null) {
      _message = '请输入有效的数字';
      _shouldShowMessage = true;
      notifyListeners();
      return;
    }

    if (weight < 0.0 || weight > 1.0) {
      _message = '账号权重必须在 0-1 之间';
      _shouldShowMessage = true;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.saveAccountWeight(weight);
      _accountWeight = weight;
      _message = '账号权重保存成功：${weight.toStringAsFixed(2)}';
      _shouldShowMessage = true;
    } catch (e) {
      _message = '保存失败：$e';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 检查账号权重
  Future<void> checkAccountWeight() async {
    if (_inputAccountWeight.trim().isEmpty) {
      _message = '请输入要检查的账号权重';
      _shouldShowMessage = true;
      notifyListeners();
      return;
    }

    final inputWeight = double.tryParse(_inputAccountWeight.trim());
    if (inputWeight == null) {
      _message = '请输入有效的数字';
      _shouldShowMessage = true;
      notifyListeners();
      return;
    }

    if (inputWeight < 0.0 || inputWeight > 1.0) {
      _message = '账号权重必须在 0-1 之间';
      _shouldShowMessage = true;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final isMatch = await _repository.checkAccountWeight(inputWeight);
      if (isMatch) {
        _message = '✓ 账号权重匹配';
        _shouldShowMessage = true;
      } else {
        final hasAccountWeight = await _repository.hasAccountWeight();
        if (hasAccountWeight) {
          _message = '✗ 账号权重不匹配（已保存：${_accountWeight!.toStringAsFixed(2)}）';
          _shouldShowMessage = true;
        } else {
          _message = '✗ 未保存过账号权重';
          _shouldShowMessage = true;
        }
      }
    } catch (e) {
      _message = '检查失败：$e';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 清除账号权重
  Future<void> clearAccountWeight() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.clearAccountWeight(); // ✅ 清除设备存储中的数据
      _accountWeight = null;
      _inputAccountWeight = ''; // ✅ 清除输入状态
      _message = '账号权重已清除';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 更新输入的账号权重（由 View 层调用）
  void updateInputAccountWeight(String value) {
    _inputAccountWeight = value;
    notifyListeners();
  }

  // ========== VIP 状态操作 ==========

  /// 保存 VIP 状态
  Future<void> saveIsVip() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.saveIsVip(_inputIsVip);
      _isVip = _inputIsVip;
      _message = _isVip ? '已保存为 VIP 用户' : '已保存为非 VIP 用户';
      _shouldShowMessage = true;
    } catch (e) {
      _message = '保存失败：$e';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 检查 VIP 状态
  Future<void> checkIsVip() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isMatch = await _repository.checkIsVip(_inputIsVip);
      if (isMatch) {
        _message = '✓ VIP 状态匹配';
        _shouldShowMessage = true;
      } else {
        final hasIsVip = await _repository.hasIsVip();
        if (hasIsVip) {
          _message = '✗ VIP 状态不匹配（已保存：${_isVip ? "VIP" : "非 VIP"}）';
          _shouldShowMessage = true;
        } else {
          _message = '✗ 未保存过 VIP 状态';
          _shouldShowMessage = true;
        }
      }
    } catch (e) {
      _message = '检查失败：$e';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 清除 VIP 状态
  Future<void> clearIsVip() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.clearIsVip(); // ✅ 清除 SharedPreferences 中的数据
      _isVip = false;
      _inputIsVip = false;
      _message = 'VIP 状态已清除';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 更新输入的 VIP 状态（由 View 层调用）
  void updateInputIsVip(bool value) {
    _inputIsVip = value;
    notifyListeners();
  }

  // ========== 清除消息显示状态（供 View 层调用） ==========
  void clearMessage() {
    _shouldShowMessage = false;
    notifyListeners();
  }

  // ========== 国家列表操作 ==========

  /// 保存国家列表
  Future<void> saveCountryList() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 验证：检查是否有空字符串
      for (final country in _inputCountryList) {
        if (country.trim().isEmpty) {
          _isLoading = false;
          _message = '国家名称不能为空，请填写或删除空项';
          _shouldShowMessage = true;
          notifyListeners();
          return;
        }
      }

      await _repository.saveCountryList(_inputCountryList);
      _countryList = List.from(_inputCountryList);
      _hasCountryList = true;
      _message = '国家列表保存成功（${_countryList.length}个国家）';
      _shouldShowMessage = true;
    } catch (e) {
      _message = '保存失败：$e';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 检查国家列表
  Future<void> checkCountryList() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isMatch = await _repository.checkCountryList(_inputCountryList);
      if (isMatch) {
        _message = '✓ 国家列表匹配';
        _shouldShowMessage = true;
      } else {
        final hasList = await _repository.hasCountryList();
        if (hasList) {
          _message = '✗ 国家列表不匹配（已保存 ${_countryList.length} 个国家）';
          _shouldShowMessage = true;
        } else {
          _message = '✗ 未保存过国家列表';
          _shouldShowMessage = true;
        }
      }
    } catch (e) {
      _message = '检查失败：$e';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 清除国家列表
  Future<void> clearCountryList() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.clearCountryList();
      _countryList = [];
      _inputCountryList = [];
      _hasCountryList = false;
      _isCountryListExpanded = false;
      _message = '国家列表已清除';
      _shouldShowMessage = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 切换展开/收起状态
  void toggleCountryListExpanded() {
    _isCountryListExpanded = !_isCountryListExpanded;
    notifyListeners();
  }

  /// 添加国家
  void addCountry() {
    _inputCountryList.add('');
    notifyListeners();
  }

  /// 更新国家
  void updateCountry(int index, String value) {
    if (index >= 0 && index < _inputCountryList.length) {
      _inputCountryList[index] = value;
      notifyListeners();
    }
  }

  /// 删除国家
  void removeCountry(int index) {
    if (index >= 0 && index < _inputCountryList.length) {
      _inputCountryList.removeAt(index);
      notifyListeners();
    }
  }

  // ========== 刷新数据 ==========

  Future<void> refresh() async {
    _message = '';
    await _loadData();
  }
}
