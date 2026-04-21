import 'package:flutter/material.dart';

/// 国家列表项组件
class CountryListItem extends StatefulWidget {
  final int index;
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onDelete;
  final bool isFirst;
  final bool isLast;

  const CountryListItem({
    super.key,
    required this.index,
    required this.value,
    required this.onChanged,
    required this.onDelete,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  State<CountryListItem> createState() => _CountryListItemState();
}

class _CountryListItemState extends State<CountryListItem> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(CountryListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当 index 或 value 变化时，需要更新 controller
    // index 变化说明列表发生了删除/插入，必须重置 controller
    if (oldWidget.index != widget.index ||
        (oldWidget.value != widget.value &&
            oldWidget.value != _controller.text)) {
      _controller.dispose();
      _controller = TextEditingController(text: widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 序号
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '${widget.index + 1}',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 输入框
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  hintText: '请输入国家名称',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 删除按钮
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red[300]),
              onPressed: widget.onDelete,
              tooltip: '删除',
            ),
          ],
        ),
      ),
    );
  }
}
