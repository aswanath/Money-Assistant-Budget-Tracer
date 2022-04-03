import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/customWidgets/sized_box_custom.dart';
import 'package:money_assistant_final/globalUsageValues.dart';
import 'package:money_assistant_final/mainScreens/screen_category.dart';
import '../main.dart';
import '../model/model_class.dart';

class AddCategoryPage extends StatelessWidget {
  var categoryBox = Hive.box<Category>(boxCat);
  TextEditingController categoryText = TextEditingController();

  AddCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: CustomSizedBox(
        widthRatio: .3,
        heightRatio: .2,
        widgetChild: DecoratedBox(
          decoration: BoxDecoration(color: commonWhite),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomText(textData: 'Add Category', textSize:18),
              TextField(
                controller: categoryText,
                cursorColor: secondaryPurple,
                style: const TextStyle(fontFamily: 'Poppins'),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: secondaryPurple),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: secondaryPurple),
                  ),
                ),
              ),
              const CustomSizedBox(heightRatio: .01,),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7))),
                  backgroundColor: MaterialStateProperty.all(secondaryPurple),
                ),
                onPressed: () {
                  if (RegExp(r'^.*[a-zA-Z0-9]+.*$')
                      .hasMatch(categoryText.text)) {
                    if (!categoryDuplicateCheck(categoryText.text)) {
                      categoryBox.add(Category(
                          controllerIndex == 0 ? true : false,
                          categoryText.text));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          elevation: 10,
                          behavior: SnackBarBehavior.fixed,
                          backgroundColor: secondaryPurple,
                          content: CustomText(
                            textData: 'Category name exists',
                            textSize: 16,
                            textColor: commonWhite,
                          )));
                    }
                  }
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth * .08, vertical: 9),
                  child: CustomText(
                    textColor: commonWhite,
                    textData: 'SAVE',
                    textSize:  16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool categoryDuplicateCheck(String text,) {
  List<Category> _list = Hive.box<Category>(boxCat).values.toList();
  bool check = false;
  for (int i = 0; i < _list.length; i++) {
    if (_list[i].categoryName.trim() == text.trim()) {
      check = true;
      break;
    }
  }
  return check;
}
