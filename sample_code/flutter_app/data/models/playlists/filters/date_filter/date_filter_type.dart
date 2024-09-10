import 'package:flutter/widgets.dart';
import 'package:mystify/generated/l10n.dart';

enum DateFilterType { releaseDate, saveDate }

extension DateFilterTypeExtensions on DateFilterType {
  String title(BuildContext context) {
    switch (this) {
      case DateFilterType.releaseDate:
        return MystifyLocalizations.of(context).releaseDate;
      case DateFilterType.saveDate:
        return MystifyLocalizations.of(context).saveDate;
      default:
        return '';
    }
  }

  String description(BuildContext context) {
    switch (this) {
      case DateFilterType.releaseDate:
        return MystifyLocalizations.of(context).releaseDateDescription;
      case DateFilterType.saveDate:
        return MystifyLocalizations.of(context).saveDateDescription;
      default:
        return '';
    }
  }
}
