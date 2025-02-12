import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSizes {
  static void init(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812), 
      minTextAdapt: true,
      splitScreenMode: true,
    );
  }

  static double get paddingXS => 4.w;
  static double get paddingS => 8.w;
  static double get paddingM => 16.w;
  static double get paddingL => 24.w;
  static double get paddingXL => 32.w;

  static double get spaceXS => 4.h;
  static double get spaceS => 8.h;
  static double get spaceM => 16.h;
  static double get spaceL => 24.h;
  static double get spaceXL => 32.h;

  static double get radiusS => 8.r;
  static double get radiusM => 16.r;
  static double get radiusL => 24.r;

  static double get fontXS => 12.sp;
  static double get fontS => 14.sp;
  static double get fontM => 16.sp;
  static double get fontL => 18.sp;
  static double get fontXL => 22.sp;

  static double get buttonHeight => 48.h;

  static double get iconS => 16.w;
  static double get iconM => 24.w;
  static double get iconL => 32.w;

  static double get appBarHeight => 56.h;
}
