import 'package:flutter/material.dart';
import 'package:money_assistant_final/customWidgets/sized_box_custom.dart';
import '../globalUsageValues.dart';
import 'custom_text.dart';

class SettingsListItems extends StatelessWidget {
  final IconData iconData;
  final String string;

  const SettingsListItems({Key? key, required this.iconData, required this.string})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                color: commonBlack,
              ),
              const CustomSizedBox(
                widthRatio: .04,
              ),
              CustomText(textData: string, textSize: 18),
            ],
          ),
        ],
      ),
    );
  }
}
