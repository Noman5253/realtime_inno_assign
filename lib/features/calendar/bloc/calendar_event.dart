part of 'calendar_bloc.dart';

sealed class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class OnDaySelectedEvent extends CalendarEvent {
  final DateTime onSelectedDate;
  const OnDaySelectedEvent({required this.onSelectedDate});

  @override
  List<Object> get props => [onSelectedDate];
}

final class OnSuggestionChangeEvent   extends CalendarEvent {
  final int suggestion;
  const OnSuggestionChangeEvent({required this.suggestion});


  @override
  List<Object> get props => [suggestion];
}