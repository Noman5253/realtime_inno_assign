part of 'employee_bloc.dart';

sealed class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

final class EmployeeLoadingState extends EmployeeState {}

final class EmployeeLoadedState extends EmployeeState {
  final List<Employee> employeeList;

  const EmployeeLoadedState({this.employeeList = const <Employee>[]});

  @override
  List<Object> get props => [employeeList];
}

final class AddEmployeeState extends EmployeeState {}

final class InvalidEmployeeState extends EmployeeState {}

final class NewEmployAddedState extends EmployeeState {}

final class UpdateEmployAddedState extends EmployeeState {}

final class DeleteEmployeeState extends EmployeeState {}

final class UndoEmployeeDeleteStat extends EmployeeState {}
