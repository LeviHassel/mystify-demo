import 'package:flutter/widgets.dart';
import 'package:mystify/generated/l10n.dart';

enum SliderFilterOption { isEqual, isNotEqual }

extension SliderFilterOptionExtensions on SliderFilterOption {
  String getReadableString(BuildContext context) {
    switch (this) {
      case SliderFilterOption.isEqual:
        return MystifyLocalizations.of(context).isWord;
      case SliderFilterOption.isNotEqual:
        return MystifyLocalizations.of(context).isNot;
      default:
        return '';
    }
  }
}
