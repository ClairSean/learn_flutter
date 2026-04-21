import '../services/shared_service.dart';

/// 仓库层：连接 ViewModel 和 Service 层
class SharedRepository {
  final SharedService _service = SharedService();

  // ========== 用户名相关 ==========

  Future<void> saveUsername(String username) async {
    await _service.saveUsername(username);
  }

  Future<String?> getUsername() async {
    return await _service.getUsername();
  }

  Future<bool> checkUsername(String username) async {
    return await _service.checkUsername(username);
  }

  Future<bool> hasUsername() async {
    return await _service.hasUsername();
  }

  Future<void> clearUsername() async {
    await _service.clearUsername();
  }

  // ========== 粉丝数相关 ==========

  Future<void> saveFansAmount(int fansAmount) async {
    await _service.saveFansAmount(fansAmount);
  }

  Future<int?> getFansAmount() async {
    return await _service.getFansAmount();
  }

  Future<int> getFansAmountOrDefault() async {
    return await _service.getFansAmountOrDefault();
  }

  Future<bool> checkFansAmount(int fansAmount) async {
    return await _service.checkFansAmount(fansAmount);
  }

  Future<bool> hasFansAmount() async {
    return await _service.hasFansAmount();
  }

  Future<void> clearFansAmount() async {
    await _service.clearFansAmount();
  }

  // ========== 账号权重相关 ==========

  Future<void> saveAccountWeight(double weight) async {
    await _service.saveAccountWeight(weight);
  }

  Future<double?> getAccountWeight() async {
    return await _service.getAccountWeight();
  }

  Future<double> getAccountWeightOrDefault() async {
    return await _service.getAccountWeightOrDefault();
  }

  Future<bool> checkAccountWeight(double weight) async {
    return await _service.checkAccountWeight(weight);
  }

  Future<bool> hasAccountWeight() async {
    return await _service.hasAccountWeight();
  }

  Future<void> clearAccountWeight() async {
    await _service.clearAccountWeight();
  }

  // ========== VIP 状态相关 ==========

  Future<void> saveIsVip(bool isVip) async {
    await _service.saveIsVip(isVip);
  }

  Future<bool> getIsVip() async {
    return await _service.getIsVip();
  }

  Future<bool> checkIsVip(bool isVip) async {
    return await _service.checkIsVip(isVip);
  }

  Future<bool> hasIsVip() async {
    return await _service.hasIsVip();
  }

  Future<void> clearIsVip() async {
    await _service.clearIsVip();
  }

  // ========== 国家列表相关 ==========

  Future<void> saveCountryList(List<String> countries) async {
    await _service.saveCountryList(countries);
  }

  Future<List<String>> getCountryList() async {
    final list = await _service.getCountryList();
    // 创建独立副本，确保不会意外修改
    return List.from(list);
  }

  Future<bool> checkCountryList(List<String> countries) async {
    return await _service.checkCountryList(countries);
  }

  Future<bool> hasCountryList() async {
    return await _service.hasCountryList();
  }

  Future<void> clearCountryList() async {
    await _service.clearCountryList();
  }
}
