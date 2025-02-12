import 'dart:convert';

class EmployeeModel {
  final String id;
  String name;
  String presentDate;
  String role;
  String endDate;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.presentDate,
    required this.role,
    required this.endDate,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      presentDate: json['present_date'],
      role: json['role'],
      endDate: json['end_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'present_date': presentDate, 
      'role': role,
      'end_date': endDate,
    };
  }

  String toJsonString() => json.encode(toJson());
}
