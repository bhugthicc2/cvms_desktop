DateTime addWorkingDays(DateTime start, int days) {
  var date = start;
  var added = 0;

  while (added < days) {
    date = date.add(const Duration(days: 1));
    if (date.weekday <= DateTime.friday) {
      added++;
    }
  }
  return date;
}
