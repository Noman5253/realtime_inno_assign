import 'package:intl/intl.dart';

abstract class MyDateFormator {
  String formatDate(DateTime date);
}

abstract class MyDateParser {
  DateTime parseDate(String date);
}

class DMMMYYYYDateFormator extends MyDateFormator {
  @override
  String formatDate(DateTime date) {
    try {
      return DateFormat("d MMM yyyy").format(date);
    } catch (e) {
      return date.toString();
    }
  }
}

class MicroSecSinceEpochParser extends MyDateParser {
  @override
  DateTime parseDate(String date) {
    return DateTime.fromMicrosecondsSinceEpoch(int.parse(date));
  }
}
