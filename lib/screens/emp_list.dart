import 'package:employee_manager/screens/add_emp.dart';
import 'package:employee_manager/screens/edit_emp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_manager/bloc/bloc.dart';
import 'package:employee_manager/bloc/model.dart';
import 'package:employee_manager/common/color.dart';
import 'package:employee_manager/common/image.dart';
import 'package:employee_manager/common/widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme,
        title: customText("Employee List", 18, white, FontWeight.w500),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddEmployee()));
        },
        child: Center(child: SvgPicture.asset(ImagePath.plusicon)),
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeUpdated && state.emp.isNotEmpty) {
            final List<EmployeeModel> currentEmployees = [];
            final List<EmployeeModel> previousEmployees = [];
            for (final employee in state.emp) {
              if (employee.enddate.isNotEmpty) {
                previousEmployees.add(employee);
              } else {
                currentEmployees.add(employee);
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: currentEmployees.isNotEmpty,
                  child: textContainer(context, "Current employee"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: currentEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = currentEmployees[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditEmployee(
                                employee: employee,
                                id: employee.id,
                              ),
                            ),
                          );
                        },
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) {
                            BlocProvider.of<EmployeeBloc>(context)
                                .add(DelEmp(employee: employee));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    customText("Employee data has been deleted",
                                        14, white, FontWeight.w500),
                                    GestureDetector(
                                      onTap: () {
                                        if (ModalRoute.of(context) != null) {
                                          BlocProvider.of<EmployeeBloc>(context)
                                              .add(UndoDeleteEmp(
                                                  employee: employee));
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        } else {
                                          debugPrint(
                                              'Cannot perform action: Widget context is deactivated.');
                                        }
                                      },
                                      child: customText(
                                          "Undo", 14, theme, FontWeight.w500),
                                    ),
                                  ],
                                ),
                                backgroundColor: black,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          background: Container(
                            color: red,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: SvgPicture.asset(ImagePath.delete),
                            ),
                          ),
                          secondaryBackground: Container(
                            color: red,
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: SvgPicture.asset(ImagePath.delete),
                            ),
                          ),
                          child: currentEmpContainer(context, employee),
                        ),
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: previousEmployees.isNotEmpty,
                  child: textContainer(context, "Previous employee"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: previousEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = previousEmployees[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditEmployee(
                                  employee: employee, id: employee.id),
                            ),
                          );
                        },
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) {
                            BlocProvider.of<EmployeeBloc>(context)
                                .add(DelEmp(employee: employee));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    customText("Employee data has been deleted",
                                        16, white, FontWeight.w500),
                                    GestureDetector(
                                      onTap: () {
                                        if (ModalRoute.of(context) != null) {
                                          BlocProvider.of<EmployeeBloc>(context)
                                              .add(UndoDeleteEmp(
                                                  employee: employee));
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        } else {
                                          // ignore: avoid_print
                                          print(
                                              'Cannot perform action: Widget context is deactivated.');
                                        }
                                      },
                                      child: customText(
                                          "Undo", 16, theme, FontWeight.w500),
                                    ),
                                  ],
                                ),
                                backgroundColor: black,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          background: Container(
                            color: red,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: SvgPicture.asset(ImagePath.delete),
                            ),
                          ),
                          secondaryBackground: Container(
                            color: red,
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: SvgPicture.asset(ImagePath.delete),
                            ),
                          ),
                          child: previousEmpContainer(context, employee),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: SvgPicture.asset(ImagePath.logo),
            );
          }
        },
      ),
    );
  }
}
