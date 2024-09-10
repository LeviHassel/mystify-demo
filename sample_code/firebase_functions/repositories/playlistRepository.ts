import admin from "firebase-admin";
import * as functions from "firebase-functions";
import { MystifyPlaylist } from "../models/playlist/playlist";
import { injectable } from "inversify";
import { IPlaylistRepository } from "./interfaces/iPlaylistRepository";

const FIRESTORE_PLAYLISTS_PATH = "playlists";
const IS_EQUAL_TO = "==";
const USER_ID = "userId";

@injectable()
export class PlaylistRepository implements IPlaylistRepository {
  async getPlaylist(playlistId: string): Promise<MystifyPlaylist> {
    const document = await admin
      .firestore()
      .collection(FIRESTORE_PLAYLISTS_PATH)
      .doc(playlistId)
      .get();

    if (!document.exists) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Mystify Playlist does not exist in Firestore."
      );
    }

    return document.data() as MystifyPlaylist;
  }

  async getPlaylistsForUser(userId: string): Promise<MystifyPlaylist[]> {
    const query = admin
      .firestore()
      .collection(FIRESTORE_PLAYLISTS_PATH)
      .where(USER_ID, IS_EQUAL_TO, userId);

    const snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data() as MystifyPlaylist);
  }

  async updatePlaylist(playlist: MystifyPlaylist): Promise<void> {
    const document = await admin
      .firestore()
      .collection(FIRESTORE_PLAYLISTS_PATH)
      .doc(playlist.id);

    await document.set(
      {
        title: playlist.title,
        description: playlist.description,
        spotifyId: playlist.spotifyId,
        image: playlist.image,
        songCount: playlist.songCount,
        lastSyncEvent: playlist.lastSyncEvent,
      },
      { merge: true }
    );

    console.log(
      `Updated playlist. Id=${playlist.id}, SpotifyId=${playlist.spotifyId}, UserId=${playlist.userId}, Title=${playlist.title}, SyncStatus=${playlist.lastSyncEvent.status}, SyncRetryCount=${playlist.lastSyncEvent.retryCount}, SongCount=${playlist.songCount}.`
    );
  }
}
