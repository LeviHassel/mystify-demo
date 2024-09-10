import 'package:flutter/material.dart';
import 'package:mystify/data/models/playlists/utilities/filter_type_utility.dart';
import 'package:mystify/data/models/playlists/filters/string_filter/string_filter.dart';
import 'package:mystify/data/models/playlists/filters/string_filter/string_filter_option.dart';
import 'package:mystify/generated/l10n.dart';
import 'package:mystify/ui/screens/edit_playlist/edit_playlist_vm.dart';
import 'package:mystify/ui/screens/edit_playlist/view_models/string_filter_body_vm.dart';
import 'package:mystify/ui/shared/providers/stateful_provider.dart';
import 'package:mystify/ui/shared/utilities/dropdown_utility.dart';
import 'package:provider/provider.dart';

class StringFilterBody extends StatelessWidget {
  final StringFilter filter;
  StringFilterBody(this.filter);

  @override
  Widget build(BuildContext context) {
    var editPlaylistVm = context.watch<EditPlaylistVM>();

    return StatefulProvider<StringFilterBodyVM>(
      init: (vm) => vm.init(filter),
      onChange: (vm) => vm.onChange(editPlaylistVm),
      builder: (context, vm, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: <Widget>[
              _buildOptionRow(context, vm),
              SizedBox(height: 30.0),
              _buildTextField(context, vm),
              SizedBox(height: 10.0),
            ],
          ),
        );
      },
    );
  }

  Row _buildOptionRow(BuildContext context, StringFilterBodyVM vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          FilterTypeUtility.getTitle(vm.filter.type, context),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        DropdownUtility.buildDropdown<StringFilterOption>(
          values: StringFilterOption.values.toList(),
          valueNames: StringFilterOption.values
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

  Widget _buildTextField(BuildContext context, StringFilterBodyVM vm) {
    return TextField(
      controller: vm.textController,
      decoration: InputDecoration(
        hintText: MystifyLocalizations.of(context).enterTitle,
        labelStyle: Theme.of(context).accentTextTheme.subtitle2,
      ),
      maxLength: 100,
      onChanged: (String value) => vm.setValue(value),
    );
  }
}
