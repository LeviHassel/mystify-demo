import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mystify/data/models/playlists/utilities/uuid_utility.dart';
import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/data/models/playlists/filters/list_filter/list_filter_item.dart';
import 'package:mystify/data/models/playlists/filters/list_filter/list_filter_option.dart';
import 'package:mystify/data/models/playlists/filters/list_filter/list_filter_type.dart';
import 'package:mystify/generated/l10n.dart';
import 'package:mystify/ui/shared/utilities/string_utility.dart';

part 'list_filter.g.dart';

@JsonSerializable()
class ListFilter extends Filter {
  @override
  String id;

  @override
  ListFilterType type;

  ListFilterOption option;
  List<ListFilterItem> items;

  ListFilter({this.id, this.type, this.option, this.items}) : super();

  static ListFilter getDefault(ListFilterType filterType) {
    return ListFilter(
      id: UuidUtility.generateV4(),
      type: filterType,
      option: ListFilterOption.isAny,
      items: <ListFilterItem>[],
    );
  }

  @override
  factory ListFilter.fromJson(Map<String, dynamic> json) =>
      _$ListFilterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ListFilterToJson(this);

  @override
  String getSummary(BuildContext context) {
    var itemNames = items.map((i) => i.name.toString());

    switch (option) {
      case ListFilterOption.isAny:
        return StringUtility.joinWithCustomLast(
          itemNames,
          MystifyLocalizations.of(context).or.toLowerCase(),
        );
      case ListFilterOption.isNotAny:
        return MystifyLocalizations.of(context).not +
            ' ' +
            StringUtility.joinWithCustomLast(
              itemNames,
              MystifyLocalizations.of(context).or.toLowerCase(),
            );
      case ListFilterOption.isAll:
        return StringUtility.joinWithCustomLast(
          itemNames,
          MystifyLocalizations.of(context).and.toLowerCase(),
        );
      default:
        return '';
    }
  }
}
