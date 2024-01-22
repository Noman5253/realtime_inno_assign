import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


import 'package:assignment/utils/validator.dart';

import '../../data/entity_model/employee_entity.dart';
import '../../data/local/shared_prefs.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeLoadingState()) {
    on<FetchEmployeeEvent>(_onFetchEmployee);
    on<AddEmployeeEvent>(_onAddEmployee);
    on<UpdateEmployeeEvent>(_onUpdateEmployee);
    on<DeleteEmployeeEvent>(_onDeleteEmployee);
    on<UndoEmployeeDeleteEvent>(_onUndoEmployeeDelete);
  }

  FutureOr<void> _onFetchEmployee(
      FetchEmployeeEvent event, Emitter<EmployeeState> emit) {
    String? employees = SharedPref.fetchEmployees();
    Validator validator = StringValidator(employees);
    List<Employee> employeeList = List.empty(growable: true);
    if (validator.isValid()) {
      employeeList.addAll(List<Employee>.from(
          jsonDecode(employees!).map((x) => Employee.fromJson(x))));
    }
    emit(EmployeeLoadedState(employeeList: employeeList));
  }

  FutureOr<void> _onAddEmployee(
      AddEmployeeEvent event, Emitter<EmployeeState> emit) {
    final state = this.state;
    if (state is EmployeeLoadedState) {
      Validator employeeValidator = AddEmployeeValidator(event.employee);
      if (!employeeValidator.isValid()) {
        emit(InvalidEmployeeState());
        emit(EmployeeLoadedState(employeeList: List.from(state.employeeList)));
        return null;
      }

      List jsonEmps = [];
      String? emps = SharedPref.fetchEmployees();
      Validator validator = StringValidator(emps);
      if (validator.isValid()) {
        jsonEmps = jsonDecode(emps!);
      }
      jsonEmps.add(event.employee.toJson());
      SharedPref.setEmployees(jsonEncode(jsonEmps));
      emit(NewEmployAddedState());

      Employee newEmployee = event.employee
          .copyWith(id: DateTime.now().microsecondsSinceEpoch.toString());
      emit(EmployeeLoadedState(
          employeeList: List.from(state.employeeList)..add(newEmployee)));
    }
  }

  FutureOr<void> _onUpdateEmployee(
      UpdateEmployeeEvent event, Emitter<EmployeeState> emit) {
    final state = this.state;
    if (state is EmployeeLoadedState) {
      Validator employeeValidator = AddEmployeeValidator(event.employee);
      if (!employeeValidator.isValid()) {
        emit(InvalidEmployeeState());
        emit(EmployeeLoadedState(employeeList: List.from(state.employeeList)));
        return null;
      }

      List jsonEmps = [];
      List<Employee> tempEmpList = List.empty(growable: true);
      tempEmpList.addAll(List.from(state.employeeList));
      for (int i = 0; i < tempEmpList.length; i++) {
        if (tempEmpList[i].id == event.employee.id) {
          tempEmpList[i] = event.employee;
        }
      }

      jsonEmps = List<dynamic>.from(tempEmpList.map((x) => x.toJson()));
      SharedPref.setEmployees(jsonEncode(jsonEmps));
      emit(UpdateEmployAddedState());
      emit(EmployeeLoadedState(employeeList: tempEmpList));
    }
  }

  FutureOr<void> _onDeleteEmployee(
      DeleteEmployeeEvent event, Emitter<EmployeeState> emit) {
    final state = this.state;
    if (state is EmployeeLoadedState) {
      List<Employee> tempList = List.empty(growable: true);
      tempList.addAll(List.from(state.employeeList));

      int lastEmpIndex = -1;
      Employee lastEmployee = const Employee();
      for (int i = 0; i < tempList.length; i++) {
        if (tempList[i].id == event.employee.id) {
          lastEmpIndex = i;
          lastEmployee = lastEmployee.copyWith(
              id: tempList[i].id,
              name: tempList[i].name,
              role: tempList[i].role,
              fromDate: tempList[i].fromDate,
              toDate: tempList[i].toDate,
              isCurrentEmployee: tempList[i].isCurrentEmployee);
        }
      }
      tempList.removeAt(lastEmpIndex);

      SharedPref.setLastEmpIndex(lastEmpIndex);
      SharedPref.setLastDeletedEmployee(jsonEncode(lastEmployee.toJson()));
      List jsonEmps = [];
      jsonEmps = List<dynamic>.from(tempList.map((x) => x.toJson()));
      SharedPref.setEmployees(jsonEncode(jsonEmps));
      emit(DeleteEmployeeState());
      emit(EmployeeLoadedState(employeeList: tempList));
    }
  }

  FutureOr<void> _onUndoEmployeeDelete(
      UndoEmployeeDeleteEvent event, Emitter<EmployeeState> emit) {
    final state = this.state;
    if (state is EmployeeLoadedState) {
      List<Employee> tempEmpList = List.empty(growable: true);
      tempEmpList.addAll(List.from(state.employeeList));
      int lastIndex = (SharedPref.fetchLastEmpIndex())!;
      Employee lastEmployee = Employee.fromJson(
          jsonDecode((SharedPref.fetchLastDeletedEmployee())!));
      if (lastIndex <= tempEmpList.length) {
        tempEmpList.insert(lastIndex, lastEmployee);
      }
      List jsonEmps = [];
      jsonEmps = List<dynamic>.from(tempEmpList.map((x) => x.toJson()));
      SharedPref.setEmployees(jsonEncode(jsonEmps));
      emit(EmployeeLoadedState(employeeList: tempEmpList));
    }
  }
}
