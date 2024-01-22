part of 'calendar_bloc.dart';

sealed class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

final class CalendarInitial extends CalendarState {}

final class OnDaySelectedState extends CalendarState {
  final DateTime onSelectedDate;
  const OnDaySelectedState({required this.onSelectedDate});

  @override
  List<Object> get props => [onSelectedDate];
}

final class OnSuggestionChangeState extends CalendarState {
  final int suggestion;
  const OnSuggestionChangeState({required this.suggestion});


  @override
  List<Object> get props => [suggestion];
}
