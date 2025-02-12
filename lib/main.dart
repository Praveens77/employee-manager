import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:employee_manager/utils/app_sizes.dart';
import 'package:employee_manager/bloc/employee_bloc.dart';
import 'package:employee_manager/presentation/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => EmployeeBloc()),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Employee Manager',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
              textTheme: TextTheme(
                bodyLarge: TextStyle(fontSize: AppSizes.fontL),
                bodyMedium: TextStyle(fontSize: AppSizes.fontM),
                bodySmall: TextStyle(fontSize: AppSizes.fontS),
              ),
            ),
            routerConfig: appRouter,
          ),
        );
      },
    );
  }
}
