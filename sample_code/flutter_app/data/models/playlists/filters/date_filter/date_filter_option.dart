import 'package:flutter/widgets.dart';
import 'package:mystify/generated/l10n.dart';

enum DateFilterOption { inTheLast, inTheYear, before, after, between }

extension DateFilterOptionExtensions on DateFilterOption {
  String getReadableString(BuildContext context) {
    switch (this) {
      case DateFilterOption.inTheLast:
        return MystifyLocalizations.of(context).inTheLast;
      case DateFilterOption.inTheYear:
        return MystifyLocalizations.of(context).inWord;
      case DateFilterOption.before:
        return MystifyLocalizations.of(context).before;
      case DateFilterOption.after:
        return MystifyLocalizations.of(context).after;
      case DateFilterOption.between:
        return MystifyLocalizations.of(context).between;
      default:
        return '';
    }
  }
}
