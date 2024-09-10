import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mystify/data/models/playlists/utilities/uuid_utility.dart';
import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/data/models/playlists/filters/slider_filter/slider_filter_option.dart';
import 'package:mystify/data/models/playlists/filters/slider_filter/slider_filter_type.dart';
import 'package:mystify/generated/l10n.dart';

part 'slider_filter.g.dart';

@JsonSerializable()
class SliderFilter extends Filter {
  @override
  String id;

  @override
  SliderFilterType type;

  SliderFilterOption option;
  double start;
  double end;

  SliderFilter({this.id, this.type, this.option, this.start, this.end})
      : super();

  static SliderFilter getDefault(SliderFilterType filterType) {
    return SliderFilter(
        id: UuidUtility.generateV4(),
        type: filterType,
        option: SliderFilterOption.isEqual,
        start: 30,
        end: 70);
  }

  @override
  String getSummary(BuildContext context) {
    switch (option) {
      case SliderFilterOption.isEqual:
        return valueString(context);
      case SliderFilterOption.isNotEqual:
        return MystifyLocalizations.of(context).not +
            ' ' +
            valueString(context);
      default:
        return '';
    }
  }

  String valueString(BuildContext context) {
    if (start == end) {
      return _getValueString(start, context);
    }

    return '${_getValueString(start, context)}—${_getValueString(end, context)}';
  }

  String _getValueString(double value, BuildContext context) {
    switch ((value).toInt()) {
      case 10:
        return MystifyLocalizations.of(context).veryLow;
      case 30:
        return MystifyLocalizations.of(context).low;
      case 50:
        return MystifyLocalizations.of(context).average;
      case 70:
        return MystifyLocalizations.of(context).high;
      case 90:
        return MystifyLocalizations.of(context).veryHigh;
      default:
        return MystifyLocalizations.of(context).error;
    }
  }

  @override
  factory SliderFilter.fromJson(Map<String, dynamic> json) =>
      _$SliderFilterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SliderFilterToJson(this);
}
