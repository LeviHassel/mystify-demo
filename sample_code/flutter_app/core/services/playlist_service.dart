import 'package:mystify/core/locator.dart';
import 'package:mystify/core/repositories/interfaces/i_functions_repository.dart';
import 'package:mystify/core/repositories/interfaces/i_playlist_repository.dart';
import 'package:mystify/core/services/interfaces/i_logging_service.dart';
import 'package:mystify/core/services/interfaces/i_playlist_service.dart';
import 'package:mystify/data/models/playlists/playlist.dart';
import 'package:mystify/data/models/playlists/utilities/uuid_utility.dart';
import 'package:mystify/data/models/user/playlist_sort_order.dart';

class PlaylistService implements IPlaylistService {
  ILoggingService _log;
  IPlaylistRepository _playlistRepository;
  IFunctionsRepository _functionsRepository;

  PlaylistService({
    ILoggingService log,
    IPlaylistRepository playlistRepository,
    IFunctionsRepository functionsRepository,
  }) {
    _log = log ?? Locator.get<ILoggingService>();
    _playlistRepository =
        playlistRepository ?? Locator.get<IPlaylistRepository>();
    _functionsRepository =
        functionsRepository ?? Locator.get<IFunctionsRepository>();
  }

  @override
  Stream<List<Playlist>> myPlaylistsStream(
      String userId, PlaylistSortOrder sortOrder) {
    var stream = _playlistRepository.activePlaylists(userId, sortOrder);

    _log.event(name: 'get_my_playlists', data: {
      'userId': userId,
      'sortOrder': sortOrder.toString(),
    });

    return stream;
  }

  @override
  Stream<List<Playlist>> deletedPlaylistsStream(String userId) {
    var stream = _playlistRepository.deletedPlaylists(userId);

    _log.event(name: 'get_deleted_playlists', data: {
      'userId': userId,
    });

    return stream;
  }

  @override
  Future<Playlist> getPlaylist(String id) async {
    var playlist = await _playlistRepository.getPlaylist(id);

    _log.event(name: 'get_playlist', data: {
      'id': id,
      'title': playlist?.title,
      'success': playlist != null,
    });

    return playlist;
  }

  @override
  Future<bool> clonePlaylist(
      Playlist playlist, String userId, String newTitle) async {
    var clonedPlaylist;

    try {
      clonedPlaylist = playlist.deepCopy();
      clonedPlaylist.id = UuidUtility.generateV4();
      clonedPlaylist.spotifyId = null;
      clonedPlaylist.userId = userId;
      clonedPlaylist.title = newTitle;
      clonedPlaylist.image = null;
      clonedPlaylist.dateCreated = DateTime.now().toUtc();
      clonedPlaylist.dateModified = DateTime.now().toUtc();
      clonedPlaylist.dateDeleted = null;
      clonedPlaylist.isDeleted = false;
    } catch (e) {
      _log.error(e, StackTrace.current);
      return false;
    }

    var success = await _playlistRepository.updatePlaylist(clonedPlaylist);

    _log.event(name: 'clone_playlist', data: {
      'cloned_id': clonedPlaylist.id,
      'cloned_title': clonedPlaylist.title,
      'original_id': playlist.id,
      'original_title': playlist.title,
      'success': success,
    });

    return success;
  }

  @override
  Future<bool> updatePlaylist(Playlist playlist, String userId) async {
    var success = await _playlistRepository.updatePlaylist(playlist);

    var eventName = playlist.isNew ? 'create_playlist' : 'update_playlist';

    _log.event(name: eventName, data: {
      'id': playlist.id,
      'playlistTitle': playlist.title,
      'userId': userId,
      'success': success,
    });

    return success;
  }

  @override
  void syncPlaylist(String playlistId, String userId) async {
    _functionsRepository.syncPlaylist(playlistId, userId);

    _log.event(name: 'sync_playlist', data: {
      'playlistId': playlistId,
      'userId': userId,
    });
  }

  @override
  Future<bool> softDeletePlaylist(Playlist playlist) async {
    var updatedPlaylist;

    try {
      updatedPlaylist = playlist.deepCopy();
      updatedPlaylist.dateDeleted = DateTime.now().toUtc();
      updatedPlaylist.isDeleted = true;
    } catch (e) {
      _log.error(e, StackTrace.current);
      return false;
    }

    var success = await _playlistRepository.updatePlaylist(updatedPlaylist);

    _log.event(name: 'soft_delete_playlist', data: {
      'id': updatedPlaylist.id,
      'title': updatedPlaylist.title,
      'success': success,
    });

    return success;
  }

  @override
  Future<bool> hardDeletePlaylist(String id) async {
    var success = await _playlistRepository.deletePlaylist(id);

    _log.event(name: 'hard_delete_playlist', data: {
      'id': id,
      'success': success,
    });

    return success;
  }

  @override
  Future<bool> emptyTrash(String userId) async {
    var success = await _playlistRepository.deleteAllPlaylistsInTrash(userId);

    _log.event(name: 'empty_trash', data: {
      'userId': userId,
      'success': success,
    });

    return success;
  }

  @override
  Future<bool> restorePlaylist(Playlist playlist) async {
    var restoredPlaylist;

    try {
      restoredPlaylist = playlist.deepCopy();
      restoredPlaylist.dateDeleted = null;
      restoredPlaylist.isDeleted = false;
    } catch (e) {
      _log.error(e, StackTrace.current);
      return false;
    }

    var success = await _playlistRepository.updatePlaylist(restoredPlaylist);

    _log.event(name: 'restore_playlist', data: {
      'id': restoredPlaylist.id,
      'title': restoredPlaylist.title,
      'success': success,
    });

    return success;
  }
}
