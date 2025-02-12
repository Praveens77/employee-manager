import 'package:employee_manager/bloc/employee_bloc.dart';
import 'package:employee_manager/utils/app_colors.dart';
import 'package:employee_manager/utils/app_images.dart';
import 'package:employee_manager/utils/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class TodayCalendar extends StatefulWidget {
  final Function(DateTime) onSelectDate;

  const TodayCalendar({Key? key, required this.onSelectDate}) : super(key: key);

  @override
  _TodayCalendarState createState() => _TodayCalendarState();
}

class _TodayCalendarState extends State<TodayCalendar> {
  late DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context) / 1.47,
      width: screenWidth(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                calButton(
                  context,
                  "Today",
                  () {
                    setState(() {
                      _selectedDate = DateTime.now();
                    });
                    widget.onSelectDate(_selectedDate);
                  },
                  _selectedDate,
                ),
                gapW(16),
                calButton(
                  context,
                  "Next Monday",
                  () {
                    setState(() {
                      _selectedDate = _getNextWeekday(DateTime.monday);
                    });
                    widget.onSelectDate(_selectedDate);
                  },
                  _selectedDate,
                ),
              ],
            ),
            gapH(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                calButton(
                  context,
                  "Next Tuesday",
                  () {
                    setState(() {
                      _selectedDate = _getNextWeekday(DateTime.tuesday);
                    });
                    widget.onSelectDate(_selectedDate);
                  },
                  _selectedDate,
                ),
                gapW(16),
                calButton(
                  context,
                  "After 1 week",
                  () {
                    setState(() {
                      _selectedDate = DateTime.now().add(Duration(days: 7));
                    });
                    widget.onSelectDate(_selectedDate);
                  },
                  _selectedDate,
                ),
              ],
            ),
            gapH(15),
            BlocProvider<EmployeeBloc>(
              create: (context) => EmployeeBloc(),
              child: TableCal(
                selectedDate: _selectedDate,
                onDaySelected: (day, focusedDay) {
                  setState(() {
                    _selectedDate = day;
                  });
                  widget.onSelectDate(day);
                },
                onSelectDate: widget.onSelectDate,
                onDateSelected: (DateTime selectedDate) {
                  // Do something with the selected date
                },
              ),
            ),
            gapH(11),
            const Divider(color: divider),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(ImagePath.calendar),
                    gapW(16),
                    customText(
                      DateFormat('d MMM yyyy').format(_selectedDate),
                      16,
                      black,
                      FontWeight.w400,
                    ),
                  ],
                ),
                gapW(screenWidth(context) / 30),
                Expanded(
                  child: customButton(context, () {
                    Navigator.pop(context);
                  }, "Cancel", lightblue, theme, 73.0, lightblue),
                ),
                gapW(16),
                Expanded(
                  child: customButton(context, () {
                    Navigator.pop(context);
                    BlocProvider.of<EmployeeBloc>(context).add(
                        UpdateSelectedStartDate(_selectedDate.toString()));
                  }, "Save", theme, white, 73.0, theme),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DateTime _getNextWeekday(int weekday) {
    final now = DateTime.now();
    final daysUntilNextWeekday = (weekday - now.weekday + 7) % 7;
    return now.add(Duration(days: daysUntilNextWeekday));
  }

  Widget calButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
    DateTime selectedDate,
  ) {
    final isSelected = _isButtonSelected(text, selectedDate);

    return InkWell(
      onTap: onPressed,
      child: Container(
        height: MediaQuery.of(context).size.height / 20,
        width: MediaQuery.of(context).size.width / 3.2,
        decoration: BoxDecoration(
          color: isSelected ? lightblue : theme,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? theme : white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  bool _isButtonSelected(String buttonLabel, DateTime selectedDate) {
    switch (buttonLabel) {
      case "Today":
        return _isSameDay(selectedDate, DateTime.now());
      case "Next Monday":
        return selectedDate.weekday == DateTime.monday;
      case "Next Tuesday":
        return selectedDate.weekday == DateTime.tuesday;
      case "After 1 week":
        final nextWeek = DateTime.now().add(Duration(days: 7));
        return _isSameDay(selectedDate, nextWeek);
      default:
        return false;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class TableCal extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onSelectDate;
  final Function(DateTime) onDateSelected;

  const TableCal({
    required this.selectedDate,
    required this.onDaySelected,
    required this.onSelectDate,
    required this.onDateSelected,
    Key? key,
  }) : super(key: key);

  @override
  _TableCalState createState() => _TableCalState();
}

class _TableCalState extends State<TableCal> {
  late DateTime _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.selectedDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final EmployeeBloc employeeBloc = BlocProvider.of<EmployeeBloc>(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.45,
      child: TableCalendar(
        rowHeight: 41,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronIcon: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset(
                ImagePath.backward,
              ),
            ),
          ),
          rightChevronIcon: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset(
                ImagePath.forward,
              ),
            ),
          ),
        ),
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2050, 3, 14),
        focusedDay: _selectedDate,
        selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
        onDaySelected: (selectedDate, focusedDate) {
          setState(() {
            _selectedDate = selectedDate;
          });
          widget.onDaySelected(selectedDate, focusedDate);
          employeeBloc.add(SelectDateEvent(selectedDate));
          widget.onSelectDate(selectedDate);
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme,
          ),
          todayDecoration: BoxDecoration(
            border: Border.all(color: theme),
            shape: BoxShape.circle,
            color: white,
          ),
          todayTextStyle: TextStyle(color: theme),
        ),
      ),
    );
  }
}

