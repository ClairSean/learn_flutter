import 'package:flutter/material.dart';

/// 国家列表信息卡片（未展开状态）
class CountryListCard extends StatelessWidget {
  final List<String> countries;
  final bool hasCountryList;
  final bool isExpanded;
  final VoidCallback onTap;

  const CountryListCard({
    super.key,
    required this.countries,
    required this.hasCountryList,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final count = countries.length;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.public, color: Colors.purple[700], size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '国家列表',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      !hasCountryList ? '未保存' : '已保存 $count 个国家',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
