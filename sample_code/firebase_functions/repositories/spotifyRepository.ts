import * as functions from "firebase-functions";
import admin from "firebase-admin";
import { MystifyPlaylist } from "../models/playlist/playlist";
import { ISpotifyRepository } from "./interfaces/iSpotifyRepository";
import { injectable, inject } from "inversify";
import { TYPES } from "../constants/types";
import { MySpotifyWebApi } from "../config/mySpotifyWebApi";
import { UserCredentials } from "../models/user/userCredentials";

const SPOTIFY_CLIENT_ID = "xxx";

@injectable()
export class SpotifyRepository implements ISpotifyRepository {
  private _spotifyApi: MySpotifyWebApi;

  public constructor(
    @inject(TYPES.MySpotifyWebApi) spotifyApi: MySpotifyWebApi
  ) {
    this._spotifyApi = spotifyApi;
  }

  async initialize(
    userCredentials: UserCredentials,
    clientSecret: string
  ): Promise<UserCredentials> {
    this._spotifyApi.setCredentials({
      clientId: SPOTIFY_CLIENT_ID,
      clientSecret: clientSecret,
      refreshToken: userCredentials.refreshToken,
      accessToken: userCredentials.accessToken,
    });

    // Because the Date was deserialized from JSON, it needs to be rebuilt to add the getTime() method to the prototype.
    // See stackoverflow.com/questions/2627650/why-javascript-gettime-is-not-a-function#
    const tokenExpirationMs = userCredentials.expiration.toDate().valueOf();
    const currentDateMs = new Date().valueOf();

    let updatedCredentials = userCredentials;

    if (currentDateMs > tokenExpirationMs) {
      const refreshAccessTokenResponse = await this._spotifyApi.refreshAccessToken();

      const updatedExpirationMs = Math.round(
        currentDateMs / 1000 + refreshAccessTokenResponse.body["expires_in"]
      );

      updatedCredentials = {
        refreshToken: (refreshAccessTokenResponse as any).body["refresh_token"],
        accessToken: refreshAccessTokenResponse.body["access_token"],
        expiration: new admin.firestore.Timestamp(updatedExpirationMs, 0),
      } as UserCredentials;

      this._spotifyApi.setAccessToken(updatedCredentials.accessToken);
      this._spotifyApi.setRefreshToken(updatedCredentials.refreshToken);
    }

    return updatedCredentials;
  }

  async getLikedTracks(): Promise<SpotifyApi.SavedTrackObject[]> {
    const tracks: SpotifyApi.SavedTrackObject[] = [];

    const limit = 50;
    let offset = 0;
    let total = 0;
    let next = "";

    while (next !== null && offset <= total) {
      const savedTracksResponse = await this._spotifyApi.getMySavedTracks({
        limit: limit,
        offset: offset,
      });

      for (const track of savedTracksResponse.body.items) {
        tracks.push(track);
      }

      total = savedTracksResponse.body.total;
      next = savedTracksResponse.body.next;
      offset += limit;
    }

    return tracks;
  }

  async getPlaylist(
    playlistId: string
  ): Promise<SpotifyApi.SinglePlaylistResponse> {
    const getPlaylistResponse = await this._spotifyApi.getPlaylist(playlistId);
    return getPlaylistResponse.body;
  }

  async changePlaylistDetails(
    playlistId: string,
    name: string,
    description: string | undefined
  ): Promise<void> {
    await this._spotifyApi.changePlaylistDetails(playlistId, {
      name: name,
      description: description === "" ? undefined : description,
    });
  }

  async getPlaylistTracks(
    playlistId: string
  ): Promise<SpotifyApi.TrackObjectFull[]> {
    const tracks: SpotifyApi.TrackObjectFull[] = [];

    const limit = 100;
    let offset = 0;
    let total = 0;
    let next = "";

    while (next !== null && offset <= total) {
      const playlistTracksResponse = await this._spotifyApi.getPlaylistTracks(
        playlistId,
        {
          limit: limit,
          offset: offset,
        }
      );

      for (const track of playlistTracksResponse.body.items) {
        tracks.push(track.track);
      }

      total = playlistTracksResponse.body.total;
      next = playlistTracksResponse.body.next;
      offset += limit;
    }

    return tracks;
  }

  async getAudioFeaturesForTracks(
    trackIds: string[]
  ): Promise<SpotifyApi.AudioFeaturesObject[]> {
    const audioFeatures: SpotifyApi.AudioFeaturesObject[] = [];

    const requestLimit = 100;

    for (let i = 0; i < trackIds.length; i += requestLimit) {
      const batch = trackIds.slice(i, i + requestLimit);
      const response = await this._spotifyApi.getAudioFeaturesForTracks(batch);

      for (const feature of response.body.audio_features) {
        audioFeatures.push(feature);
      }
    }

    console.log(
      `Retrieved audio features for ${audioFeatures.length} out of ${trackIds.length} requested tracks.`
    );

    return audioFeatures;
  }

  async getArtists(
    artistIds: string[]
  ): Promise<SpotifyApi.ArtistObjectFull[]> {
    const artists: SpotifyApi.ArtistObjectFull[] = [];

    const requestLimit = 50;

    for (let i = 0; i < artistIds.length; i += requestLimit) {
      const batch = artistIds.slice(i, i + requestLimit);
      const response = await this._spotifyApi.getArtists(batch);

      for (const artist of response.body.artists) {
        artists.push(artist);
      }
    }

    return artists;
  }

  async createPlaylist(
    playlist: MystifyPlaylist,
    makePublic: boolean
  ): Promise<SpotifyApi.CreatePlaylistResponse> {
    //https://developer.spotify.com/documentation/web-api/reference/playlists/create-playlist/

    const createPlaylistResponse = await this._spotifyApi.createPlaylist(
      playlist.userId,
      playlist.title,
      { description: playlist.description, public: makePublic }
    );

    if (
      createPlaylistResponse.statusCode === 200 ||
      createPlaylistResponse.statusCode === 201
    ) {
      return createPlaylistResponse.body;
    } else {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Could not create playlist on Spotify."
      );
    }
  }

  async addTracksToPlaylist(
    playlist: MystifyPlaylist,
    trackUris: string[]
  ): Promise<void> {
    const requestLimit = 100;

    for (let i = 0; i < trackUris.length; i += requestLimit) {
      const batch = trackUris.slice(i, i + requestLimit);
      await this._spotifyApi.addTracksToPlaylist(playlist.spotifyId, batch);
    }

    console.log(
      `Added ${trackUris.length} tracks to playlist. Id=${playlist.id}, SpotifyId=${playlist.spotifyId}, UserId=${playlist.userId}, Title=${playlist.title}.`
    );
  }

  async removeTracksFromPlaylist(
    playlist: MystifyPlaylist,
    tracks: SpotifyApi.TrackObjectFull[]
  ): Promise<void> {
    const requestLimit = 100;

    for (let i = 0; i < tracks.length; i += requestLimit) {
      const batch = tracks.slice(i, i + requestLimit);
      await this._spotifyApi.removeTracksFromPlaylist(
        playlist.spotifyId,
        batch
      );
    }

    console.log(
      `Removed ${tracks.length} tracks from playlist. Id=${playlist.id}, SpotifyId=${playlist.spotifyId}, UserId=${playlist.userId}, Title=${playlist.title}.`
    );
  }
}
