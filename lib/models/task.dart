class Task {
  Task({required this.id, required this.title, required this.subject,
      required this.date, this.done = false});
  final String id;
  final String title;
  final String subject;
  final DateTime date; // التاريخ فقط
  bool done;
}
