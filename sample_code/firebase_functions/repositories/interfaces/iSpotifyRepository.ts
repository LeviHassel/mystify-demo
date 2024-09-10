import { MystifyPlaylist } from "../../models/playlist/playlist";
import { UserCredentials } from "../../models/user/userCredentials";

export interface ISpotifyRepository {
  initialize(
    userCredentials: UserCredentials,
    clientSecret: string
  ): Promise<UserCredentials>;

  getLikedTracks(): Promise<SpotifyApi.SavedTrackObject[]>;

  getPlaylist(playlistId: string): Promise<SpotifyApi.SinglePlaylistResponse>;

  changePlaylistDetails(
    playlistId: string,
    name: string,
    description: string | undefined
  ): Promise<void>;

  getPlaylistTracks(playlistId: string): Promise<SpotifyApi.TrackObjectFull[]>;

  getAudioFeaturesForTracks(
    trackIds: string[]
  ): Promise<SpotifyApi.AudioFeaturesObject[]>;

  getArtists(artistIds: string[]): Promise<SpotifyApi.ArtistObjectFull[]>;

  createPlaylist(
    playlist: MystifyPlaylist,
    makePublic: boolean
  ): Promise<SpotifyApi.CreatePlaylistResponse>;

  addTracksToPlaylist(
    playlist: MystifyPlaylist,
    trackUris: string[]
  ): Promise<void>;

  removeTracksFromPlaylist(
    playlist: MystifyPlaylist,
    tracks: SpotifyApi.TrackObjectFull[]
  ): Promise<void>;
}
