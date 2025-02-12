// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';
import 'package:employee_manager/bloc/bloc.dart';
import 'package:employee_manager/bloc/model.dart';
import 'package:employee_manager/common/calendar.dart';
import 'package:employee_manager/common/color.dart';
import 'package:employee_manager/common/image.dart';
import 'package:employee_manager/common/widget.dart';
import 'package:employee_manager/screens/emp_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddEmployee extends StatelessWidget {
  const AddEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    String name = '';
    String presDate = '';
    String endDate = '';
    final formKey = GlobalKey<FormState>();
    final uuid = Uuid();
    final id = uuid.v4();
    final selectedRoleNotifier = ValueNotifier<String>('');

    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: theme,
            title:
                customText("Add Employee Details", 18, white, FontWeight.w500),
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
                      customField(
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
                          return customField(
                            context,
                            "Select role",
                            ImagePath.work,
                            lighttext,
                            true,
                            ImagePath.dropdown,
                            () {
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
                            },
                            (value) {
                              selectedRole = value;
                            },
                            initialValue: selectedRole,
                          );
                        },
                      ),
                      gapH(23),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: customField(
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
                            ),
                          ),
                          gapW(16),
                          Flexible(
                            flex: 0,
                            child: SvgPicture.asset(ImagePath.rightarrow),
                          ),
                          gapW(16),
                          Expanded(
                            child: customField(
                              context,
                              "No date",
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
                      customButton(context, () async {
                        if (name.isEmpty ||
                            presDate.isEmpty ||
                            selectedRoleNotifier.value.isEmpty ||
                            endDate.isNotEmpty &&
                                DateFormat('dd-MM-yyyy')
                                    .parse(endDate)
                                    .isBefore(DateTime.now())) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please fill all required fields and ensure the end date is not smaller than the present date.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          if (formKey.currentState!.validate()) {
                            EmployeeModel newEmployee = EmployeeModel(
                              id: id,
                              name: name,
                              selectedRole: selectedRoleNotifier.value,
                              presentdate: presDate,
                              enddate: endDate,
                            );

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            List<String> employees =
                                prefs.getStringList('employees') ?? [];
                            employees.add(json.encode(newEmployee.toJson()));
                            await prefs.setStringList('employees', employees);

                            BlocProvider.of<EmployeeBloc>(context)
                                .add(AddEmp(employee: newEmployee));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EmployeeList(),
                              ),
                            );
                          }
                        }
                      }, "Save", theme, white, 73.0, theme),
                      gapW(16),
                      customButton(context, () {
                        Navigator.pop(context);
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
