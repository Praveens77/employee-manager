import 'package:employee_manager/presentation/components/custom_calendar/custom_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:employee_manager/bloc/employee_bloc.dart';
import 'package:employee_manager/data/employee_model.dart';
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
    final formKey = GlobalKey<FormState>();
    final selectedRoleNotifier = ValueNotifier<String>(employee.role);
    final presDateNotifier = ValueNotifier<String>(employee.presentDate);
    final endDateNotifier = ValueNotifier<String>(employee.endDate);
    final isNoDateSelected = ValueNotifier<bool>(false);

    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: theme,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText("Edit Employee Details", 18, white, FontWeight.w500),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          backgroundColor: white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          title: customText(
                              "Confirm Deletion", 18, black, FontWeight.w500),
                          content: regularText(
                              "Are you sure you want to delete this employee?",
                              15,
                              black,
                              FontWeight.w400),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: customText(
                                  "Cancel", 16, theme, FontWeight.w400),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                BlocProvider.of<EmployeeBloc>(context)
                                    .add(DelEmp(employee: employee));
                                context.go('/');
                              },
                              child: customText(
                                  "Confirm", 16, red, FontWeight.w400),
                            ),
                          ],
                        );
                      },
                    );
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
                          return editField(
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
                                return editField(
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
                                    return editField(
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
                                            disablePreviousDates: true,
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
                      customButton(context, () {
                        if (endDateNotifier.value.isNotEmpty &&
                            DateFormat('dd-MM-yyyy')
                                .parse(endDateNotifier.value)
                                .isBefore(DateFormat('dd-MM-yyyy')
                                    .parse(presDateNotifier.value))) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: customText(
                                  "End date must be after the present date.",
                                  15,
                                  white,
                                  FontWeight.w400),
                            ),
                          );
                          return;
                        }
                        if (formKey.currentState!.validate()) {
                          EmployeeModel updatedEmployee = EmployeeModel(
                            id: id,
                            name: name,
                            role: selectedRoleNotifier.value,
                            presentDate: presDateNotifier.value,
                            endDate: endDateNotifier.value,
                          );
                          BlocProvider.of<EmployeeBloc>(context)
                              .add(EditEmp(employee: updatedEmployee));
                          context.go('/');
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
