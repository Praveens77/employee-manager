// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:employee_manager/bloc/employee_bloc.dart';
import 'package:employee_manager/data/employee_model.dart';
import 'package:employee_manager/presentation/components/custom_calendar/custom_calendar.dart';
import 'package:employee_manager/utils/app_colors.dart';
import 'package:employee_manager/utils/app_images.dart';
import 'package:employee_manager/utils/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddEmployee extends StatelessWidget {
  const AddEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    String name = '';
    final formKey = GlobalKey<FormState>();
    const uuid = Uuid();
    final id = uuid.v4();
    final selectedRoleNotifier = ValueNotifier<String>('');
    final presDateNotifier = ValueNotifier<String>('');
    final endDateNotifier = ValueNotifier<String>('');
    final isNoDateSelected = ValueNotifier<bool>(false);

    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: white,
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
                        lightText,
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
                            lightText,
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
                                "Product Owner",
                                "Team Lead"
                              ]);
                            },
                            (value) {
                              selectedRole = value;
                            },
                            initialValue: selectedRole,
                            disabled: true,
                          );
                        },
                      ),
                      gapH(23),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ValueListenableBuilder<String>(
                              valueListenable: presDateNotifier,
                              builder: (context, presDate, _) {
                                return customField(
                                  context,
                                  "Today",
                                  ImagePath.calendar,
                                  lightText,
                                  false,
                                  null,
                                  () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => CustomCalendar(
                                        isFromPicker: true,
                                        isToPicker: false,
                                        disablePreviousDates: false,
                                        onSelectDate: (selectedDate) {
                                          if (selectedDate != null) {
                                            presDateNotifier.value =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(selectedDate);
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  (value) {},
                                  initialValue: presDate,
                                  isDate: true,
                                );
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
                            child: ValueListenableBuilder<String>(
                              valueListenable: endDateNotifier,
                              builder: (context, endDate, _) {
                                return ValueListenableBuilder<bool>(
                                  valueListenable: isNoDateSelected,
                                  builder: (context, noDate, _) {
                                    return customField(
                                      context,
                                      noDate ? "No date" : "Select Date",
                                      ImagePath.calendar,
                                      lightText,
                                      false,
                                      null,
                                      () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => CustomCalendar(
                                            isFromPicker: false,
                                            isToPicker: true,
                                            disablePreviousDates: false,
                                            onSelectDate: (selectedDate) {
                                              if (selectedDate == null) {
                                                isNoDateSelected.value = true;
                                                endDateNotifier.value = "";
                                              } else {
                                                isNoDateSelected.value = false;
                                                endDateNotifier.value =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(selectedDate);
                                              }
                                            },
                                          ),
                                        );
                                      },
                                      (value) {},
                                      initialValue:
                                          noDate ? "No date" : endDate,
                                      isDate: true,
                                      isRequired: false,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Divider(thickness: 2, color: background),
                gapH(5),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      customButton(context, () {
                        context.go('/');
                      }, "Cancel", lightBlue, theme, 73.0, lightBlue),
                      gapW(16),
                      customButton(context, () async {
                        final presDate = presDateNotifier.value;
                        final endDate = endDateNotifier.value;

                        if (name.isEmpty ||
                            presDate.isEmpty ||
                            selectedRoleNotifier.value.isEmpty ||
                            (endDate.isNotEmpty &&
                                DateFormat('dd-MM-yyyy')
                                    .parse(endDate)
                                    .isBefore(DateFormat('dd-MM-yyyy')
                                        .parse(presDate)))) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: customText(
                                  'Please fill all required fields and ensure the end date is after the present date.',
                                  15,
                                  white,
                                  FontWeight.w400),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          if (formKey.currentState!.validate()) {
                            EmployeeModel newEmployee = EmployeeModel(
                              id: id,
                              name: name,
                              role: selectedRoleNotifier.value,
                              presentDate: presDate,
                              endDate: endDate,
                            );

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            List<String> employees =
                                prefs.getStringList('employees') ?? [];
                            employees.add(json.encode(newEmployee.toJson()));
                            await prefs.setStringList('employees', employees);

                            BlocProvider.of<EmployeeBloc>(context)
                                .add(AddEmp(employee: newEmployee));
                            context.go('/');
                          }
                        }
                      }, "Save", theme, white, 73.0, theme),
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
