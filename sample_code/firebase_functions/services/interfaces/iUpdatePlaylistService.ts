import { MystifyPlaylist } from "../../models/playlist/playlist";

export interface IUpdatePlaylistService {
  updatePlaylist(playlistId: string, userId: string): Promise<void>;

  applyFilters(
    playlist: MystifyPlaylist,
    tracks: SpotifyApi.TrackObjectFull[]
  ): Promise<SpotifyApi.TrackObjectFull[]>;

  updateTracksOnSpotify(
    playlist: MystifyPlaylist,
    tracks: SpotifyApi.TrackObjectFull[]
  ): Promise<void>;
}
