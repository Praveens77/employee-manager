import 'package:employee_manager/data/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  DateTime selectedDate = DateTime.now();
  String? selectedOption;

  EmployeeBloc()
      : super(EmployeeInitial(emp: [], selectedDate: DateTime.now())) {
    loadEmployees();
    on<AddEmp>(addemp);
    on<DelEmp>(delemp);
    on<EditEmp>(editemp);
    on<UpdateSelectedRole>(updateselectedrole);
    on<UndoDeleteEmp>(undoDeleteEmp);
    on<SelectDateEvent>((event, emit) {
      selectedDate = event.selectedDate;
      emit(EmployeeUpdated(emp: state.emp, selectedDate: selectedDate));
    });
    on<UpdateSelectedOption>((event, emit) {
      selectedOption = event.selectedOption;
      emit(EmployeeUpdated(
        emp: state.emp,
        selectedDate: selectedDate,
        selectedOption: selectedOption,
      ));
    });
    // Add event handler for UpdateSelectedStartDate
    on<UpdateSelectedStartDate>((event, emit) {
      selectedDate = DateTime.parse(event.selectedDate);
      emit(EmployeeUpdated(emp: state.emp, selectedDate: selectedDate));
    });
    // Add event handler for UpdateSelectedEndDate
    on<UpdateSelectedEndDate>((event, emit) {
      selectedDate = DateTime.parse(event.selectedDate);
      emit(EmployeeUpdated(emp: state.emp, selectedDate: selectedDate));
    });
  }

  void addemp(AddEmp event, Emitter<EmployeeState> emit) {
    state.emp.add(event.employee);
    saveEmployees(state.emp);
    emit(EmployeeUpdated(emp: state.emp, selectedDate: DateTime.now()));
  }

  void delemp(DelEmp event, Emitter<EmployeeState> emit) {
    state.emp.remove(event.employee);
    saveEmployees(state.emp);
    emit(EmployeeUpdated(emp: state.emp, selectedDate: DateTime.now()));
  }

  void editemp(EditEmp event, Emitter<EmployeeState> emit) {
    List<EmployeeModel> updatedEmpList = List.from(state.emp);

    for (int i = 0; i < updatedEmpList.length; i++) {
      if (event.employee.id == updatedEmpList[i].id) {
        updatedEmpList[i] = event.employee;
        break;
      }
    }

    saveEmployees(updatedEmpList);
    emit(EmployeeUpdated(emp: updatedEmpList, selectedDate: DateTime.now()));
  }

  void updateselectedrole(
      UpdateSelectedRole event, Emitter<EmployeeState> emit) {
    emit(EmployeeUpdated(
      emp: state.emp,
      selectedRole: event.selectedRole,
      selectedDate: DateTime.now(),
    ));
  }

  void undoDeleteEmp(UndoDeleteEmp event, Emitter<EmployeeState> emit) {
    state.emp.add(event.employee);
    saveEmployees(state.emp);
    emit(EmployeeUpdated(emp: state.emp, selectedDate: DateTime.now()));
  }

  Future<void> loadEmployees() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? employeesJson = prefs.getStringList('employees');
    if (employeesJson != null) {
      List<EmployeeModel> employees = employeesJson
          .map((e) => EmployeeModel.fromJson(json.decode(e)))
          .toList();
      // ignore: invalid_use_of_visible_for_testing_member
      emit(EmployeeUpdated(emp: employees, selectedDate: DateTime.now()));
    }
  }

  Future<void> saveEmployees(List<EmployeeModel> employees) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> employeesJson =
        employees.map((e) => e.toJsonString()).toList();
    prefs.setStringList('employees', employeesJson);
  }
}
