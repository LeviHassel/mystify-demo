import 'package:flutter/widgets.dart';

abstract class Filter {
  String get id;
  dynamic get type;

  Filter();

  Map<String, dynamic> toJson();

  String getSummary(BuildContext context);
}
