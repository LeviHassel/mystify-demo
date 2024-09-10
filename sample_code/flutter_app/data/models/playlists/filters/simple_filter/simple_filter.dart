import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mystify/data/models/playlists/utilities/uuid_utility.dart';
import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/data/models/playlists/filters/simple_filter/simple_filter_option.dart';
import 'package:mystify/data/models/playlists/filters/simple_filter/simple_filter_type.dart';
import 'package:mystify/generated/l10n.dart';

part 'simple_filter.g.dart';

@JsonSerializable()
class SimpleFilter extends Filter {
  @override
  String id;

  @override
  SimpleFilterType type;

  SimpleFilterOption option;

  SimpleFilter({this.id, this.type, this.option}) : super();

  static SimpleFilter getDefault(SimpleFilterType filterType) {
    return SimpleFilter(
      id: UuidUtility.generateV4(),
      type: filterType,
      option: SimpleFilterOption.isTrue,
    );
  }

  @override
  String getSummary(BuildContext context) {
    return option == SimpleFilterOption.isTrue
        ? MystifyLocalizations.of(context).yes
        : MystifyLocalizations.of(context).no;
  }

  @override
  factory SimpleFilter.fromJson(Map<String, dynamic> json) =>
      _$SimpleFilterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SimpleFilterToJson(this);
}
