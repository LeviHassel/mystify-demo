import 'package:flutter/material.dart';
import 'package:mystify/data/models/playlists/filters/date_filter/date_filter_type.dart';
import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/data/models/playlists/utilities/filter_type_utility.dart';
import 'package:mystify/data/models/playlists/filters/list_filter/list_filter_type.dart';
import 'package:mystify/data/models/playlists/filters/simple_filter/simple_filter_type.dart';
import 'package:mystify/data/models/playlists/filters/slider_filter/slider_filter_type.dart';
import 'package:mystify/data/models/playlists/filters/string_filter/string_filter_type.dart';
import 'package:mystify/generated/l10n.dart';
import 'package:mystify/ui/shared/utilities/dialog_utility.dart';

class AddFilterButton extends StatelessWidget {
  final void Function(Filter) addFilter;
  AddFilterButton(this.addFilter);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => _showAddFilterDialog(context),
      child: Text(
        MystifyLocalizations.of(context).addFilter,
        style: Theme.of(context).primaryTextTheme.button,
      ),
    );
  }

  void _showAddFilterDialog(BuildContext context) {
    DialogUtility.showSelectionDialog(
      context: context,
      title: MystifyLocalizations.of(context).addFilter,
      children: _buildDialogOptions(context),
    );
  }

  List<Widget> _buildDialogOptions(BuildContext context) {
    return [
      _buildSectionTitle(MystifyLocalizations.of(context).info, context),
      _buildFilterOption(StringFilterType.songTitle, context),
      _buildFilterOption(ListFilterType.artist, context),
      _buildFilterOption(ListFilterType.genre, context),
      SizedBox(height: 20.0),
      _buildSectionTitle(MystifyLocalizations.of(context).attributes, context),
      _buildFilterOption(SliderFilterType.duration, context),
      _buildFilterOption(SimpleFilterType.explicit, context),
      _buildFilterOption(DateFilterType.releaseDate, context),
      SizedBox(height: 20.0),
      _buildSectionTitle(MystifyLocalizations.of(context).personal, context),
      _buildFilterOption(SimpleFilterType.saved, context),
      _buildFilterOption(DateFilterType.saveDate, context),
      _buildFilterOption(ListFilterType.playlist, context),
      SizedBox(height: 20.0),
      _buildSectionTitle(MystifyLocalizations.of(context).community, context),
      _buildFilterOption(SliderFilterType.trackPopularity, context),
      _buildFilterOption(SliderFilterType.artistPopularity, context),
      _buildFilterOption(SliderFilterType.artistFollowers, context),
      SizedBox(height: 20.0),
      _buildSectionTitle(MystifyLocalizations.of(context).sound, context),
      _buildFilterOption(SliderFilterType.acousticness, context),
      _buildFilterOption(SliderFilterType.danceability, context),
      _buildFilterOption(SliderFilterType.energy, context),
      _buildFilterOption(SliderFilterType.happiness, context),
      _buildFilterOption(SliderFilterType.instrumentalness, context),
      _buildFilterOption(SliderFilterType.liveness, context),
      _buildFilterOption(SliderFilterType.loudness, context),
      _buildFilterOption(SliderFilterType.speechiness, context),
      _buildFilterOption(SliderFilterType.tempo, context),
    ];
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Container(
      child: Text(
        title,
        style: Theme.of(context).accentTextTheme.subtitle2,
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
    );
  }

  Widget _buildFilterOption(dynamic filterType, BuildContext context) {
    return SimpleDialogOption(
      onPressed: () => _addFilter(filterType, context),
      child: Text(
        FilterTypeUtility.getTitle(filterType, context),
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  void _addFilter(dynamic filterType, BuildContext context) {
    addFilter(FilterTypeUtility.getDefaultFilter(filterType));
    Navigator.pop(context);
  }
}
