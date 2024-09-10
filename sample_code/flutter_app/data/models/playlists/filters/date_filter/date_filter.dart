import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mystify/data/models/playlists/utilities/uuid_utility.dart';
import 'package:mystify/data/models/playlists/filters/date_filter/date_filter_option.dart';
import 'package:mystify/data/models/playlists/filters/date_filter/date_filter_time_type.dart';
import 'package:mystify/data/models/playlists/filters/date_filter/date_filter_type.dart';
import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/generated/l10n.dart';

part 'date_filter.g.dart';

@JsonSerializable()
class DateFilter extends Filter {
  @override
  String id;

  @override
  DateFilterType type;

  DateFilterOption option;
  bool isOptionTrue;
  int year;
  int endingYear;
  DateFilterTimeType timeType;
  int timeLength;

  DateFilter({
    this.id,
    this.type,
    this.option,
    this.isOptionTrue,
    this.year,
    this.endingYear,
    this.timeType,
    this.timeLength,
  }) : super();

  static DateFilter getDefault(DateFilterType filterType) {
    return DateFilter(
      id: UuidUtility.generateV4(),
      type: filterType,
      option: DateFilterOption.inTheLast,
      isOptionTrue: true,
      timeLength: 3,
      timeType: DateFilterTimeType.month,
    );
  }

  @override
  factory DateFilter.fromJson(Map<String, dynamic> json) =>
      _$DateFilterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DateFilterToJson(this);

  @override
  String getSummary(BuildContext context) {
    var notPrefix =
        isOptionTrue ? '' : MystifyLocalizations.of(context).not + ' ';

    switch (option) {
      case DateFilterOption.inTheLast:
        if (timeLength == null) {
          return MystifyLocalizations.of(context).error;
        }

        return notPrefix +
            option.getReadableString(context) +
            ' ' +
            timeLength.toString() +
            ' ' +
            timeType.getTitle(context);
      case DateFilterOption.inTheYear:
        return year == null
            ? MystifyLocalizations.of(context).error
            : notPrefix + year.toString();
      case DateFilterOption.before:
        return year == null
            ? MystifyLocalizations.of(context).error
            : notPrefix +
                option.getReadableString(context) +
                ' ' +
                year.toString();
      case DateFilterOption.after:
        return year == null
            ? MystifyLocalizations.of(context).error
            : notPrefix +
                option.getReadableString(context) +
                ' ' +
                year.toString();
      case DateFilterOption.between:
        if (year == null || endingYear == null) {
          return MystifyLocalizations.of(context).error;
        }

        return notPrefix + year.toString() + '–' + endingYear.toString();
      default:
        return '';
    }
  }
}
