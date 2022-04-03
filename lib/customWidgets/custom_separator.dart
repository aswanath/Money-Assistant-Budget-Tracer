import 'package:flutter/material.dart';

import '../globalUsageValues.dart';

class CustomSeparator extends StatelessWidget {
  Color? separatorColor;
  double? width;

  CustomSeparator({Key? key, this.separatorColor, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: deviceWidth,
      height: width ?? 1,
      child: DecoratedBox(
        decoration: BoxDecoration(color: separatorColor ?? secondaryPurple),
      ),
    );
  }
}
