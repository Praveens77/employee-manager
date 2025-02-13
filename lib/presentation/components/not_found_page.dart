import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:employee_manager/utils/app_colors.dart';
import 'package:employee_manager/utils/app_images.dart';
import 'package:employee_manager/utils/common_methods.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customText("Page Not Found", 18, black, FontWeight.w600),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(ImagePath.logo, height: 200),
              gapH(20),
              customText(
                "Oops! This page is playing hide & seek.",
                18,
                theme,
                FontWeight.w600,
              ),
              gapH(10),
              customText(
                "The page you are looking for doesn’t exist or has been moved.",
                14,
                lightText,
                FontWeight.normal,
              ),
              gapH(30),
              customButton(
                context,
                () => context.go('/'),
                "Back to Home",
                theme,
                white,
                140.0,
                theme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
