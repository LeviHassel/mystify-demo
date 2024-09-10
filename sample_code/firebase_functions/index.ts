import { container } from "./config/inversify.config";
import { TYPES } from "./constants/types";
import * as functions from "firebase-functions";
import initFirebase from "./config/initFirebase";
import { IUpdatePlaylistService } from "./services/interfaces/iUpdatePlaylistService";
import { IAuthService } from "./services/interfaces/iAuthService";
import { IUpdateStalePlaylistsService } from "./services/interfaces/iUpdateStalePlaylistsService";

initFirebase();

// Scheduled
exports.update_stale_playlists = functions.pubsub
  .schedule("every hour")
  .onRun(async (context: functions.EventContext) => {
    const updateStalePlaylistsService = container.get<
      IUpdateStalePlaylistsService
    >(TYPES.IUpdateStalePlaylistsService);

    await updateStalePlaylistsService.updateStalePlaylists();
  });

// On Request
exports.generate_auth_token = functions.https.onCall(
  async (data: any, context: functions.https.CallableContext) => {
    const authService = container.get<IAuthService>(TYPES.IAuthService);
    const customFirebaseToken = await authService.generateCustomFirebaseToken(
      data
    );
    return { firebaseAuthToken: customFirebaseToken };
  }
);

exports.update_playlist = functions.https.onCall(
  async (data: any, context: functions.https.CallableContext) => {
    const updatePlaylistService = container.get<IUpdatePlaylistService>(
      TYPES.IUpdatePlaylistService
    );

    await updatePlaylistService.updatePlaylist(data.playlistId, data.userId);
  }
);
