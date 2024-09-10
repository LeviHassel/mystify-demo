import 'package:mystify/data/models/playlists/playlist.dart';
import 'package:mystify/data/models/user/playlist_sort_order.dart';

abstract class IPlaylistRepository {
  /// Returns the `Playlist` with the given [id].
  ///
  /// Returns `null` if the given playlist does not exist.
  Future<Playlist> getPlaylist(String id);

  /// Returns a `Stream` of all non-deleted playlists created by the user with
  /// the provided [uid] and ordered by the provided [sortOrder].
  ///
  /// Returns `null` if it encounters an error when retrieving playlists.
  Stream<List<Playlist>> activePlaylists(
      String uid, PlaylistSortOrder sortOrder);

  /// Returns a `Stream` of all soft-deleted playlists created by the user with
  /// the provided [uid] and ordered by date deleted descending.
  ///
  /// Returns `null` if it encounters an error when retrieving playlists.
  Stream<List<Playlist>> deletedPlaylists(String uid);

  /// Updates all data for the given [playlist] if it exists or creates it if
  /// it doesn't exist.
  ///
  /// Returns a `bool` representing the success of the operation.
  Future<bool> updatePlaylist(Playlist playlist);

  /// Permanently deletes the playlist with the given [id].
  ///
  /// Returns a `bool` representing the success of the operation.
  Future<bool> deletePlaylist(String id);

  /// Permanently deletes all of a user's soft-deleted playlists.
  ///
  /// Returns a `bool` representing the success of the operation.
  Future<bool> deleteAllPlaylistsInTrash(String uid);
}
