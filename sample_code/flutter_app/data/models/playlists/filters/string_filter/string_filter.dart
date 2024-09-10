import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mystify/data/models/playlists/utilities/uuid_utility.dart';
import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/data/models/playlists/filters/string_filter/string_filter_option.dart';
import 'package:mystify/data/models/playlists/filters/string_filter/string_filter_type.dart';
import 'package:mystify/generated/l10n.dart';

part 'string_filter.g.dart';

@JsonSerializable()
class StringFilter implements Filter {
  @override
  String id;

  @override
  StringFilterType type;

  StringFilterOption option;
  String value;

  StringFilter({this.id, this.type, this.option, this.value}) : super();

  static StringFilter getDefault(StringFilterType filterType) {
    return StringFilter(
      id: UuidUtility.generateV4(),
      type: filterType,
      option: StringFilterOption.contains,
      value: '',
    );
  }

  @override
  String getSummary(BuildContext context) {
    if (value.trim().isEmpty) {
      return MystifyLocalizations.of(context).empty;
    }

    switch (option) {
      case StringFilterOption.contains:
        return MystifyLocalizations.of(context).contains + ' "' + value + '"';
      case StringFilterOption.doesNotContain:
        return MystifyLocalizations.of(context).doesntContain +
            ' "' +
            value +
            '"';
      case StringFilterOption.isEqual:
        return '"' + value + '"';
      case StringFilterOption.isNotEqual:
        return MystifyLocalizations.of(context).not + ' "' + value + '"';

      default:
        return '';
    }
  }

  @override
  factory StringFilter.fromJson(Map<String, dynamic> json) =>
      _$StringFilterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StringFilterToJson(this);
}
