part of 'employee_bloc.dart';

sealed class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class FetchEmployeeEvent extends EmployeeEvent {
  final List<Employee> employeeList;
  const FetchEmployeeEvent({this.employeeList = const <Employee>[]});

  @override
  List<Object> get props => [employeeList];
}

class AddEmployeeEvent extends EmployeeEvent {
  final Employee employee;
  const AddEmployeeEvent({required this.employee});
  
  @override
  List<Object> get props => [employee];
}

class UpdateEmployeeEvent extends EmployeeEvent {
  final Employee employee;
  const UpdateEmployeeEvent({required this.employee});
  
  @override
  List<Object> get props => [employee];
}

class DeleteEmployeeEvent extends EmployeeEvent {
  final Employee employee;
  const DeleteEmployeeEvent({required this.employee});
  
  @override
  List<Object> get props => [employee];
}

class UndoEmployeeDeleteEvent extends EmployeeEvent {
  
  const UndoEmployeeDeleteEvent();
  
  @override
  List<Object> get props => [];
}

