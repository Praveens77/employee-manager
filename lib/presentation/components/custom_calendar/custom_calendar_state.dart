part of 'custom_calendar_cubit.dart';

class CustomCalendarState {
  final DateTime? selectedDate;
  final bool isFromPicker;
  final bool isToPicker;

  CustomCalendarState({
    required this.selectedDate,
    required this.isFromPicker,
    required this.isToPicker,
  });

  CustomCalendarState copyWith({
    DateTime? selectedDate,
    bool? isFromPicker,
    bool? isToPicker,
  }) {
    return CustomCalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      isFromPicker: isFromPicker ?? this.isFromPicker,
      isToPicker: isToPicker ?? this.isToPicker,
    );
  }
}
