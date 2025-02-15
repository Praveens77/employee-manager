import 'package:flutter_bloc/flutter_bloc.dart';

part 'custom_calendar_state.dart';

class CustomCalendarCubit extends Cubit<CustomCalendarState> {
  CustomCalendarCubit({required bool isFromPicker, required bool isToPicker})
      : super(CustomCalendarState(
          selectedDate: DateTime.now(),
          displayedMonth: DateTime.now(),
          isFromPicker: isFromPicker,
          isToPicker: isToPicker,
        ));

  void selectDate(DateTime date) {
    emit(state.copyWith(
      selectedDate: date,
      isNoDateSelected: false,
    ));
  }

  void selectPresetDate(String type) {
    if (type == 'No Date') {
      clearDate();
      return;
    }

    DateTime now = DateTime.now();
    DateTime newDate;
    switch (type) {
      case 'Today':
        newDate = now;
        break;
      case 'Next Monday':
        newDate = now.add(Duration(days: (8 - now.weekday) % 7));
        break;
      case 'Next Tuesday':
        newDate = now.add(Duration(days: (9 - now.weekday) % 7));
        break;
      case 'After 1 week':
        newDate = now.add(const Duration(days: 7));
        break;
      default:
        return;
    }

    emit(state.copyWith(
      selectedDate: newDate,
      displayedMonth: newDate,
      isNoDateSelected: false,
    ));
  }

  void clearDate() {
    emit(state.copyWith(
      selectedDate: null,
      isNoDateSelected: true,
      displayedMonth: DateTime.now(),
    ));
  }

  void changeMonth(int offset, bool disablePreviousDates) {
    DateTime newMonth = DateTime(
        state.displayedMonth.year, state.displayedMonth.month + offset, 1);
    DateTime todayMonth = DateTime.now().copyWith(day: 1);

    if (disablePreviousDates && newMonth.isBefore(todayMonth)) {
      newMonth = todayMonth;
    }

    emit(state.copyWith(displayedMonth: newMonth));
  }
}
