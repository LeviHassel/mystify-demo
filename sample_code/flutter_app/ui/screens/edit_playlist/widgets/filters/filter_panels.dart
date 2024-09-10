import 'package:flutter/material.dart';
import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/data/models/playlists/utilities/filter_type_utility.dart';
import 'package:mystify/ui/screens/edit_playlist/edit_playlist_vm.dart';
import 'package:mystify/ui/screens/edit_playlist/widgets/expansion_panel_header.dart';
import 'package:mystify/ui/screens/edit_playlist/widgets/filters/filter_panel_body.dart';
import 'package:provider/provider.dart';

class FilterPanels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var editPlaylistVm = context.watch<EditPlaylistVM>();

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) =>
          editPlaylistVm.setSelectedFilter(index, isExpanded),
      children: editPlaylistVm.filters
          .map((Filter filter) => _buildFilter(context, editPlaylistVm, filter))
          .toList(),
    );
  }

  ExpansionPanel _buildFilter(
      BuildContext context, EditPlaylistVM vm, Filter filter) {
    return ExpansionPanel(
      isExpanded: filter.id == vm.selectedFilterId,
      canTapOnHeader: true,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ExpansionPanelHeader(
          FilterTypeUtility.getTitle(filter.type, context),
          isExpanded ? '' : filter.getSummary(context),
        );
      },
      body: FilterPanelBody(filter),
    );
  }
}
