import admin from "firebase-admin";

export interface PlaylistSyncEvent {
  status: PlaylistSyncStatus;
  statusDate: admin.firestore.Timestamp;
  retryCount: number;
}

export enum PlaylistSyncStatus {
  inProgress = "inProgress",
  success = "success",
  failure = "failure",
}
