import 'package:flutter/widgets.dart';
import 'package:mystify/generated/l10n.dart';

enum SimpleFilterOption { isTrue, isFalse }

extension SimpleFilterOptionExtensions on SimpleFilterOption {
  String getReadableString(BuildContext context) {
    switch (this) {
      case SimpleFilterOption.isTrue:
        return MystifyLocalizations.of(context).isWord;
      case SimpleFilterOption.isFalse:
        return MystifyLocalizations.of(context).isNot;
      default:
        return '';
    }
  }
}
