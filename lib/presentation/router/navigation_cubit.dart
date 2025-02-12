import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum AppPage { employeeList, addEmployee, editEmployee }

class NavigationCubit extends Cubit<AppPage> {
  final GoRouter router;

  NavigationCubit(this.router) : super(AppPage.employeeList);

  void goToEmployeeList() => router.go('/');

  void goToAddEmployee() => router.go('/add_employee');

  void goToEditEmployee(String id, Map<String, dynamic> employee) {
    router.go('/edit_employee/$id', extra: {'employee': employee});
  }
}
