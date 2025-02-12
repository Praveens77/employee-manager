part of 'bloc.dart';

abstract class EmployeeState {
  List<EmployeeModel> emp;
  String? selectedOption;
  EmployeeState({required this.emp});
}

class EmployeeInitial extends EmployeeState {
  EmployeeInitial({required super.emp, required DateTime selectedDate});
}

class EmployeeUpdated extends EmployeeState {
  final DateTime selectedDate;
  final String? selectedRole;
  final String? selectedOption;

  EmployeeUpdated({
    required super.emp,
    required this.selectedDate,
    this.selectedRole,
    this.selectedOption,
  });
}
