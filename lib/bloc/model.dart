import 'dart:convert';

class EmployeeModel {
  final String id;
  String name;
  String presentdate;
  String selectedRole;
  String enddate;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.presentdate,
    required this.selectedRole,
    required this.enddate,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      presentdate: json['presentdate'],
      selectedRole: json['selectedRole'],
      enddate: json['enddate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'presentdate': presentdate,
      'selectedRole': selectedRole,
      'enddate': enddate,
    };
  }

  String toJsonString() {
    return json.encode(toJson());
  }
}
