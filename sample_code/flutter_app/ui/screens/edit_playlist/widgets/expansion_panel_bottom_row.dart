import 'package:flutter/material.dart';
import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/data/models/playlists/utilities/filter_type_utility.dart';
import 'package:mystify/generated/l10n.dart';
import 'package:mystify/ui/screens/edit_playlist/edit_playlist_vm.dart';
import 'package:mystify/ui/shared/utilities/dialog_utility.dart';
import 'package:mystify/ui/shared/widgets/small_icon_button_wrapper.dart';
import 'package:provider/provider.dart';

class ExpansionPanelBottomRow extends StatelessWidget {
  final Filter filter;
  ExpansionPanelBottomRow(this.filter);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 15.0),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Row(
                children: <Widget>[
                  Icon(Icons.delete),
                  SizedBox(width: 10.0),
                  Text(
                    MystifyLocalizations.of(context).delete,
                    style: Theme.of(context).textTheme.button,
                  ),
                ],
              ),
              onPressed: () =>
                  context.watch<EditPlaylistVM>().deleteFilter(filter),
            ),
            SmallIconButtonWrapper(
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () => _showFilterInfoDialog(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showFilterInfoDialog(BuildContext context) {
    DialogUtility.showInfoDialog(
      context: context,
      title: FilterTypeUtility.getTitle(filter.type, context) +
          ' ' +
          MystifyLocalizations.of(context).filter,
      description: FilterTypeUtility.getDescription(filter.type, context),
    );
  }
}
