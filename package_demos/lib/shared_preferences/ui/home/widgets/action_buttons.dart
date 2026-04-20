import 'package:flutter/material.dart';

/// 操作按钮组 - 保存、检查、清除三个按钮
class ActionButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSave;
  final VoidCallback onCheck;
  final VoidCallback onClear;
  final String saveLabel;
  final String checkLabel;
  final String clearLabel;
  final Color? saveColor;

  const ActionButtons({
    super.key,
    required this.isLoading,
    required this.onSave,
    required this.onCheck,
    required this.onClear,
    this.saveLabel = '保存',
    this.checkLabel = '检查',
    this.clearLabel = '清除',
    this.saveColor,
  });

  @override
  Widget build(BuildContext context) {
    final saveButtonColor = saveColor ?? Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(saveLabel),
                onPressed: isLoading ? null : onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: saveButtonColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.check),
                label: Text(checkLabel),
                onPressed: isLoading ? null : onCheck,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                icon: const Icon(Icons.clear),
                label: Text(clearLabel),
                onPressed: isLoading ? null : onClear,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
