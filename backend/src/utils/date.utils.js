function addWorkingDays(startDate, days) {
  const date = new Date(startDate);
  let added = 0;

  while (added < days) {
    date.setDate(date.getDate() + 1);
    const day = date.getDay();
    if (day !== 0 && day !== 6) {
      added++;
    }
  }
  return date;
}

module.exports = { addWorkingDays };
