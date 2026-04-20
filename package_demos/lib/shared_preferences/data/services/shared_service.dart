import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SharedService {
  final _prefs = SharedPreferencesAsync();

  //========== 用户名相关 ==========

  /// 保存用户名
  Future<void> saveUsername(String username) async {
    await _prefs.setString('username', username);
  }

  /// 获取用户名
  /// 返回值：用户名，如果未保存返回 null
  Future<String?> getUsername() async {
    return await _prefs.getString('username');
  }

  /// 检查用户名是否匹配
  /// 返回值：是否匹配（未保存也返回 false）
  Future<bool> checkUsername(String username) async {
    final storedUsername = await _prefs.getString('username');
    return storedUsername == username;
  }

  /// 检查是否已保存用户名
  Future<bool> hasUsername() async {
    final username = await _prefs.getString('username');
    return username != null && username.isNotEmpty;
  }

  /// 清除用户名
  Future<void> clearUsername() async {
    await _prefs.remove('username');
  }

  //========== 粉丝数相关 ==========

  /// 保存粉丝数
  Future<void> saveFansAmount(int fansAmount) async {
    if (fansAmount < 0) {
      debugPrint('粉丝数不能为负数：$fansAmount');
      return;
    }
    await _prefs.setInt('fans_amount', fansAmount);
  }

  /// 获取粉丝数
  /// 返回值：粉丝数，如果未保存返回 null
  Future<int?> getFansAmount() async {
    return await _prefs.getInt('fans_amount');
  }

  /// 获取粉丝数（带默认值）
  /// 返回值：粉丝数，如果未保存返回 0
  Future<int> getFansAmountOrDefault() async {
    return await _prefs.getInt('fans_amount') ?? 0;
  }

  /// 检查粉丝数是否匹配
  /// 返回值：是否匹配（未保存也返回 false）
  Future<bool> checkFansAmount(int fansAmount) async {
    final storedFansAmount = await _prefs.getInt('fans_amount');
    return storedFansAmount == fansAmount;
  }

  /// 检查是否已保存粉丝数
  Future<bool> hasFansAmount() async {
    final fansAmount = await _prefs.getInt('fans_amount');
    return fansAmount != null;
  }

  /// 清除粉丝数
  Future<void> clearFansAmount() async {
    await _prefs.remove('fans_amount');
  }

  //========== 账号权重相关 ==========

  /// 保存账号权重
  /// 如果权重不在 0-1 之间，会打印错误日志并直接返回
  Future<void> saveAccountWeight(double weight) async {
    if (weight < 0.0 || weight > 1.0) {
      debugPrint('账号权重必须在 0-1 之间：$weight');
      return;
    }
    await _prefs.setDouble('account_weight', weight);
  }

  /// 获取账号权重
  /// 返回值：账号权重，如果未保存返回 null
  Future<double?> getAccountWeight() async {
    return await _prefs.getDouble('account_weight');
  }

  /// 获取账号权重（带默认值）
  /// 返回值：账号权重，如果未保存返回 0.5
  Future<double> getAccountWeightOrDefault() async {
    return await _prefs.getDouble('account_weight') ?? 0.5;
  }

  /// 检查账号权重是否匹配
  /// 返回值：是否匹配（未保存也返回 false）
  Future<bool> checkAccountWeight(double weight) async {
    final storedWeight = await _prefs.getDouble('account_weight');
    return storedWeight == weight;
  }

  /// 检查是否已保存账号权重
  Future<bool> hasAccountWeight() async {
    final weight = await _prefs.getDouble('account_weight');
    return weight != null;
  }

  /// 清除账号权重
  Future<void> clearAccountWeight() async {
    await _prefs.remove('account_weight');
  }

  //========== VIP 状态相关 ==========

  /// 保存 VIP 状态
  Future<void> saveIsVip(bool isVip) async {
    await _prefs.setBool('is_vip', isVip);
  }

  /// 获取 VIP 状态
  /// 返回值：VIP 状态，如果未保存返回 false
  Future<bool> getIsVip() async {
    return await _prefs.getBool('is_vip') ?? false;
  }

  /// 检查 VIP 状态是否匹配
  /// 返回值：是否匹配（未保存也返回 false）
  Future<bool> checkIsVip(bool isVip) async {
    final storedIsVip = await _prefs.getBool('is_vip');
    return storedIsVip == isVip;
  }

  /// 检查是否已保存 VIP 状态
  Future<bool> hasIsVip() async {
    final isVip = await _prefs.getBool('is_vip');
    return isVip != null;
  }

  /// 清除 VIP 状态
  Future<void> clearIsVip() async {
    await _prefs.remove('is_vip');
  }

  //========== 国家列表相关 ==========

  /// 保存国家列表
  Future<void> saveCountryList(List<String> countries) async {
    await _prefs.setStringList('country_list', countries);
  }

  /// 获取国家列表
  /// 返回值：国家列表，如果未保存返回空列表
  Future<List<String>> getCountryList() async {
    final list = await _prefs.getStringList('country_list');
    // 创建独立副本，避免引用问题
    return list != null ? List.from(list) : [];
  }

  /// 检查国家列表是否匹配
  /// 返回值：是否匹配（未保存也返回 false）
  Future<bool> checkCountryList(List<String> countries) async {
    if ((await hasCountryList()) == false) return false;
    final storedList = await _prefs.getStringList('country_list');
    if (storedList == null) return false;
    // 创建副本，避免引用问题
    final storedListCopy = List.from(storedList);
    if (storedListCopy.length != countries.length) return false;
    for (int i = 0; i < countries.length; i++) {
      if (storedListCopy[i] != countries[i]) return false;
    }
    return true;
  }

  /// 检查是否已保存国家列表
  Future<bool> hasCountryList() async {
    final list = await _prefs.getStringList('country_list');
    // 不需要返回 list，只检查是否为 null
    return list != null;
  }

  /// 清除国家列表
  Future<void> clearCountryList() async {
    await _prefs.remove('country_list');
  }
}
