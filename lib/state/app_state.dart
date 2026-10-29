import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/task.dart';

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

class AppState extends ChangeNotifier {
  AppState() {
    final today = dateOnly(DateTime.now());
    tasks = [
      Task(id: '1', title: 'مراجعة الفصل الثالث', subject: 'الفيزياء', date: today, done: true),
      Task(id: '2', title: 'حل تمارين التفاضل', subject: 'الرياضيات', date: today),
      Task(id: '3', title: 'حفظ مفردات الوحدة 5', subject: 'اللغة الإنجليزية', date: today),
      Task(id: '4', title: 'ملخص الأحماض الأمينية', subject: 'الأحياء', date: today),
      Task(id: '5', title: 'اختبار تجريبي', subject: 'الرياضيات', date: today.add(const Duration(days: 1))),
    ];
    // بيانات تجريبية لسجل النشاط (تُستبدل لاحقًا بقاعدة بيانات محلية)
    final r = Random(7);
    for (var i = 1; i < 180; i++) {
      final v = r.nextInt(10);
      history[today.subtract(Duration(days: i))] = v < 3 ? 0 : v - 2;
    }
    history[today] = tasks.where((t) => t.done).length;
  }

  late final List<Task> tasks;
  final Map<DateTime, int> history = {};
  DateTime selectedDay = dateOnly(DateTime.now());
  String? subjectFilter; // null = الكل

  List<String> get subjects => tasks.map((t) => t.subject).toSet().toList();

  List<Task> get visible => tasks
      .where((t) => t.date == selectedDay &&
          (subjectFilter == null || t.subject == subjectFilter))
      .toList();

  int countFor(DateTime d) => history[dateOnly(d)] ?? 0;

  /// تبديل الإنجاز: يُحدّث الخريطة الحرارية مباشرة.
  void toggle(Task t) {
    t.done = !t.done;
    final k = dateOnly(DateTime.now());
    history[k] = max(0, countFor(k) + (t.done ? 1 : -1));
    notifyListeners();
  }

  void selectDay(DateTime d) { selectedDay = dateOnly(d); notifyListeners(); }
  void setSubject(String? s) { subjectFilter = s; notifyListeners(); }
}
