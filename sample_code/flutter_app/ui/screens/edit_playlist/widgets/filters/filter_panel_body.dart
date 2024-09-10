import 'package:flutter/material.dart';
import 'package:mystify/data/models/playlists/filters/date_filter/date_filter.dart';
import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/data/models/playlists/filters/list_filter/list_filter.dart';
import 'package:mystify/data/models/playlists/filters/simple_filter/simple_filter.dart';
import 'package:mystify/data/models/playlists/filters/slider_filter/slider_filter.dart';
import 'package:mystify/data/models/playlists/filters/string_filter/string_filter.dart';
import 'package:mystify/generated/l10n.dart';
import 'package:mystify/ui/screens/edit_playlist/widgets/expansion_panel_bottom_row.dart';
import 'package:mystify/ui/screens/edit_playlist/widgets/filters/date_filter_body.dart';
import 'package:mystify/ui/screens/edit_playlist/widgets/filters/list_filter_body.dart';
import 'package:mystify/ui/screens/edit_playlist/widgets/filters/simple_filter_body.dart';
import 'package:mystify/ui/screens/edit_playlist/widgets/filters/slider_filter_body.dart';
import 'package:mystify/ui/screens/edit_playlist/widgets/filters/string_filter_body.dart';

class FilterPanelBody extends StatelessWidget {
  final Filter filter;
  FilterPanelBody(this.filter);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          _buildBody(context),
          ExpansionPanelBottomRow(filter),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (filter.runtimeType) {
      case DateFilter:
        return DateFilterBody(filter);
      case ListFilter:
        return ListFilterBody(filter);
      case SimpleFilter:
        return SimpleFilterBody(filter);
      case SliderFilter:
        return SliderFilterBody(filter);
      case StringFilter:
        return StringFilterBody(filter);
      default:
        return Container(
            child: Text(
          MystifyLocalizations.of(context).error,
          style: Theme.of(context).textTheme.bodyText2,
        ));
    }
  }
}
