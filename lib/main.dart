import 'package:employee_manager/bloc/bloc.dart';
import 'package:employee_manager/screens/emp_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: ((context) => EmployeeBloc()))],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RealTime Innovations',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const EmployeeList(),
      ),
    );
  }
}
