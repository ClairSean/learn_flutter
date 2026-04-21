import 'package:flutter/material.dart';

/// VIP 状态切换开关
class VipSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const VipSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              value ? Icons.workspace_premium : Icons.person_outline,
              color: value ? Colors.amber : Colors.grey,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VIP 状态',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: value ? Colors.amber : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value ? '当前是 VIP 用户' : '当前是非 VIP 用户',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
