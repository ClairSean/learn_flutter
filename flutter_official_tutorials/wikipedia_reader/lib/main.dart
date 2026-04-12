import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'summary.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ArticleViewModel(ArticleModel());
    return MaterialApp(home: ArticleView());
  }
}

//view层，展示数据
class ArticleView extends StatelessWidget {
  ArticleView({super.key});

  final viewModel = ArticleViewModel(ArticleModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wikipedia FLutter')),
      //使用监听组件监听viewmodel
      body: ListenableBuilder(
        listenable: viewModel,
        //用回调函数构建，更灵活
        builder: (context, child) {
          //根据viewModel内容显示不同元素
          return switch ((
            viewModel.loading,
            viewModel.summary,
            viewModel.errorMessage,
          )) {
            (true, _, _) => Center(child: CircularProgressIndicator()),
            (false, _, String message) => Center(child: Text(message)),
            (false, null, null) => Center(
              child: Text('An unknown error has occurred'),
            ),
            (false, Summary summary, null) => ArticlePage(
              summary: summary,
              nextArticleCallback: viewModel.getRandomArticleSummary,
            ),
          };
        },
      ),
      // ,
    );
  }
}

//文章页组件
class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    required this.summary,
    required this.nextArticleCallback,
  });

  final Summary summary;
  //表示无参空返回回调函数
  final VoidCallback nextArticleCallback;

  @override
  Widget build(BuildContext context) {
    //可滚动的列布局
    return SingleChildScrollView(
      child: Column(
        //包含文章和按钮
        children: [
          ArticleWidget(summary: summary),
          ElevatedButton(
            onPressed: nextArticleCallback,
            child: Text('Next random article'),
          ),
        ],
      ),
    );
  }
}

//文章组件
class ArticleWidget extends StatelessWidget {
  const ArticleWidget({super.key, required this.summary});

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        //列中元素的间距
        spacing: 10.0,
        children: [
          //条件渲染
          if (summary.hasImage) Image.network(summary.originalImage!.source),
          Text(
            summary.titles.normalized,
            //越界处理
            overflow: TextOverflow.ellipsis,
            //主题系统
            style: TextTheme.of(context).displaySmall,
          ),
          if (summary.description != null)
            Text(
              summary.description!,
              overflow: TextOverflow.ellipsis,
              style: TextTheme.of(context).bodySmall,
            ),
          Text(summary.extract),
        ],
      ),
    );
  }
}

//vm层，管理数据
class ArticleViewModel extends ChangeNotifier {
  final ArticleModel model;
  //view感兴趣的三个属性
  Summary? summary;
  String? errorMessage;
  bool loading = false;

  ArticleViewModel(this.model) {
    //初始化时自动获取随机文章简介,因为构造方法不能异步，所以必须包装一层方法
    getRandomArticleSummary();
  }

  //获取随机文章简介
  Future<void> getRandomArticleSummary() async {
    loading = true;
    notifyListeners();
    //获取数据的逻辑
    try {
      summary = await model.getRandomArticleSummary();
      print('Article loaded: ${summary!.titles.normalized}'); // Temporary
      errorMessage = null;
    } on HttpException catch (e) {
      print('Error loading article: ${e.message}'); // Temporary
      errorMessage = e.message;
      summary = null;
    }
    loading = false;
    notifyListeners();
  }
}

//数据模型
class ArticleModel {
  //获取随机文章简介
  Future<Summary> getRandomArticleSummary() async {
    //进行http请求
    final uri = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/random/summary',
    );
    final response = await get(uri);
    //检查返回状态
    if (response.statusCode != 200) {
      throw HttpException('Failed to update resource');
    }
    //
    return Summary.fromJson(jsonDecode(response.body));
  }
}
