import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_logo.dart';
import '../../core/theme.dart';
import '../../state/app_state.dart';
import '../progress/heatmap.dart';

const _dayNames = ['السبت', 'الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  static const _tabs = [
    (Icons.checklist_rtl, 'اليوم'),
    (Icons.calendar_month_outlined, 'الجدول'),
    (Icons.timer_outlined, 'المؤقت'),
    (Icons.school_outlined, 'الاختبارات'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          titleSpacing: 16,
          title: Row(children: [
            const AppLogo(size: 34),
            const SizedBox(width: 10),
            Text('مذاكرتي', style: Theme.of(context).textTheme.titleLarge),
          ]),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720), // استجابة للشاشات الكبيرة
            child: _tab == 0 ? const _TodayView() : _Soon(label: _tabs[_tab].$2),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: [
            for (final t in _tabs) NavigationDestination(icon: Icon(t.$1), label: t.$2),
          ],
        ),
      );
}

class _Soon extends StatelessWidget {
  const _Soon({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) =>
      Center(child: Text('$label — قريبًا', style: const TextStyle(color: AppColors.muted)));
}

class _TodayView extends StatelessWidget {
  const _TodayView();

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final theme = Theme.of(context).textTheme;
    final today = dateOnly(DateTime.now());
    final weekStart = today.subtract(Duration(days: (today.weekday + 1) % 7));
    final items = s.visible;

    return ListView(padding: const EdgeInsets.all(16), children: [
      // — الخريطة الحرارية
      Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('نشاط المذاكرة', style: theme.titleMedium),
            const SizedBox(height: 10),
            Heatmap(countFor: s.countFor),
            const SizedBox(height: 8),
            const HeatmapLegend(),
          ]),
        ),
      ),
      const SizedBox(height: 16),

      // — فلتر اليوم
      SizedBox(
        height: 44,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          for (var i = 0; i < 7; i++) ...[
            Builder(builder: (_) {
              final d = weekStart.add(Duration(days: i));
              return ChoiceChip(
                label: Text('${_dayNames[i]} ${d.day}'),
                selected: s.selectedDay == d,
                onSelected: (_) => s.selectDay(d),
              );
            }),
            const SizedBox(width: 8),
          ],
        ]),
      ),
      const SizedBox(height: 8),

      // — فلتر المادة
      SizedBox(
        height: 44,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          ChoiceChip(
            label: const Text('كل المواد'),
            selected: s.subjectFilter == null,
            onSelected: (_) => s.setSubject(null),
          ),
          for (final sub in s.subjects) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              label: Text(sub),
              selected: s.subjectFilter == sub,
              onSelected: (_) => s.setSubject(sub),
            ),
          ],
        ]),
      ),
      const SizedBox(height: 12),

      // — المهام مع مربعات الاختيار
      Text('مهام اليوم (${items.where((t) => t.done).length}/${items.length})',
          style: theme.titleMedium),
      const SizedBox(height: 8),
      if (items.isEmpty)
        const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('لا توجد مهام', style: TextStyle(color: AppColors.muted))),
        ),
      for (final t in items)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            child: CheckboxListTile(
              value: t.done,
              onChanged: (_) => s.toggle(t),
              controlAffinity: ListTileControlAffinity.leading, // يمين الشاشة في RTL
              title: Text(t.title,
                  style: TextStyle(
                    decoration: t.done ? TextDecoration.lineThrough : null,
                    color: t.done ? AppColors.muted : AppColors.ink,
                  )),
              subtitle: Text(t.subject),
            ),
          ),
        ),
    ]);
  }
}
