import 'package:flutter/material.dart';
import 'package:mystify/data/models/playlists/utilities/filter_type_utility.dart';
import 'package:mystify/data/models/playlists/filters/simple_filter/simple_filter.dart';
import 'package:mystify/data/models/playlists/filters/simple_filter/simple_filter_option.dart';
import 'package:mystify/generated/l10n.dart';
import 'package:mystify/ui/screens/edit_playlist/edit_playlist_vm.dart';
import 'package:mystify/ui/screens/edit_playlist/view_models/simple_filter_body_vm.dart';
import 'package:mystify/ui/shared/providers/stateful_provider.dart';
import 'package:mystify/ui/shared/utilities/dropdown_utility.dart';
import 'package:provider/provider.dart';

class SimpleFilterBody extends StatelessWidget {
  final SimpleFilter filter;
  SimpleFilterBody(this.filter);

  @override
  Widget build(BuildContext context) {
    var editPlaylistVm = context.watch<EditPlaylistVM>();

    return StatefulProvider<SimpleFilterBodyVM>(
      init: (vm) => vm.init(filter),
      onChange: (vm) => vm.onChange(editPlaylistVm),
      builder: (context, vm, child) {
        return Column(
          children: <Widget>[
            _buildRow(context, vm),
            SizedBox(height: 10.0),
          ],
        );
      },
    );
  }

  Row _buildRow(BuildContext context, SimpleFilterBodyVM vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          MystifyLocalizations.of(context).song,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        DropdownUtility.buildDropdown<SimpleFilterOption>(
          values: SimpleFilterOption.values.toList(),
          valueNames: SimpleFilterOption.values
              .toList()
              .map((option) => option.getReadableString(context))
              .toList(),
          selectedValue: vm.option,
          setValue: vm.setOption,
          context: context,
        ),
        Text(
          FilterTypeUtility.getTitle(vm.filter.type, context),
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }
}
