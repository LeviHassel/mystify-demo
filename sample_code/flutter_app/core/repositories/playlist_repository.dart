import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mystify/core/locator.dart';
import 'package:mystify/core/repositories/interfaces/i_playlist_repository.dart';
import 'package:mystify/core/services/interfaces/i_logging_service.dart';
import 'package:mystify/data/constants/config/firestore_config.dart';

import 'package:mystify/data/models/playlists/playlist.dart';
import 'package:mystify/data/models/user/playlist_sort_order.dart';

class PlaylistRepository implements IPlaylistRepository {
  ILoggingService _log;
  Firestore _firestore;

  PlaylistRepository({
    ILoggingService log,
    Firestore firestore,
  }) {
    _log = log ?? Locator.get<ILoggingService>();
    _firestore = firestore ?? Locator.get<Firestore>();
  }

  @override
  Future<Playlist> getPlaylist(String id) async {
    var playlistRef =
        _firestore.collection(FirestoreConfig.playlistsPath).document(id);

    var playlistSnapshot = await playlistRef.get();
    return Playlist.fromJson(playlistSnapshot.data);
  }

  @override
  Stream<List<Playlist>> activePlaylists(
      String uid, PlaylistSortOrder sortOrder) {
    var query = _firestore
        .collection(FirestoreConfig.playlistsPath)
        .where(FirestoreConfig.userId, isEqualTo: uid)
        .where(FirestoreConfig.playlistIsDeleted, isEqualTo: false);

    switch (sortOrder) {
      case PlaylistSortOrder.alphabetical:
        query = query.orderBy(FirestoreConfig.playlistTitle, descending: false);
        break;
      case PlaylistSortOrder.lastSynced:
        query =
            query.orderBy(FirestoreConfig.playlistLastSynced, descending: true);
        break;
      case PlaylistSortOrder.lastModified:
        query = query.orderBy(FirestoreConfig.playlistDateModified,
            descending: true);
        break;
    }

    return query.snapshots().map((list) =>
        [for (var doc in list.documents) Playlist.fromJson(doc.data)]);
  }

  @override
  Stream<List<Playlist>> deletedPlaylists(String uid) {
    var query = _firestore
        .collection(FirestoreConfig.playlistsPath)
        .where(FirestoreConfig.userId, isEqualTo: uid)
        .where(FirestoreConfig.playlistIsDeleted, isEqualTo: true)
        .orderBy(FirestoreConfig.playlistDateDeleted, descending: true);

    return query.snapshots().map((list) =>
        [for (var doc in list.documents) Playlist.fromJson(doc.data)]);
  }

  @override
  Future<bool> updatePlaylist(Playlist playlist) async {
    try {
      var playlistRef = _firestore
          .collection(FirestoreConfig.playlistsPath)
          .document(playlist.id);

      await playlistRef.setData(playlist.toJson(), merge: false);
    } catch (e) {
      _log.error(e, StackTrace.current);
      return false;
    }

    return true;
  }

  @override
  Future<bool> deletePlaylist(String id) async {
    try {
      var playlistRef =
          _firestore.collection(FirestoreConfig.playlistsPath).document(id);

      await playlistRef.delete();
    } catch (e) {
      _log.error(e, StackTrace.current);
      return false;
    }

    return true;
  }

  @override
  Future<bool> deleteAllPlaylistsInTrash(String uid) async {
    try {
      var playlistsToDelete = await _firestore
          .collection(FirestoreConfig.playlistsPath)
          .where(FirestoreConfig.userId, isEqualTo: uid)
          .where(FirestoreConfig.playlistIsDeleted, isEqualTo: true)
          .getDocuments();

      var batch = _firestore.batch();

      for (var document in playlistsToDelete.documents) {
        batch.delete(document.reference);
      }

      await batch.commit();
    } catch (e) {
      _log.error(e, StackTrace.current);
      return false;
    }

    return true;
  }
}
