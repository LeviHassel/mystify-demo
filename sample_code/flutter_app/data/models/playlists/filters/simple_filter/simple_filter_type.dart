import 'package:flutter/widgets.dart';
import 'package:mystify/generated/l10n.dart';

enum SimpleFilterType { saved, explicit }

extension SimpleFilterTypeExtensions on SimpleFilterType {
  String title(BuildContext context) {
    switch (this) {
      case SimpleFilterType.saved:
        return MystifyLocalizations.of(context).saved;
      case SimpleFilterType.explicit:
        return MystifyLocalizations.of(context).explicit;
      default:
        return '';
    }
  }

  String description(BuildContext context) {
    switch (this) {
      case SimpleFilterType.saved:
        return MystifyLocalizations.of(context).savedDescription;
      case SimpleFilterType.explicit:
        return MystifyLocalizations.of(context).explicitDescription;
      default:
        return '';
    }
  }
}
