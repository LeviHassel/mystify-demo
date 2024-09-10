import 'package:flutter/material.dart';
import 'package:mystify/data/models/playlists/utilities/filter_type_utility.dart';
import 'package:mystify/data/models/playlists/filters/slider_filter/slider_filter.dart';
import 'package:mystify/data/models/playlists/filters/slider_filter/slider_filter_option.dart';
import 'package:mystify/generated/l10n.dart';
import 'package:mystify/ui/screens/edit_playlist/edit_playlist_vm.dart';
import 'package:mystify/ui/screens/edit_playlist/view_models/slider_filter_body_vm.dart';
import 'package:mystify/ui/shared/providers/stateful_provider.dart';
import 'package:mystify/ui/shared/utilities/dropdown_utility.dart';
import 'package:provider/provider.dart';

class SliderFilterBody extends StatelessWidget {
  final SliderFilter filter;
  SliderFilterBody(this.filter);

  @override
  Widget build(BuildContext context) {
    var editPlaylistVm = context.watch<EditPlaylistVM>();

    return StatefulProvider<SliderFilterBodyVM>(
      init: (vm) => vm.init(filter),
      onChange: (vm) => vm.onChange(editPlaylistVm),
      builder: (context, vm, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: <Widget>[
              _buildOptionRow(vm, context),
              SizedBox(height: 20.0),
              _buildValueRow(vm, context),
              SizedBox(height: 30.0),
              _buildSliderRow(context, vm),
              SizedBox(height: 10.0),
            ],
          ),
        );
      },
    );
  }

  Row _buildOptionRow(SliderFilterBodyVM vm, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          FilterTypeUtility.getTitle(vm.filter.type, context),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        DropdownUtility.buildDropdown<SliderFilterOption>(
          values: SliderFilterOption.values.toList(),
          valueNames: SliderFilterOption.values
              .toList()
              .map((option) => option.getReadableString(context))
              .toList(),
          selectedValue: vm.option,
          setValue: vm.setOption,
          context: context,
        ),
      ],
    );
  }

  Row _buildValueRow(SliderFilterBodyVM vm, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Text(
            vm.filter.valueString(context),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        )
      ],
    );
  }

  Widget _buildSliderRow(BuildContext context, SliderFilterBodyVM vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 45,
          alignment: Alignment.centerLeft,
          child: Text(
            MystifyLocalizations.of(context).low,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context),
            child: RangeSlider(
              values: vm.sliderValues,
              onChanged: (RangeValues values) => vm.setSliderValues(values),
              divisions: 4,
              min: 10,
              max: 90,
            ),
          ),
        ),
        Container(
          width: 45,
          alignment: Alignment.centerRight,
          child: Text(
            MystifyLocalizations.of(context).high,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ],
    );
  }
}
