import { Filter } from "./filter";
import admin from "firebase-admin";
import { PlaylistSyncEvent } from "./playlistSyncEvent";

export interface MystifyPlaylist {
  id: string;
  spotifyId: string;
  userId: string;
  title: string;
  description?: string;
  image: string;
  songCount: number;
  dateCreated: admin.firestore.Timestamp;
  dateModified: admin.firestore.Timestamp;
  dateDeleted?: admin.firestore.Timestamp;
  isDeleted: boolean;
  filters: Filter[];
  lastSyncEvent: PlaylistSyncEvent;
}
