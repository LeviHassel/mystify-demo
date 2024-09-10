import 'package:mystify/data/models/playlists/playlist.dart';
import 'package:mystify/data/models/user/playlist_sort_order.dart';

abstract class IPlaylistService {
  /// Returns a `Stream` of all non-deleted playlists created by the user with
  /// the provided [userId] and ordered by the provided [sortOrder].
  Stream<List<Playlist>> myPlaylistsStream(
      String userId, PlaylistSortOrder sortOrder);

  /// Returns a `Stream` of all soft-deleted playlists created by the user with
  /// the provided [userId] and ordered by date deleted descending.
  Stream<List<Playlist>> deletedPlaylistsStream(String userId);

  /// Returns the `Playlist` with the given [id].
  ///
  /// Returns `null` if the given playlist does not exist.
  Future<Playlist> getPlaylist(String id);

  /// Clones the given [playlist] with a unique ID, setting its Title to
  /// [newTitle] and its Owner to [userId].
  ///
  /// Returns a `bool` representing the success of the operation.
  Future<bool> clonePlaylist(Playlist playlist, String userId, String newTitle);

  /// Updates all data for the [playlist] or creates it if it doesn't exist.
  ///
  /// Returns a `bool` representing the success of the operation.
  Future<bool> updatePlaylist(
    Playlist playlist,
    String userId,
  );

  /// Syncs playlist with Spotify, updating the list of songs based on the
  /// current sources, filters and tweaks.
  void syncPlaylist(String playlistId, String userId);

  /// Soft deletes the [playlist].
  ///
  /// Returns a `bool` representing the success of the operation.
  Future<bool> softDeletePlaylist(Playlist playlist);

  /// Permanently deletes the playlist with the given [id].
  ///
  /// Returns a `bool` representing the success of the operation.
  Future<bool> hardDeletePlaylist(String id);

  /// Permanently deletes all of the user's soft-deleted playlists.
  ///
  /// Returns a `bool` representing the success of the operation.
  Future<bool> emptyTrash(String userId);

  /// Restores the soft-deleted [playlist].
  ///
  /// Returns a `bool` representing the success of the operation.
  Future<bool> restorePlaylist(Playlist playlist);
}
