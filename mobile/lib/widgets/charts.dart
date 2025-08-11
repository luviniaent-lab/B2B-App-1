import 'package:flutter/material.dart';

class BarChartSimple extends StatelessWidget {
  final Map<String, int> data;
  final double height;
  const BarChartSimple({super.key, required this.data, this.height = 160});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const Center(child: Text('No data'));
    final maxVal = data.values.reduce((a, b) => a > b ? a : b).toDouble();
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.entries.map((e) {
          final ratio = maxVal == 0 ? 0 : (e.value / maxVal);
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${e.value}', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 4),
                Container(
                  height: (height - 48) * ratio,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(e.key, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

