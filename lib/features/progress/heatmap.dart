import 'package:flutter/material.dart';
import '../../core/theme.dart';

/// لون الخلية: أبيض (0) ← أخضر عشبي داكن (كثافة عالية).
Color heatColor(int count, {int maxCount = 6}) {
  if (count <= 0) return Colors.white;
  final t = (count / maxCount).clamp(0.0, 1.0);
  return Color.lerp(const Color(0xFFD4EDDA), AppColors.green, t)!;
}

class Heatmap extends StatelessWidget {
  const Heatmap({super.key, required this.countFor, this.weeks = 26});
  final int Function(DateTime) countFor;
  final int weeks;
  static const double cell = 14, gap = 3;
  static const _days = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج']; // السبت أولًا

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayIdx = (today.weekday + 1) % 7; // السبت = 0
    final start = today.subtract(Duration(days: todayIdx + (weeks - 1) * 7));

    final columns = List.generate(weeks, (w) => Column(
          children: List.generate(7, (d) {
            final date = start.add(Duration(days: w * 7 + d));
            final future = date.isAfter(today);
            final c = future ? 0 : countFor(date);
            return Tooltip(
              message: '${date.day}/${date.month} • $c مهام',
              child: Container(
                width: cell, height: cell,
                margin: const EdgeInsets.all(gap / 2),
                decoration: BoxDecoration(
                  color: future ? Colors.transparent : heatColor(c),
                  borderRadius: BorderRadius.circular(3),
                  border: future ? null : Border.all(color: AppColors.border, width: .6),
                ),
              ),
            );
          }),
        ));

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        for (final d in _days)
          SizedBox(
            height: cell + gap, width: 16,
            child: Center(child: Text(d, style: const TextStyle(fontSize: 10, color: AppColors.muted))),
          ),
      ]),
      Expanded(
        // reverse: يبدأ من الأحدث (يسار الشاشة في RTL)
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(children: columns),
        ),
      ),
    ]);
  }
}

class HeatmapLegend extends StatelessWidget {
  const HeatmapLegend({super.key});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('أقل', style: TextStyle(fontSize: 11, color: AppColors.muted)),
          const SizedBox(width: 6),
          for (final c in [0, 1, 2, 4, 6])
            Container(
              width: 12, height: 12, margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                color: heatColor(c), borderRadius: BorderRadius.circular(3),
                border: Border.all(color: AppColors.border, width: .6)),
            ),
          const SizedBox(width: 6),
          const Text('أكثر', style: TextStyle(fontSize: 11, color: AppColors.muted)),
        ],
      );
}