void showCalendarPopup(BuildContext context, bool isEndDateCalender,
    Function(DateTime) onSelectDate) {
  DateTime currentDate = DateTime.now();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: isEndDateCalender
              ? EndDateCalendar(
                  onSelectDate: onSelectDate,
                  currentDate: currentDate,
                )
              : TodayCalendar(onSelectDate: onSelectDate),
        ),
      );
    },
  );
}

class EndDateCalendar extends StatefulWidget {
  final Function(DateTime) onSelectDate;
  final DateTime currentDate;

  const EndDateCalendar({
    Key? key,
    required this.onSelectDate,
    required this.currentDate,
  }) : super(key: key);

  @override
  _EndDateCalendarState createState() => _EndDateCalendarState();
}

class _EndDateCalendarState extends State<EndDateCalendar> {
  late DateTime _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.currentDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return endDateCalendar(context, widget.onSelectDate, _selectedDate);
  }

  Widget endDateCalendar(BuildContext context, Function(DateTime) onSelectDate,
      DateTime currentDate) {
    return Container(
      height: screenHeight(context) / 1.55,
      width: screenWidth(context),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                calButton(
                  context,
                  "No date",
                  () {
                    setState(() {
                      _selectedDate = DateTime.now();
                    });
                    onSelectDate(_selectedDate);
                  },
                  _selectedDate,
                ),
                gapW(16),
                calButton(
                  context,
                  "Today",
                  () {
                    setState(() {
                      _selectedDate = DateTime.now();
                    });
                    onSelectDate(_selectedDate);
                  },
                  _selectedDate,
                ),
              ],
            ),
            gapH(25),
            TableCal(
              selectedDate: currentDate,
              onDaySelected: (day, focusedDay) {
                setState(() {
                  _selectedDate = day;
                });
                onSelectDate(day);
              },
              onSelectDate: onSelectDate,
              onDateSelected: (DateTime selectedDate) {
                // Do something with the selected date
              },
            ),
            const Divider(color: divider),
            gapH(11),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(ImagePath.calendar),
                    gapW(16),
                    customText(
                      DateFormat('d MMM yyyy').format(_selectedDate),
                      16,
                      black,
                      FontWeight.w400,
                    ),
                  ],
                ),
                gapW(screenWidth(context) / 30),
                Expanded(
                  child: customButton(context, () {
                    Navigator.pop(context);
                  }, "Cancel", lightblue, theme, 73.0, lightblue),
                ),
                gapW(16),
                Expanded(
                  child: customButton(context, () {
                    Navigator.pop(context);
                    BlocProvider.of<EmployeeBloc>(context).add(
                        UpdateSelectedEndDate(_selectedDate.toString()));
                  }, "Save", theme, white, 73.0, theme),
                ),
              ],
            ),
            gapH(16),
          ],
        ),
      ),
    );
  }

  Widget calButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
    DateTime selectedDate,
  ) {
    final isSelected = _isButtonSelected(text, selectedDate);

    return InkWell(
      onTap: onPressed,
      child: Container(
        height: MediaQuery.of(context).size.height / 20,
        width: MediaQuery.of(context).size.width / 3.2,
        decoration: BoxDecoration(
          color: isSelected ? lightblue : white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? theme : lightblue,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  bool _isButtonSelected(String buttonLabel, DateTime selectedDate) {
    switch (buttonLabel) {
      case "No date":
        return selectedDate == DateTime.now();
      case "Today":
        return selectedDate == DateTime.now();
      default:
        return false;
    }
  }
}

bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

