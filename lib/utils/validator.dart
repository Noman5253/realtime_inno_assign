
import '../features/employee/data/entity_model/employee_entity.dart';

abstract class Validator {
  bool isValid();
}

class StringValidator extends Validator {
  String? s;
  StringValidator(this.s);

  @override
  bool isValid() {
    return s != null &&
        s.toString().trim().isNotEmpty &&
        s.toString().trim() != "null";
  }
}

class AddEmployeeValidator extends Validator {
  Employee? employee;
  AddEmployeeValidator(this.employee);

  @override
  bool isValid() {
    if (employee == null) {
      return false;
    }
    if (employee != null) {
      if (employee!.name.toString().trim().isEmpty) {
        return false;
      }
      if (employee!.role.toString().trim().isEmpty) {
        return false;
      }
      if (!StringValidator(employee!.fromDate).isValid()) {
        return false;
      }
      if (!StringValidator(employee!.toDate).isValid()) {
        return false;
      }
    }
    return true;
  }
}
