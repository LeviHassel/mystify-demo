import 'package:flutter/material.dart';
import 'package:mystify/data/models/playlists/filters/date_filter/date_filter.dart';
import 'package:mystify/data/models/playlists/filters/date_filter/date_filter_option.dart';
import 'package:mystify/data/models/playlists/filters/date_filter/date_filter_time_type.dart';
import 'package:mystify/data/models/playlists/utilities/filter_type_utility.dart';
import 'package:mystify/generated/l10n.dart';
import 'package:mystify/ui/screens/edit_playlist/edit_playlist_vm.dart';
import 'package:mystify/ui/screens/edit_playlist/view_models/date_filter_body_vm.dart';
import 'package:mystify/ui/shared/providers/stateful_provider.dart';
import 'package:mystify/ui/shared/utilities/dropdown_utility.dart';
import 'package:provider/provider.dart';

class DateFilterBody extends StatelessWidget {
  final DateFilter filter;
  DateFilterBody(this.filter);

  @override
  Widget build(BuildContext context) {
    var editPlaylistVm = context.watch<EditPlaylistVM>();

    return StatefulProvider<DateFilterBodyVM>(
      init: (vm) => vm.init(filter),
      onChange: (vm) => vm.onChange(editPlaylistVm),
      builder: (context, vm, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: <Widget>[
              _buildOptionRow(),
              SizedBox(height: 30.0),
              vm.option == DateFilterOption.inTheLast
                  ? _buildTimeLengthRow()
                  : _buildYearRow(),
              SizedBox(height: 10.0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionRow() {
    return Consumer<DateFilterBodyVM>(builder: (context, vm, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            FilterTypeUtility.getTitle(filter.type, context),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          DropdownUtility.buildDropdown<bool>(
            values: [true, false],
            valueNames: [
              MystifyLocalizations.of(context).isWord,
              MystifyLocalizations.of(context).isNot
            ],
            selectedValue: vm.isOptionTrue,
            setValue: vm.setIsOptionTrue,
            context: context,
          ),
          DropdownUtility.buildDropdown<DateFilterOption>(
            values: DateFilterOption.values.toList(),
            valueNames: DateFilterOption.values
                .toList()
                .map((option) => option.getReadableString(context))
                .toList(),
            selectedValue: vm.option,
            setValue: vm.setOption,
            context: context,
          ),
        ],
      );
    });
  }

  Widget _buildTimeLengthRow() {
    return Consumer<DateFilterBodyVM>(builder: (context, vm, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 120,
            child: TextField(
              style: Theme.of(context).textTheme.bodyText1,
              controller: vm.timeLengthController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: MystifyLocalizations.of(context).enterNumber,
                labelStyle: Theme.of(context).accentTextTheme.subtitle2,
              ),
              onChanged: (String value) =>
                  vm.setTimeLength(int.tryParse(value)),
            ),
          ),
          DropdownUtility.buildDropdown<DateFilterTimeType>(
            values: DateFilterTimeType.values.toList(),
            valueNames: DateFilterTimeType.values
                .toList()
                .map((type) => type.getTitle(context))
                .toList(),
            selectedValue: vm.timeType,
            setValue: vm.setTimeType,
            context: context,
          ),
        ],
      );
    });
  }

  Widget _buildYearRow() {
    return Consumer<DateFilterBodyVM>(builder: (context, vm, _) {
      var rowItems = [
        Container(
          width: 80,
          child: TextField(
            controller: vm.yearController,
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: vm.option == DateFilterOption.between
                  ? MystifyLocalizations.of(context).firstYear
                  : MystifyLocalizations.of(context).year,
              labelStyle: Theme.of(context).accentTextTheme.subtitle2,
            ),
            onChanged: (String value) => vm.setYear(int.tryParse(value)),
          ),
        ),
        if (vm.option == DateFilterOption.between) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              MystifyLocalizations.of(context).and.toLowerCase(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Container(
            width: 80,
            child: TextField(
              controller: vm.endingYearController,
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: MystifyLocalizations.of(context).lastYear,
                labelStyle: Theme.of(context).accentTextTheme.subtitle2,
              ),
              onChanged: (String value) =>
                  vm.setEndingYear(int.tryParse(value)),
            ),
          ),
        ],
      ];

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: rowItems,
      );
    });
  }
}
