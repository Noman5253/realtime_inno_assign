// ignore_for_file: non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? myPrefs;

  static Future<void> initSharedPref() async {
    myPrefs = await SharedPreferences.getInstance();
  }

  static String? fetchEmployees() {
    return myPrefs?.getString(SfKey.employees);
  }

  static void setEmployees(String employees) {
    myPrefs?.setString(SfKey.employees, employees);
  }

  static String? fetchLastDeletedEmployee() {
    return myPrefs?.getString(SfKey.lastEmployee);
  }

  static void setLastDeletedEmployee(String lastEmployee) {
    myPrefs?.setString(SfKey.lastEmployee, lastEmployee);
  }

  static int? fetchLastEmpIndex() {
    return myPrefs?.getInt(SfKey.lastEmpIndex);
  }

  static void setLastEmpIndex(int lastEmpIndex) {
    myPrefs?.setInt(SfKey.lastEmpIndex, lastEmpIndex);
  }

  // ignore: missing_return
  static Future<void> clearSharedPrefs() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.clear();
  }
}

class SfKey {
  static const employees = "employees";
  static const lastEmployee = "lastEmployee";
  static const lastEmpIndex = "lastEmpIndex";
}
