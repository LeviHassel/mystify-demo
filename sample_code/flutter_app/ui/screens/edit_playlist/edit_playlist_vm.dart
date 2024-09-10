import 'package:flutter/cupertino.dart';
import 'package:mystify/core/locator.dart';
import 'package:mystify/data/models/playlists/utilities/uuid_utility.dart';
import 'package:mystify/core/services/interfaces/i_playlist_service.dart';

import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/data/models/playlists/playlist.dart';
import 'package:mystify/ui/shared/view_models/base_vm.dart';

class EditPlaylistVM extends BaseVM {
  final IPlaylistService _playlistService = Locator.get<IPlaylistService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Playlist _playlist;
  List<Filter> _filters = [];
  String _selectedFilterId;
  String _userId;
  String _playlistId;

  Playlist get playlist => _playlist;
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get titleController => _titleController;
  TextEditingController get descriptionController => _descriptionController;
  List<Filter> get filters => _filters;
  String get selectedFilterId => _selectedFilterId;
  String get playlistId => _playlistId;

  bool get isEditing => _playlist != null;

  void init(String playlistId) async {
    setBusy(true);

    if (playlistId != null) {
      _playlist = await _playlistService.getPlaylist(playlistId);
      _titleController.text = _playlist.title;
      _descriptionController.text = _playlist.description;
      _filters = _playlist.filters.toList();
    }

    _playlistId = playlistId ?? UuidUtility.generateV4();

    setBusy(false);
  }

  void onChange(String userId) {
    setUserId(userId);
  }

  void setUserId(String userId) {
    if (userId != _userId) {
      _userId = userId;
      notifyListeners();
    }
  }

  Future<bool> savePlaylist() async {
    setBusy(true);
    _formKey.currentState.save();

    var updatedPlaylist;
    var currentDate = DateTime.now().toUtc();

    if (isEditing) {
      updatedPlaylist = _playlist.deepCopy();
      updatedPlaylist.title = _titleController.text;
      updatedPlaylist.description = _descriptionController.text;
      updatedPlaylist.filters = _filters;
      updatedPlaylist.dateModified = currentDate;
    } else {
      updatedPlaylist = Playlist.getDefault(
        _playlistId,
        _userId,
        _titleController.text,
        _descriptionController.text,
        _filters,
        currentDate,
      );
    }

    var success = await _playlistService.updatePlaylist(
      updatedPlaylist,
      _userId,
    );

    if (success) {
      _playlist = updatedPlaylist;
    }

    setBusy(false);
    return success;
  }

  void syncPlaylist() => _playlistService.syncPlaylist(_playlistId, _userId);

  void setSelectedFilter(int index, bool isExpanded) {
    _selectedFilterId = isExpanded ? null : _filters[index].id;
    notifyListeners();
  }

  void addFilter(Filter filter) {
    _filters.add(filter);

    _selectedFilterId = filter.id;

    notifyListeners();
  }

  void updateFilter(Filter updatedFilter) {
    var oldFilter = _filters.firstWhere(
      (filter) => filter.id == updatedFilter.id,
    );
    var index = _filters.indexOf(oldFilter);
    _filters[index] = updatedFilter;
    notifyListeners();
  }

  void deleteFilter(Filter filter) {
    _filters.remove(filter);
    _selectedFilterId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
