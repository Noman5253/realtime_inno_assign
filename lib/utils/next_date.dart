
abstract class GetDate {
  DateTime getDate(DateTime currentDate);
}

class GetMonday extends GetDate {
  @override
  DateTime getDate(DateTime currentDate) {
    DateTime now = currentDate; //DateTime.now();
    int daysUntilMonday = (now.weekday == 1) ? 7 : (8 - now.weekday) % 7;
    DateTime nextMonday = now.add(Duration(days: daysUntilMonday));
    return nextMonday;
  }
}

class GetTuesday extends GetDate {
  @override
  DateTime getDate(DateTime currentDate) {
    DateTime now = currentDate;
    int daysUntilTuesday =
        (now.weekday <= 2) ? 2 - now.weekday : (9 - now.weekday) % 7;

    if (daysUntilTuesday == 0) {
      daysUntilTuesday = 7;
    }

    DateTime nextTuesday = now.add(Duration(days: daysUntilTuesday));
    return nextTuesday;
  }
}

class GetToday extends GetDate {
  @override
  DateTime getDate(DateTime currentDate) {
    return DateTime.now();
  }
}

class GetNextWeek extends GetDate {
  @override
  DateTime getDate(DateTime currentDate) {
    DateTime now = currentDate;
    int daysUntilNextWeek = 7;
    DateTime nextTuesday = now.add(Duration(days: daysUntilNextWeek));
    return nextTuesday;
  }
}

class GetNoDate extends GetDate {
  @override
  DateTime getDate(DateTime currentDate) {
    //year 1900 specifies No date
    return DateTime(1900);
  }
}
