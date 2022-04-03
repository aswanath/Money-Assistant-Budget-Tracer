import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

part 'model_class.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  final bool transactionType;

  @HiveField(1)
  final String categoryName;

  Category(this.transactionType, this.categoryName);
}

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  final bool transactionType;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final String notes;

  Transaction(
      this.transactionType, this.date, this.category, this.amount, this.notes);
}
