import 'package:flutter/material.dart';
import 'package:money_assistant_final/globalUsageValues.dart';

class CustomSizedBox extends StatelessWidget {
  final double? heightRatio;
  final double? widthRatio;
  final Widget? widgetChild;

  const CustomSizedBox(
      {Key? key, this.heightRatio, this.widthRatio, this.widgetChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: deviceWidth * (widthRatio ?? 0),
      height: deviceHeight * (heightRatio ?? 0),
      child: widgetChild,
    );
  }
}
