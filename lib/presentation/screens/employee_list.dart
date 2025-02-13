import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_manager/bloc/employee_bloc.dart';
import 'package:employee_manager/data/employee_model.dart';
import 'package:employee_manager/utils/app_colors.dart';
import 'package:employee_manager/utils/app_images.dart';
import 'package:employee_manager/utils/common_methods.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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
      floatingActionButton: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: theme,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8.0),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              context.go('/add_employee');
            },
            child: Center(child: SvgPicture.asset(ImagePath.plusicon)),
          ),
        ),
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeUpdated && state.emp.isNotEmpty) {
            final List<EmployeeModel> currentEmployees = [];
            final List<EmployeeModel> previousEmployees = [];
            for (final employee in state.emp) {
              if (employee.endDate.isNotEmpty) {
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
                  child: textContainer(context, "Current employees"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: currentEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = currentEmployees[index];
                      return GestureDetector(
                        onTap: () {
                          context.go('/edit_employee/${employee.id}',
                              extra: {'employee': employee});
                        },
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
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
                                        15, white, FontWeight.w400),
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
                                          "Undo", 15, theme, FontWeight.w400),
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
                          child: currentEmployeeTab(context, employee),
                        ),
                      );
                    },
                  ),
                ),
                
                Visibility(
                  visible: previousEmployees.isNotEmpty,
                  child: textContainer(context, "Previous employees"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: previousEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = previousEmployees[index];
                      return GestureDetector(
                        onTap: () {
                          context.go('/edit_employee/${employee.id}',
                              extra: {'employee': employee});
                        },
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
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
                                        15, white, FontWeight.w400),
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
                                          "Undo", 15, theme, FontWeight.w400),
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
                          child: previousEmployeeTab(context, employee),
                        ),
                      );
                    },
                  ),
                ),
                instructionBox(context, "Swipe left to delete")
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
