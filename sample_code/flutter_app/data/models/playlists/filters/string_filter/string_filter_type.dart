import 'package:flutter/widgets.dart';
import 'package:mystify/generated/l10n.dart';

enum StringFilterType { songTitle }

extension StringFilterTypeExtensions on StringFilterType {
  String title(BuildContext context) {
    switch (this) {
      case StringFilterType.songTitle:
        return MystifyLocalizations.of(context).songTitle;
      default:
        return '';
    }
  }

  String description(BuildContext context) {
    switch (this) {
      case StringFilterType.songTitle:
        return MystifyLocalizations.of(context).songTitleDescription;
      default:
        return '';
    }
  }
}
