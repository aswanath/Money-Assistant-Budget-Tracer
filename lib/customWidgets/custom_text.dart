import 'package:flutter/material.dart';
import 'package:money_assistant_final/globalUsageValues.dart';

class CustomText extends StatelessWidget {
  double? scaleFactor;
  String? textData;
  Color? textColor;
  double textSize;
  FontWeight? textWeight;
  TextAlign? textAlignment;
  TextOverflow? textOverflow;
  int? maxLines;

  CustomText(
      {Key? key,
      this.scaleFactor,
      this.textOverflow,
      this.maxLines,
      this.textWeight,
      this.textColor,
      required this.textData,
      required this.textSize,
      this.textAlignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textData ?? '',
      textScaleFactor: scaleFactor ?? 1,
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlignment ?? TextAlign.start,
      style: TextStyle(
          color: textColor,
          fontFamily: 'Poppins',
          fontSize: textSize,
          fontWeight: textWeight ?? FontWeight.normal),
    );
  }
}
