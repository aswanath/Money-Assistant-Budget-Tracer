import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/customWidgets/sized_box_custom.dart';
import 'package:money_assistant_final/globalUsageValues.dart';

import '../main.dart';
import '../model/model_class.dart';
import 'add_category_screen.dart';

class EditCategoryPage extends StatefulWidget {
  final bool transactionType;
  final int indexKey;

  const EditCategoryPage(
      {Key? key, required this.indexKey, required this.transactionType})
      : super(key: key);

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  var categoryBox = Hive.box<Category>(boxCat);
  final TextEditingController _categoryName = TextEditingController();

  @override
  void initState() {
    _categoryName.text =
        categoryBox.get(widget.indexKey)!.categoryName.toString();
    super.initState();
  }

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
              CustomText(textData: 'Edit Category', textSize:   18),
              TextField(
                controller: _categoryName,
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
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7))),
                  backgroundColor: MaterialStateProperty.all(secondaryPurple),
                ),
                onPressed: () {
                  if (RegExp(r'^.*[a-zA-Z0-9]+.*$').hasMatch(_categoryName.text)) {
                  if (!categoryDuplicateCheck(_categoryName.text)){
                    checkCategory(_categoryName.text);
                    categoryBox.put(widget.indexKey,
                        Category(widget.transactionType, _categoryName.text));
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        elevation: 10,
                        behavior: SnackBarBehavior.fixed,
                        backgroundColor: secondaryPurple,
                        content: CustomText(
                          textData: 'Category name exists',
                          textSize: 16,
                          textColor: commonWhite,
                        )));
                  }}
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

  void checkCategory(String newName) {
    String _name = categoryBox.get(widget.indexKey)!.categoryName;
    var _transactionBox = Hive.box<Transaction>(boxTrans);
    List<Transaction> list = _transactionBox.values.toList();
    for (int i = 0; i < list.length; i++) {
      if (list[i].category == _name) {
        _transactionBox.put(
            list[i].key,
            Transaction(list[i].transactionType, list[i].date, newName,
                list[i].amount, list[i].notes));
      }
    }
  }
}
