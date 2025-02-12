import 'package:employee_manager/data/employee_model.dart';
import 'package:employee_manager/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';

Text customText(String txt, double size, Color clr, FontWeight weight) {
  return Text(
    txt,
    style: TextStyle(
        color: clr, fontSize: size, fontWeight: weight, fontFamily: "Roboto"),
  );
}

//screen size
SizedBox gapH(double value) => SizedBox(height: value);
SizedBox gapW(double value) => SizedBox(width: value);
screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

//current employee container
Container currentEmpContainer(
  BuildContext context,
  EmployeeModel usr,
) {
  return Container(
    height: 110,
    width: screenWidth(context),
    decoration: BoxDecoration(color: white, border: Border.all(color: divider)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(usr.name, 16, theme, FontWeight.w500),
          gapH(6),
          customText(usr.role, 14, lighttext, FontWeight.w400),
          gapH(6),
          customText(usr.presentDate, 14, lighttext, FontWeight.w400),
        ],
      ),
    ),
  );
}

// previous employee
Container previousEmpContainer(
  BuildContext context,
  EmployeeModel pusr,
) {
  return Container(
    height: 110,
    width: screenWidth(context),
    decoration: BoxDecoration(color: white, border: Border.all(color: divider)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(pusr.name, 16, theme, FontWeight.w500),
          gapH(6),
          customText(pusr.role, 14, lighttext, FontWeight.w400),
          gapH(6),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              customText(pusr.presentDate, 14, lighttext, FontWeight.w400),
              gapW(3),
              customText("-", 14, lighttext, FontWeight.w400),
              gapW(3),
              customText(pusr.endDate, 14, lighttext, FontWeight.w400),
            ],
          ),
        ],
      ),
    ),
  );
}

//text container
Container textContainer(BuildContext context, txt) {
  return Container(
    height: 56,
    width: MediaQuery.of(context).size.height,
    color: container,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: customText(txt, 16, theme, FontWeight.w500),
    ),
  );
}

//add employeeTextfield
TextFormField customField(
  BuildContext context,
  String txt,
  String image,
  Color clr,
  bool showSuffix,
  String? sufimag,
  VoidCallback? clk,
  void Function(String) onChanged, {
  TextEditingController? controller,
  String? initialValue,
  String? Function(String?)? validator,
  bool isRequired = true,
  bool isDate = false,
  void Function(String)? onSelected,
}) {
  controller ??= TextEditingController(text: initialValue);
  if (initialValue != null) {
    controller.text = initialValue;
  }

  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 7.0),
      filled: true,
      fillColor: Colors.white,
      hintText: txt,
      prefixIcon: GestureDetector(
        onTap: () {
          if (clk != null) {
            clk();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.5),
          child: SvgPicture.asset(image),
        ),
      ),
      suffixIcon: showSuffix
          ? GestureDetector(
              onTap: clk,
              child: Padding(
                padding: const EdgeInsets.all(15.5),
                child: SvgPicture.asset(sufimag!),
              ),
            )
          : null,
      hintStyle: TextStyle(color: clr, fontSize: 16, fontFamily: 'Roboto'),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    ),
    onChanged: onChanged,
    validator: (value) {
      if (isRequired && (validator != null)) {
        return validator(value);
      }
      return null;
    },
    inputFormatters: isDate
        ? [
            FilteringTextInputFormatter.deny(RegExp(r'[^0-9-]')),
            LengthLimitingTextInputFormatter(10),
            DateInputFormatter(),
          ]
        : null,
  );
}

//edit textfiled
TextFormField editField(
  BuildContext context,
  String txt,
  String image,
  Color clr,
  bool showSuffix,
  String? sufimag,
  VoidCallback? clk,
  void Function(String) onChanged, {
  String? initialValue,
  String? Function(String?)? validator,
  bool isRequired = true,
  bool isDate = false,
}) {
  TextEditingController controller = TextEditingController(text: initialValue);
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 7.0),
      filled: true,
      fillColor: Colors.white,
      hintText: txt,
      prefixIcon: GestureDetector(
        onTap: () {
          if (clk != null) {
            clk();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(15.5),
          child: SvgPicture.asset(image),
        ),
      ),
      suffixIcon: showSuffix
          ? GestureDetector(
              onTap: clk,
              child: Padding(
                padding: const EdgeInsets.all(15.5),
                child: SvgPicture.asset(sufimag!),
              ),
            )
          : null,
      hintStyle: TextStyle(color: clr, fontSize: 16, fontFamily: 'Roboto'),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    ),
    onChanged: onChanged,
    validator: (value) {
      if (isRequired && (validator != null)) {
        return validator(value);
      }
      return null;
    },
    inputFormatters: isDate
        ? [
            FilteringTextInputFormatter.deny(RegExp(r'[^0-9-]')),
            LengthLimitingTextInputFormatter(10),
            DateInputFormatter(),
          ]
        : null,
  );
}

// Formatter to ensure the date format is dd-mm-yyyy
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (oldValue.text.length >= newValue.text.length) {
      return newValue;
    }

    if (text.length == 2 || text.length == 5) {
      text += '-';
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

//custombutton
InkWell customButton(
    BuildContext context, clk, txt, btnclr, txtclr, width, bodrclr) {
  return InkWell(
    onTap: clk,
    child: Container(
      height: 40,
      width: width,
      decoration: BoxDecoration(
          color: btnclr,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(color: bodrclr)),
      child: Center(
        child: customText(
          txt,
          14.0,
          txtclr,
          FontWeight.w500,
        ),
      ),
    ),
  );
}

//bottomsheet
void showCustomBottomSheet(
    BuildContext context, Function(String) onSelectRole, List<String> roles) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          width: screenWidth(context),
          decoration: const BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: roles
                .map((role) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          onSelectRole(role);
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 52,
                          width: screenWidth(context),
                          decoration: const BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Center(
                            child: customText(
                              role,
                              16,
                              black,
                              FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const Divider(color: divider),
                    ],
                  );
                })
                .expand((element) => [element, gapH(1)])
                .toList(),
          ),
        ),
      );
    },
  );
}
