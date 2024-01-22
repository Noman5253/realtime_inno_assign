import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Employee extends Equatable {
  final String? id;
  final String? name;
  final String? role;
  final String? fromDate;
  final String? toDate;
  final bool? isCurrentEmployee;

  const Employee(
      {this.id,
      this.name,
      this.role,
      this.fromDate,
      this.toDate,
      this.isCurrentEmployee});

  @override
  List<Object?> get props =>
      [id, name, role, fromDate, toDate, isCurrentEmployee];

  @override
  String toString() {
    return 'Employee(id: $id, name: $name, role: $role, fromDate: $fromDate, toDate: $toDate, isCurrentEmployee: $isCurrentEmployee)';
  }    

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      role: json["role"] ?? "",
      fromDate: json["fromDate"] ?? "",
      toDate: json["toDate"] ?? "",
      isCurrentEmployee: json["isCurrentEmployee"] ?? true);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role": role,
        "fromDate": fromDate,
        "toDate": toDate,
        "isCurrentEmployee": isCurrentEmployee,
      };

  Employee copyWith({
    String? id,
    String? name,
    String? role,
    String? fromDate,
    String? toDate,
    bool? isCurrentEmployee,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      isCurrentEmployee: isCurrentEmployee ?? this.isCurrentEmployee,
    );
  }
}

