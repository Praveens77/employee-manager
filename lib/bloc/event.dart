part of 'bloc.dart';

@immutable
abstract class EmployeeEvent {}

class AddEmp extends EmployeeEvent {
  final EmployeeModel employee;

  AddEmp({required this.employee});
}

class DelEmp extends EmployeeEvent {
  final EmployeeModel employee;

  DelEmp({required this.employee});
}

class EditEmp extends EmployeeEvent {
  final EmployeeModel employee;

  EditEmp({required this.employee});
}

class UpdateRole extends EmployeeEvent {
  final String role;

  UpdateRole(String selectedRole, {required this.role});
}

class UndoDeleteEmp extends EmployeeEvent {
  final EmployeeModel employee;

  UndoDeleteEmp({required this.employee});
}

class SelectDateEvent extends EmployeeEvent {
  final DateTime selectedDate;

  SelectDateEvent(this.selectedDate);
}

class UpdateSelectedRole extends EmployeeEvent {
  final String selectedRole;

  UpdateSelectedRole(this.selectedRole);
}
class UpdateSelectedStartDate extends EmployeeEvent {
  final String selectedDate;

  UpdateSelectedStartDate(this.selectedDate);
}
class UpdateSelectedEndDate extends EmployeeEvent {
  final String selectedDate;

  UpdateSelectedEndDate(this.selectedDate);
}

class UpdateSelectedOption extends EmployeeEvent {
  final String selectedOption;

  UpdateSelectedOption(this.selectedOption);
}
