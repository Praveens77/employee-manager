part of 'custom_calendar_cubit.dart';

class CustomCalendarState {
  final DateTime? selectedDate;
  final DateTime displayedMonth;
  final bool isFromPicker;
  final bool isToPicker;
  final bool isNoDateSelected;

  CustomCalendarState({
    required this.selectedDate,
    required this.displayedMonth,
    required this.isFromPicker,
    required this.isToPicker,
    this.isNoDateSelected = false,
  });

  CustomCalendarState copyWith({
    DateTime? selectedDate,
    DateTime? displayedMonth,
    bool? isFromPicker,
    bool? isToPicker,
    bool? isNoDateSelected,
  }) {
    return CustomCalendarState(
      selectedDate: selectedDate,
      displayedMonth: displayedMonth ?? this.displayedMonth,
      isFromPicker: isFromPicker ?? this.isFromPicker,
      isToPicker: isToPicker ?? this.isToPicker,
      isNoDateSelected: isNoDateSelected ?? this.isNoDateSelected,
    );
  }
}
