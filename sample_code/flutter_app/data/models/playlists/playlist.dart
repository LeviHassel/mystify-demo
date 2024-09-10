import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mystify/data/constants/config/mystify_config.dart';
import 'package:mystify/data/models/playlists/sync_event/playlist_sync_event.dart';
import 'package:mystify/data/models/playlists/sync_event/playlist_sync_status.dart';
import 'package:mystify/data/models/playlists/utilities/date_time_utility.dart';
import 'package:mystify/data/models/playlists/filters/date_filter/date_filter.dart';
import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/data/models/playlists/filters/list_filter/list_filter.dart';
import 'package:mystify/data/models/playlists/filters/simple_filter/simple_filter.dart';
import 'package:mystify/data/models/playlists/filters/slider_filter/slider_filter.dart';
import 'package:mystify/data/models/playlists/filters/string_filter/string_filter.dart';
import 'package:mystify/generated/l10n.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'playlist.g.dart';

@JsonSerializable()
class Playlist {
  String id;
  String spotifyId;
  String userId;
  String title;
  String description;
  String image;
  int songCount;
  bool isDeleted;

  @JsonKey(fromJson: filtersFromJson, toJson: filtersToJson)
  List<Filter> filters;

  @JsonKey(
    fromJson: DateTimeUtility.dateTimeFromTimestamp,
    toJson: DateTimeUtility.timestampFromDateTime,
  )
  DateTime dateCreated;

  @JsonKey(
    fromJson: DateTimeUtility.dateTimeFromTimestamp,
    toJson: DateTimeUtility.timestampFromDateTime,
  )
  DateTime dateModified;

  @JsonKey(
    fromJson: DateTimeUtility.dateTimeFromTimestamp,
    toJson: DateTimeUtility.timestampFromDateTime,
  )
  DateTime dateDeleted;

  PlaylistSyncEvent lastSyncEvent;

  Playlist(
      {this.id,
      this.spotifyId,
      this.userId,
      this.title,
      this.description,
      this.image,
      this.dateCreated,
      this.dateModified,
      this.dateDeleted,
      this.isDeleted,
      this.filters,
      this.songCount,
      this.lastSyncEvent});

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistToJson(this);

  Playlist deepCopy() => Playlist.fromJson(toJson());

  factory Playlist.getDefault(
    String playlistId,
    String userId,
    String title,
    String description,
    List<Filter> filters,
    DateTime currentDate,
  ) =>
      Playlist(
        id: playlistId,
        spotifyId: null,
        userId: userId,
        title: title,
        description: description,
        image: MystifyConfig.iconPath,
        filters: filters,
        songCount: 0,
        dateCreated: currentDate,
        dateModified: currentDate,
        dateDeleted: null,
        isDeleted: false,
        lastSyncEvent: PlaylistSyncEvent(
          status: PlaylistSyncStatus.inProgress,
          statusDate: currentDate,
          retryCount: 0,
        ),
      );

  bool get isNew => (dateCreated != null && dateModified != null)
      ? dateCreated.compareTo(dateModified) == 0
      : false;

  bool get showSyncFailed =>
      lastSyncEvent != null &&
      lastSyncEvent.status == PlaylistSyncStatus.failure &&
      lastSyncEvent.retryCount >= 2;

  bool get showSyncInProgress =>
      lastSyncEvent == null ||
      lastSyncEvent.status == PlaylistSyncStatus.inProgress ||
      (lastSyncEvent.status == PlaylistSyncStatus.failure &&
          lastSyncEvent.retryCount < 2);

  String getSyncText(BuildContext context) {
    var text;

    if (isDeleted) {
      text = timeago.format(dateDeleted);
    } else if (lastSyncEvent?.status == PlaylistSyncStatus.success) {
      text = timeago.format(lastSyncEvent.statusDate);
    } else if (showSyncFailed) {
      text =
          '${MystifyLocalizations.of(context).failed} ${timeago.format(lastSyncEvent.statusDate)}';
    } else if (showSyncInProgress) {
      text = MystifyLocalizations.of(context).inProgress;
    } else {
      text = '';
    }

    return text;
  }
}

// Temporary workaround based off https://stackoverflow.com/questions/61042910/dart-jsonserializable-with-absract-class#
List<Filter> filtersFromJson(List<dynamic> json) {
  if (json == null || json.isEmpty) {
    return <Filter>[];
  }

  return json.map((filter) {
    switch (filter['runtimeType'] ?? filter['\$']) {
      case 'DateFilter':
        return DateFilter.fromJson(filter);
      case 'ListFilter':
        return ListFilter.fromJson(filter);
      case 'SimpleFilter':
        return SimpleFilter.fromJson(filter);
      case 'SliderFilter':
        return SliderFilter.fromJson(filter);
      case 'StringFilter':
        return StringFilter.fromJson(filter);
      default:
        return null;
    }
  }).toList();
}

List<dynamic> filtersToJson(List<Filter> filters) {
  if (filters == null || filters.isEmpty) {
    return [];
  }

  return filters.map((filter) {
    var filterJson;

    switch (filter.runtimeType) {
      case DateFilter:
        filterJson = (filter as DateFilter).toJson();
        break;
      case ListFilter:
        filterJson = (filter as ListFilter).toJson();
        break;
      case SimpleFilter:
        filterJson = (filter as SimpleFilter).toJson();
        break;
      case SliderFilter:
        filterJson = (filter as SliderFilter).toJson();
        break;
      case StringFilter:
        filterJson = (filter as StringFilter).toJson();
        break;
    }

    if (filterJson != null) {
      filterJson.addAll({'runtimeType': filter.runtimeType.toString()});
    }

    return filterJson;
  }).toList();
}
