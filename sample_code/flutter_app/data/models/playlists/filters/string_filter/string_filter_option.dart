import 'package:flutter/widgets.dart';
import 'package:mystify/generated/l10n.dart';

enum StringFilterOption { contains, doesNotContain, isEqual, isNotEqual }

extension StringFilterOptionExtensions on StringFilterOption {
  String getReadableString(BuildContext context) {
    switch (this) {
      case StringFilterOption.contains:
        return MystifyLocalizations.of(context).contains;
      case StringFilterOption.doesNotContain:
        return MystifyLocalizations.of(context).doesntContain;
      case StringFilterOption.isEqual:
        return MystifyLocalizations.of(context).isWord;
      case StringFilterOption.isNotEqual:
        return MystifyLocalizations.of(context).isNot;

      default:
        return '';
    }
  }
}
