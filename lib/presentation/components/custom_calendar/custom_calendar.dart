import 'package:employee_manager/utils/app_colors.dart';
import 'package:employee_manager/utils/app_images.dart';
import 'package:employee_manager/utils/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'custom_calendar_cubit.dart';

class CustomCalendar extends StatelessWidget {
  final bool isFromPicker;
  final bool isToPicker;
  final Function(DateTime?) onSelectDate;
  final bool disablePreviousDates;

  const CustomCalendar({
    super.key,
    required this.isFromPicker,
    required this.isToPicker,
    required this.onSelectDate,
    this.disablePreviousDates = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomCalendarCubit(
          isFromPicker: isFromPicker, isToPicker: isToPicker),
      child: BlocBuilder<CustomCalendarCubit, CustomCalendarState>(
        builder: (context, state) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 450, 
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isFromPicker || isToPicker)
                      _buildPresetButtons(context, state),
                    _buildCalendarHeader(context, state),
                    _buildDaysRow(),
                    _buildCalendar(context, state),
                    const Divider(height: 20, color: txtFieldBorder),
                    _buildBottomSection(context, state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPresetButtons(BuildContext context, CustomCalendarState state) {
    List<String> buttons = isFromPicker
        ? ['Today', 'Next Monday', 'Next Tuesday', 'After 1 week']
        : ['No Date', 'Today'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons.sublist(0, 2).map((label) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _presetButton(context, state, label),
              ),
            );
          }).toList(),
        ),
        if (isFromPicker) const SizedBox(height: 8),
        if (isFromPicker)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttons.sublist(2, 4).map((label) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _presetButton(context, state, label),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _presetButton(
      BuildContext context, CustomCalendarState state, String label) {
    bool isNoDateSelected = label == "No Date" && state.selectedDate == null;
    bool isSelected = label != "No Date" &&
        state.selectedDate != null &&
        isSameDate(state.selectedDate!, _getPresetDate(label));

    bool shouldHighlight = isNoDateSelected || isSelected;

    return GestureDetector(
      onTap: () {
        if (label == "No Date") {
          context.read<CustomCalendarCubit>().clearDate();
          onSelectDate(null);
        } else {
          DateTime presetDate = _getPresetDate(label);
          context.read<CustomCalendarCubit>().selectPresetDate(label);
          onSelectDate(presetDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: shouldHighlight ? theme : lightBlue,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: shouldHighlight ? white : theme,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, CustomCalendarState state) {
    String bottomText;
    if (state.selectedDate == null) {
      bottomText = "No Date";
    } else {
      bottomText = isSameDate(state.selectedDate!, DateTime.now())
          ? "Today"
          : DateFormat('d MMM yyyy').format(state.selectedDate!);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(ImagePath.calendar),
              gapW(10),
              customText(bottomText, 14, black, FontWeight.w500)
            ],
          ),
          Row(
            children: [
              customButton(context, () {
                Navigator.pop(context);
              }, "Cancel", lightBlue, theme, 73.0, lightBlue),
              gapW(16),
              customButton(context, () {
                onSelectDate(state.selectedDate);
                Navigator.pop(context);
              }, "Save", theme, white, 73.0, theme),
            ],
          ),
        ],
      ),
    );
  }

  DateTime _getPresetDate(String type) {
    DateTime now = DateTime.now();
    switch (type) {
      case 'Today':
        return now;
      case 'Next Monday':
        return now.add(Duration(days: (8 - now.weekday) % 7));
      case 'Next Tuesday':
        return now.add(Duration(days: (9 - now.weekday) % 7));
      case 'After 1 week':
        return now.add(const Duration(days: 7));
      default:
        return now;
    }
  }

  Widget _buildCalendarHeader(BuildContext context, CustomCalendarState state) {
    DateTime todayMonth = DateTime.now().copyWith(day: 1);
    bool disablePrev =
        disablePreviousDates && !state.displayedMonth.isAfter(todayMonth);

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: disablePrev
                ? null
                : () => context
                    .read<CustomCalendarCubit>()
                    .changeMonth(-1, disablePreviousDates),
            child: SizedBox(
              width: 15,
              height: 15,
              child: SvgPicture.asset(
                ImagePath.backward,
                colorFilter: ColorFilter.mode(
                    disablePrev ? lightText.withOpacity(0.3) : lightText,
                    BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            DateFormat.yMMMM().format(state.displayedMonth),
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: black),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => context
                .read<CustomCalendarCubit>()
                .changeMonth(1, disablePreviousDates),
            child: SizedBox(
              width: 15,
              height: 15,
              child: SvgPicture.asset(
                ImagePath.forward,
                colorFilter: const ColorFilter.mode(lightText, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysRow() {
    List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days
            .map((day) => Text(
                  day,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, color: black),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context, CustomCalendarState state) {
    return GridView.builder(
      key: Key(state.displayedMonth.toString()),
      shrinkWrap: true,
      itemCount: 42,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        DateTime firstDayOfMonth =
            DateTime(state.displayedMonth.year, state.displayedMonth.month, 1);
        int firstWeekday = firstDayOfMonth.weekday;
        DateTime calendarDate =
            firstDayOfMonth.add(Duration(days: index - firstWeekday));

        bool isCurrentMonth = calendarDate.month == state.displayedMonth.month;

        bool isSelected = state.selectedDate != null &&
            isSameDate(state.selectedDate!, calendarDate);

        bool isToday = isSameDate(calendarDate, DateTime.now());
        bool isDisabled = disablePreviousDates &&
            calendarDate.isBefore(DateTime.now()) &&
            !isToday;
        bool isOtherMonth = !isCurrentMonth;

        return GestureDetector(
          onTap: (isDisabled || isOtherMonth)
              ? null
              : () =>
                  context.read<CustomCalendarCubit>().selectDate(calendarDate),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected ? theme : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday
                  ? Border.all(color: theme, width: 2)
                  : Border.all(color: Colors.transparent),
            ),
            child: Center(
              child: Text(
                calendarDate.day.toString(),
                style: TextStyle(
                  color: isDisabled
                      ? lightText
                      : isSelected
                          ? white
                          : isOtherMonth
                              ? lightText
                              : black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
