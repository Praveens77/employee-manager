import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:employee_manager/bloc/employee_bloc.dart';
import 'package:employee_manager/data/employee_model.dart';
import 'package:employee_manager/presentation/components/custom_calendar.dart';
import 'package:employee_manager/utils/app_colors.dart';
import 'package:employee_manager/utils/app_images.dart';
import 'package:employee_manager/utils/common_methods.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditEmployee extends StatelessWidget {
  const EditEmployee({super.key, required this.employee, required this.id});
  final EmployeeModel employee;
  final String id;

  @override
  Widget build(BuildContext context) {
    String name = employee.name;
    String presDate = employee.presentDate;
    String endDate = employee.endDate;
    final formKey = GlobalKey<FormState>();
    final selectedRoleNotifier = ValueNotifier<String>(employee.role);

    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: theme,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText("Edit Employee Details", 18, white, FontWeight.w500),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<EmployeeBloc>(context)
                        .add(DelEmp(employee: employee));
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(ImagePath.delete),
                ),
              ],
            ),
          ),
          body: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      editField(
                        context,
                        "Name",
                        ImagePath.person,
                        lighttext,
                        false,
                        null,
                        null,
                        (value) {
                          name = value;
                        },
                        initialValue: name,
                      ),
                      gapH(23),
                      ValueListenableBuilder<String>(
                          valueListenable: selectedRoleNotifier,
                          builder: (context, selectedRole, _) {
                            return editField(
                                context,
                                "Select role",
                                ImagePath.work,
                                lighttext,
                                true,
                                ImagePath.dropdown, () {
                              showCustomBottomSheet(context, (selectedRole) {
                                selectedRoleNotifier.value = selectedRole;
                                BlocProvider.of<EmployeeBloc>(context)
                                    .add(UpdateSelectedRole(selectedRole));
                              }, [
                                "Product Designer",
                                "Flutter Developer",
                                "QA Tester",
                                "Product Owner"
                              ]);
                            }, (value) {
                              selectedRole = value;
                            }, initialValue: selectedRole);
                          }),
                      gapH(23),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: editField(
                              context,
                              "Today",
                              ImagePath.calendar,
                              lighttext,
                              false,
                              null,
                              () {
                                showCalendarPopup(context, false,
                                    (selectedDate) {
                                  presDate = DateFormat('dd-MM-yyyy')
                                      .format(selectedDate!);
                                });
                              },
                              (value) {
                                presDate = value;
                              },
                              initialValue: presDate,
                              isDate: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a date';
                                }
                                if (!RegExp(r'^\d{2}-\d{2}-\d{4}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a date in dd-mm-yyyy format';
                                }
                                return null;
                              },
                            ),
                          ),
                          gapW(16),
                          Flexible(
                            flex: 0,
                            child: SvgPicture.asset(ImagePath.rightarrow),
                          ),
                          gapW(16),
                          Expanded(
                            child: editField(
                              context,
                              "End Date",
                              ImagePath.calendar,
                              lighttext,
                              false,
                              null,
                              () {
                                showCalendarPopup(context, true,
                                    (selectedDate) {
                                  endDate = DateFormat('dd-MM-yyyy')
                                      .format(selectedDate!);
                                });
                              },
                              (value) {
                                endDate = value;
                              },
                              initialValue: endDate,
                              isDate: true,
                              isRequired: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Please fill all the fields.'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  return 'Please enter a date';
                                }
                                if (!RegExp(r'^\d{2}-\d{2}-\d{4}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a date in dd-mm-yyyy format';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Divider(color: divider),
                gapH(5),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      customButton(context, () {
                        if (name.isEmpty ||
                            presDate.isEmpty ||
                            selectedRoleNotifier.value.isEmpty ||
                            endDate.isNotEmpty &&
                                DateFormat('dd-MM-yyyy')
                                    .parse(endDate)
                                    .isBefore(DateFormat('dd-MM-yyyy')
                                        .parse(presDate))) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please fill all required fields and ensure the end date is not smaller than the present date.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          if (formKey.currentState!.validate()) {
                            EmployeeModel updatedEmployee = EmployeeModel(
                              id: id,
                              name: name,
                              role: selectedRoleNotifier.value,
                              presentDate: presDate,
                              endDate: endDate,
                            );
                            BlocProvider.of<EmployeeBloc>(context)
                                .add(EditEmp(employee: updatedEmployee));
                            Navigator.pushNamed(context, '/');
                          }
                        }
                      }, "Save", theme, white, 73.0, theme),
                      gapW(16),
                      customButton(context, () {
                        context.go('/');
                      }, "Cancel", lightblue, theme, 73.0, lightblue),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
