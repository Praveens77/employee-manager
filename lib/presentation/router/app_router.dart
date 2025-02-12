import 'package:employee_manager/presentation/screens/add_employee.dart';
import 'package:employee_manager/presentation/screens/edit_employee.dart';
import 'package:employee_manager/presentation/screens/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:employee_manager/presentation/components/not_found_page.dart';
import 'package:employee_manager/services/employee_service.dart';
import 'package:employee_manager/data/employee_model.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const EmployeeList(),
    ),
    GoRoute(
      path: '/add_employee',
      builder: (context, state) => const AddEmployee(),
    ),
    GoRoute(
      path: '/edit_employee/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;

        return FutureBuilder<EmployeeModel?>(
          future: EmployeeService.getEmployeeById(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Scaffold(
                body: Center(
                  child: Text(
                    "Employee not found!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            } else {
              return EditEmployee(id: id, employee: snapshot.data!);
            }
          },
        );
      },
    ),
  ],
  errorBuilder: (context, state) => const NotFoundPage(),
);
