// custom_calendar_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

part 'custom_calendar_state.dart';

class CustomCalendarCubit extends Cubit<CustomCalendarState> {
  CustomCalendarCubit({required bool isFromPicker, required bool isToPicker})
      : super(CustomCalendarState(
          selectedDate: DateTime.now(),
          isFromPicker: isFromPicker,
          isToPicker: isToPicker,
        ));

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void selectPresetDate(String type) {
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
      case 'No Date':
        emit(state.copyWith(selectedDate: null));
        return;
      default:
        return;
    }
    emit(state.copyWith(selectedDate: newDate));
  }
}
