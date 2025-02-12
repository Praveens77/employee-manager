import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/employee_model.dart';

class EmployeeService {
  static const String employeesKey = 'employees';

  static Future<EmployeeModel?> getEmployeeById(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> employeesJson = prefs.getStringList(employeesKey) ?? [];

    for (String jsonStr in employeesJson) {
      Map<String, dynamic> jsonMap = json.decode(jsonStr);
      if (jsonMap['id'] == id) {
        return EmployeeModel.fromJson(jsonMap);
      }
    }
    return null;
  }

  static Future<void> saveEmployee(EmployeeModel employee) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> employeesJson = prefs.getStringList(employeesKey) ?? [];

    employeesJson.add(json.encode(employee.toJson()));
    await prefs.setStringList(employeesKey, employeesJson);
  }
}
