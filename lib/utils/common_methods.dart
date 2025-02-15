import 'package:employee_manager/data/employee_model.dart';
import 'package:employee_manager/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

Text customText(String txt, double size, Color clr, FontWeight weight) {
  return Text(
    txt,
    style: TextStyle(
      color: clr,
      fontSize: size,
      fontWeight: weight,
      fontFamily: "Roboto",
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

Text regularText(String txt, double size, Color clr, FontWeight weight) {
  return Text(
    txt,
    style: TextStyle(
        color: clr,
        fontSize: size,
        fontWeight: weight,
        fontFamily: "Roboto-Regular"),
  );
}

//screen size
SizedBox gapH(double value) => SizedBox(height: value);
SizedBox gapW(double value) => SizedBox(width: value);
screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

// format current employee date
String formatEmployeeDate(String date) {
  try {
    DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
    return DateFormat("dd MMM, yyyy").format(parsedDate);
  } catch (e) {
    return date;
  }
}

String formatEditDate(String date) {
  try {
    DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
    return DateFormat("dd MMM yyyy").format(parsedDate);
  } catch (e) {
    return date;
  }
}

//current employee container
Container currentEmployeeTab(
  BuildContext context,
  EmployeeModel employee,
) {
  return Container(
    height: 110,
    width: screenWidth(context),
    decoration: const BoxDecoration(
      color: white,
      border: Border(
        bottom: BorderSide(color: background),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(employee.name, 16, black, FontWeight.w500),
          gapH(6),
          regularText(employee.role, 14, lightText, FontWeight.w400),
          gapH(6),
          regularText("From ${formatEmployeeDate(employee.presentDate)}", 12,
              lightText, FontWeight.w400),
        ],
      ),
    ),
  );
}

// previous employee
Container previousEmployeeTab(
  BuildContext context,
  EmployeeModel employee,
) {
  return Container(
    height: 110,
    width: screenWidth(context),
    decoration: const BoxDecoration(
      color: white,
      border: Border(
        bottom: BorderSide(color: background),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(employee.name, 16, black, FontWeight.w500),
          gapH(6),
          regularText(employee.role, 14, lightText, FontWeight.w400),
          gapH(6),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              regularText(formatEmployeeDate(employee.presentDate), 12,
                  lightText, FontWeight.w400),
              gapW(3),
              regularText("-", 12, lightText, FontWeight.w400),
              gapW(3),
              regularText(formatEmployeeDate(employee.endDate), 12, lightText,
                  FontWeight.w400),
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
    width: screenWidth(context),
    color: container,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: customText(txt, 16, theme, FontWeight.w500),
    ),
  );
}

//text container
Container instructionBox(BuildContext context, txt) {
  return Container(
    height: 66,
    width: screenWidth(context),
    color: container,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: customText(txt, 15, lightText, FontWeight.w400),
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
  bool disabled = false,
}) {
  controller ??= TextEditingController(text: initialValue);

  // Format the initial value if it's a date
  String displayValue = isDate && initialValue != null
      ? formatEditDate(initialValue)
      : initialValue ?? "";

  return TextFormField(
    controller: controller,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto-Regular",
    ),
    readOnly: isDate || disabled,
    onTap: isDate || disabled ? clk : null,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 7.0),
      filled: true,
      fillColor: Colors.white,
      hintText: txt,
      prefixIcon: GestureDetector(
        onTap: () {
          if (clk != null) clk();
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
                padding: const EdgeInsets.all(16.5),
                child: SvgPicture.asset(sufimag!),
              ),
            )
          : null,
      hintStyle:
          TextStyle(color: clr, fontSize: 16, fontFamily: 'Roboto-Regular'),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
    onChanged: (value) {
      if (isDate) {
        onChanged(initialValue!);
      } else {
        onChanged(value);
      }
    },
  )..controller?.text = isDate ? displayValue : controller.text;
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
  bool disabled = false,
}) {
  TextEditingController controller = TextEditingController(text: initialValue);

  String displayValue = isDate && initialValue != null
      ? formatEditDate(initialValue)
      : initialValue ?? "";

  return TextFormField(
    controller: controller,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto-Regular",
    ),
    readOnly: isDate || disabled,
    onTap: isDate || disabled ? clk : null,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 7.0),
      filled: true,
      fillColor: Colors.white,
      hintText: txt,
      prefixIcon: GestureDetector(
        onTap: () {
          if (clk != null) clk();
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
                padding: const EdgeInsets.all(16.5),
                child: SvgPicture.asset(sufimag!),
              ),
            )
          : null,
      hintStyle:
          TextStyle(color: clr, fontSize: 16, fontFamily: 'Roboto-Regular'),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
    onChanged: (value) {
      if (isDate) {
        onChanged(initialValue!);
      } else {
        onChanged(value);
      }
    },
  )..controller?.text = isDate ? displayValue : controller.text;
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
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
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
                              child: regularText(
                                role,
                                16,
                                black,
                                FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const Divider(color: background),
                      ],
                    );
                  })
                  .expand((element) => [element, gapH(1)])
                  .toList(),
            ),
          ),
        ),
      );
    },
  );
}
