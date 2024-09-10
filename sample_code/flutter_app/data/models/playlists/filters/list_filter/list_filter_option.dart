import 'package:flutter/widgets.dart';
import 'package:mystify/generated/l10n.dart';

enum ListFilterOption { isAny, isNotAny, isAll }

extension ListFilterOptionExtensions on ListFilterOption {
  String getReadableString(BuildContext context) {
    switch (this) {
      case ListFilterOption.isAny:
        return MystifyLocalizations.of(context).any;
      case ListFilterOption.isNotAny:
        return MystifyLocalizations.of(context).none;
      case ListFilterOption.isAll:
        return MystifyLocalizations.of(context).all;
      default:
        return '';
    }
  }
}
