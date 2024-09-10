import 'package:flutter/material.dart';
import 'package:mystify/data/constants/icons/font_awesome_solid_icons.dart';
import 'package:mystify/data/models/playlists/utilities/filter_type_utility.dart';
import 'package:mystify/data/models/playlists/filters/list_filter/list_filter.dart';
import 'package:mystify/data/models/playlists/filters/list_filter/list_filter_item.dart';
import 'package:mystify/data/models/playlists/filters/list_filter/list_filter_option.dart';
import 'package:mystify/data/models/playlists/filters/list_filter/list_filter_type.dart';
import 'package:mystify/generated/l10n.dart';
import 'package:mystify/ui/screens/edit_playlist/edit_playlist_vm.dart';
import 'package:mystify/ui/screens/edit_playlist/view_models/list_filter_body_vm.dart';
import 'package:mystify/ui/shared/providers/stateful_provider.dart';
import 'package:mystify/ui/shared/utilities/dialog_utility.dart';
import 'package:mystify/ui/shared/utilities/dropdown_utility.dart';
import 'package:provider/provider.dart';

class ListFilterBody extends StatelessWidget {
  final ListFilter filter;
  ListFilterBody(this.filter);

  @override
  Widget build(BuildContext context) {
    var editPlaylistVm = context.watch<EditPlaylistVM>();

    return StatefulProvider<ListFilterBodyVM>(
      init: (vm) => vm.init(filter),
      onChange: (vm) => vm.onChange(editPlaylistVm),
      builder: (context, vm, child) {
        return Column(
          children: <Widget>[
            _buildOptionRow(context, vm),
            SizedBox(height: 20.0),
            _buildList(context, vm),
            SizedBox(height: 20.0),
            _buildAddItemButton(context, vm),
            SizedBox(height: 10.0),
          ],
        );
      },
    );
  }

  Row _buildOptionRow(BuildContext context, ListFilterBodyVM vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          FilterTypeUtility.getTitle(vm.filter.type, context) +
              ' ' +
              MystifyLocalizations.of(context).isWord,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        DropdownUtility.buildDropdown<ListFilterOption>(
          values: ListFilterOption.values.toList(),
          valueNames: ListFilterOption.values
              .toList()
              .map((option) => option.getReadableString(context))
              .toList(),
          selectedValue: vm.option,
          setValue: vm.setOption,
          context: context,
        ),
        Text(
          MystifyLocalizations.of(context).ofTheFollowing + ':',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context, ListFilterBodyVM vm) {
    return vm.listItems.isEmpty
        ? Text(
            MystifyLocalizations.of(context).none,
            style: Theme.of(context).textTheme.bodyText2,
          )
        : Wrap(
            direction: Axis.horizontal,
            spacing: 12.0,
            children: [
              for (var item in vm.listItems)
                ChipTheme(
                  data: ChipTheme.of(context),
                  child: InputChip(
                    avatar: item.image == null
                        ? null
                        : CircleAvatar(
                            backgroundImage: NetworkImage(item.image)),
                    deleteIcon: Icon(
                      FontAwesomeSolid.times_circle,
                      size: 18.0,
                    ),
                    deleteButtonTooltipMessage:
                        MystifyLocalizations.of(context).delete +
                            ' ' +
                            FilterTypeUtility.getTitle(vm.filter.type, context),
                    onDeleted: () => vm.removeListItem(item),
                    label: Text(item.name),
                  ),
                ),
            ],
          );
  }

  Widget _buildAddItemButton(BuildContext context, ListFilterBodyVM vm) {
    return OutlineButton(
      onPressed: () => _showAddItemDialog(context, vm),
      child: Text(
        MystifyLocalizations.of(context).add +
            ' ' +
            FilterTypeUtility.getTitle(vm.filter.type, context),
        style: Theme.of(context).textTheme.button,
      ),
      borderSide: BorderSide(color: Theme.of(context).primaryColor),
      splashColor: Theme.of(context).primaryColor,
    );
  }

  void _showAddItemDialog(BuildContext context, ListFilterBodyVM vm) {
    DialogUtility.showSelectionDialog(
      context: context,
      title: MystifyLocalizations.of(context).add +
          ' ' +
          FilterTypeUtility.getTitle(vm.filter.type, context),
      children: _buildSearchResults(context, vm),
    );
  }

  List<Widget> _buildSearchResults(BuildContext context, ListFilterBodyVM vm) {
    List<ListFilterItem> searchResults;
    // TODO: Call into SpotifyRepository to get complete search results
    switch (vm.filter.type) {
      case ListFilterType.artist:
        // build search dialog for artists
        searchResults = [
          ListFilterItem(id: '2YZyLoL8N0Wb9xBt1NhZWg', name: 'Kendrick Lamar'),
          ListFilterItem(id: '5INjqkS1o8h1imAzPqGZBb', name: 'Tame Impala'),
          ListFilterItem(id: '2d0hyoQ5ynDBnkvAbJKORj', name: 'Rage Against The Machine'),
        ];
        break;
      case ListFilterType.genre:
        // build search dialog for genres
        searchResults = [
          ListFilterItem(id: 'metal', name: 'Metal'),
          ListFilterItem(id: 'pop', name: 'Pop'),
          ListFilterItem(id: 'hip-hop', name: 'Hip Hop'),
        ];
        break;
      case ListFilterType.playlist:
        // build search dialog for playlists
        searchResults = [
          ListFilterItem(id: '37i9dQZF1DZ06evO1sJmec', name: 'Listen Later'),
          ListFilterItem(id: '37i9dQZF1DWWMOmoXKqHTD', name: 'Focus Mix'),
          ListFilterItem(id: '3DLuf9GLQs6UWZsypnPTYp', name: 'Discover Weekly'),
        ];
        break;
    }

    return [
      for (var item in searchResults) _buildSearchResult(item, context, vm)
    ];
  }

  Widget _buildSearchResult(
      ListFilterItem item, BuildContext context, ListFilterBodyVM vm) {
    return SimpleDialogOption(
      onPressed: () {
        vm.addListItem(item);
        Navigator.of(context).pop();
      },
      child: Text(
        item.name,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
