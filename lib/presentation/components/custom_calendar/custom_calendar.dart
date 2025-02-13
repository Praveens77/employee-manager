import 'package:employee_manager/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      create: (_) => CustomCalendarCubit(isFromPicker: isFromPicker, isToPicker: isToPicker),
      child: BlocBuilder<CustomCalendarCubit, CustomCalendarState>(
        builder: (context, state) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isFromPicker || isToPicker) _buildPresetButtons(context, state),
                  _buildCalendar(context, state),
                  _buildBottomSection(context, state),
                ],
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

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: buttons.map((label) {
        bool isSelected = state.selectedDate != null &&
            ((label == 'Today' && isSameDate(state.selectedDate!, DateTime.now())) ||
                (label == 'Next Monday' &&
                    isSameDate(state.selectedDate!,
                        DateTime.now().add(Duration(days: (8 - DateTime.now().weekday) % 7)))) ||
                (label == 'Next Tuesday' &&
                    isSameDate(state.selectedDate!,
                        DateTime.now().add(Duration(days: (9 - DateTime.now().weekday) % 7)))) ||
                (label == 'After 1 week' &&
                    isSameDate(state.selectedDate!, DateTime.now().add(const Duration(days: 7)))));

        return GestureDetector(
          onTap: () => context.read<CustomCalendarCubit>().selectPresetDate(label),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? theme : lightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? white : theme,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendar(BuildContext context, CustomCalendarState state) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          DateFormat.yMMMM().format(state.selectedDate ?? DateTime.now()),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: black),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          itemCount: 42,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            DateTime firstDayOfMonth =
                DateTime(state.selectedDate!.year, state.selectedDate!.month, 1);
            int firstWeekday = firstDayOfMonth.weekday;
            DateTime calendarDate = firstDayOfMonth.add(Duration(days: index - firstWeekday));

            bool isSelected = state.selectedDate != null && isSameDate(state.selectedDate!, calendarDate);
            bool isDisabled = disablePreviousDates && calendarDate.isBefore(DateTime.now());

            return GestureDetector(
              onTap: isDisabled
                  ? null
                  : () => context.read<CustomCalendarCubit>().selectDate(calendarDate),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? theme : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? theme : txtFieldBorder,
                  ),
                ),
                child: Center(
                  child: Text(
                    calendarDate.day.toString(),
                    style: TextStyle(
                      color: isDisabled ? lightText : isSelected ? white : black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomSection(BuildContext context, CustomCalendarState state) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.calendar_today, color: theme, size: 20),
            const SizedBox(width: 8),
            Text(
              state.selectedDate != null
                  ? DateFormat('d MMM yyyy').format(state.selectedDate!)
                  : "No Date",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: black),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: lightText, fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                onSelectDate(state.selectedDate);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Save", style: TextStyle(color: white, fontSize: 16)),
            ),
          ],
        ),
      ],
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}
