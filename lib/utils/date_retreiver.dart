import 'package:assignment/utils/next_date.dart';

import 'constants.dart';

abstract class DateRetreiver {
  DateTime retreiveDate(int selectedOption, DateTime currentDate);
}

class FromDateRetriever extends DateRetreiver {
  late GetDate thisDay;
  FromDateRetriever();

  @override
  DateTime retreiveDate(int selectedOption, DateTime currentDate) {
    if (selectedOption == DateSuggestorConstants.today) {
      thisDay = GetToday();
      currentDate = thisDay.getDate(currentDate);
    } else if (selectedOption == DateSuggestorConstants.nextMonday) {
      thisDay = GetMonday();
      currentDate = thisDay.getDate(currentDate);
    } else if (selectedOption == DateSuggestorConstants.nextTuesday) {
      thisDay = GetTuesday();
      currentDate = thisDay.getDate(currentDate);
    } else if (selectedOption == DateSuggestorConstants.nextWeek) {
      thisDay = GetNextWeek();
      currentDate = thisDay.getDate(currentDate);
    }
    return currentDate;
  }
}

class ToDateRetriever extends DateRetreiver {
  late GetDate thisDay;
  ToDateRetriever();

  @override
  DateTime retreiveDate(int selectedOption, DateTime currentDate) {
    if (selectedOption == DateSuggestorConstants.today) {
      thisDay = GetToday();
      currentDate = thisDay.getDate(currentDate);
    } else if (selectedOption == DateSuggestorConstants.noDate) {
      thisDay = GetNoDate();
      currentDate = thisDay.getDate(currentDate);
    } 
    return currentDate;
  }
}
