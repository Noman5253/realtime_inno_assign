import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial()) {
    on<OnDaySelectedEvent>(_onDaySelected);
    on<OnSuggestionChangeEvent>(_onSuggestionChanged);
  }

  FutureOr<void> _onDaySelected(
      OnDaySelectedEvent event, Emitter<CalendarState> emit) {
    emit(OnDaySelectedState(onSelectedDate: event.onSelectedDate));
  }

  FutureOr<void> _onSuggestionChanged(
      OnSuggestionChangeEvent event, Emitter<CalendarState> emit) {
    emit(OnSuggestionChangeState(suggestion: event.suggestion));
  }
}
