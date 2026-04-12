# Birdle

本项目是跟着 Flutter 官方教程 [Create an app](https://docs.flutter.cn/learn/pathway/tutorial/create-an-app) 完成的练习项目。

## 项目简介

Birdle 是一个类似 Wordle 的猜词游戏，玩家需要在有限的尝试次数内猜测一个5字母的单词。

## 游戏规则

1. 玩家需要在5次尝试内猜测一个5字母的单词
2. 每次猜测后，系统会给出反馈：
   - 🟢 绿色：字母正确且位置正确
   - 🟡 黄色：字母正确但位置错误
   - ⚪ 灰色：字母不存在于目标单词中
3. 输入5个字母后，点击提交按钮或按回车键进行猜测

## 运行项目

```bash
flutter pub get
flutter run
```

## 项目状态

⚠️ **本项目为学习练习项目，未来不再更新维护。**

## 参考资源

- [Flutter 官方教程 - Create an app](https://docs.flutter.cn/learn/pathway/tutorial/create-an-app)
