import 'package:flutter/widgets.dart';
import 'package:mystify/generated/l10n.dart';

enum DateFilterTimeType { day, week, month, year }

extension DateFilterTimeTypeExtensions on DateFilterTimeType {
  String getTitle(BuildContext context) {
    switch (this) {
      case DateFilterTimeType.day:
        return MystifyLocalizations.of(context).days;
      case DateFilterTimeType.week:
        return MystifyLocalizations.of(context).weeks;
      case DateFilterTimeType.month:
        return MystifyLocalizations.of(context).months;
      case DateFilterTimeType.year:
        return MystifyLocalizations.of(context).years;
      default:
        return '';
    }
  }
}
