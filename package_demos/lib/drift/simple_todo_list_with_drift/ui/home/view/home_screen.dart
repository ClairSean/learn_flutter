import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/ui/home/viewmodel/home_viewmodel.dart';
import 'package:package_demos/drift/simple_todo_list_with_drift/ui/model/todo_ui_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..loadTodos(),
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late HomeViewModel _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = Provider.of<HomeViewModel>(context);
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('新增待办'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '标题',
                  hintText: '请输入待办标题',
                ),
                maxLength: 32,
              ),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: '内容',
                  hintText: '请输入待办内容（可选）',
                ),
                maxLength: 1000,
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _titleController.clear();
                _contentController.clear();
                Navigator.pop(context);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                _viewModel.createTodo(
                  _titleController.text,
                  _contentController.text,
                );
                _titleController.clear();
                _contentController.clear();
                Navigator.pop(context);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('待办事项')),
      body: Column(
        children: [
          if (viewModel.errorMessage.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.red.shade100,
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(child: Text(viewModel.errorMessage)),
                  IconButton(
                    onPressed: viewModel.clearErrorMessage,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
          ],
          if (viewModel.isLoading) ...[const LinearProgressIndicator()],
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (viewModel.uncompletedTodos.isNotEmpty) ...[
                  const Text(
                    '未完成',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...viewModel.uncompletedTodos.map(
                    (todo) => TodoItem(todo: todo, viewModel: viewModel),
                  ),
                  const SizedBox(height: 16),
                ],
                if (viewModel.completedTodos.isNotEmpty) ...[
                  const Text(
                    '已完成',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...viewModel.completedTodos.map(
                    (todo) => TodoItem(todo: todo, viewModel: viewModel),
                  ),
                ],
                if (viewModel.todoList.isEmpty && !viewModel.isLoading) ...[
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          '暂无待办事项',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  final TodoUIModel todo;
  final HomeViewModel viewModel;

  const TodoItem({super.key, required this.todo, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Checkbox(
              value: todo.isCompleted,
              onChanged: (value) {
                viewModel.toggleTodoStatus(todo);
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: todo.isCompleted ? Colors.grey : null,
                    ),
                  ),
                  if (todo.content.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      todo.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: todo.isCompleted ? Colors.grey : Colors.black54,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    '创建于: ${todo.createdAt}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('确认删除'),
                      content: const Text('确定要删除这个待办事项吗？'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () {
                            viewModel.deleteTodo(todo.id);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '删除',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
