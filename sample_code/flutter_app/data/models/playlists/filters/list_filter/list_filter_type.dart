import 'package:flutter/widgets.dart';
import 'package:mystify/generated/l10n.dart';

enum ListFilterType { artist, genre, playlist }

extension ListFilterTypeExtensions on ListFilterType {
  String title(BuildContext context) {
    switch (this) {
      case ListFilterType.artist:
        return MystifyLocalizations.of(context).artist;
      case ListFilterType.genre:
        return MystifyLocalizations.of(context).genre;
      case ListFilterType.playlist:
        return MystifyLocalizations.of(context).playlist;
      default:
        return '';
    }
  }

  String description(BuildContext context) {
    switch (this) {
      case ListFilterType.artist:
        return MystifyLocalizations.of(context).artistDescription;
      case ListFilterType.genre:
        return MystifyLocalizations.of(context).genreDescription;
      case ListFilterType.playlist:
        return MystifyLocalizations.of(context).playlistDescription;
      default:
        return '';
    }
  }
}
