import { injectable, inject } from "inversify";
import { TYPES } from "../constants/types";
import {
  Filter,
  StringFilterType,
  SimpleFilterType,
  SliderFilterType,
} from "../models/playlist/filter";
import * as functions from "firebase-functions";
import { MystifyPlaylist } from "../models/playlist/playlist";
import { ISpotifyRepository } from "../repositories/interfaces/iSpotifyRepository";
import { IPlaylistRepository } from "../repositories/interfaces/iPlaylistRepository";
import { IFilterService } from "../services/interfaces/iFilterService";
import { IUpdatePlaylistService } from "./interfaces/iUpdatePlaylistService";
import { IUserRepository } from "../repositories/interfaces/iUserRepository";
import { IAuthService } from "./interfaces/iAuthService";
import {
  PlaylistSyncEvent,
  PlaylistSyncStatus,
} from "../models/playlist/playlistSyncEvent";
import admin from "firebase-admin";
import { IFunctionsRepository } from "../repositories/interfaces/iFunctionsRepository";

@injectable()
export class UpdatePlaylistService implements IUpdatePlaylistService {
  private _authService: IAuthService;
  private _filterService: IFilterService;
  private _spotifyRepository: ISpotifyRepository;
  private _playlistRepository: IPlaylistRepository;
  private _userRepository: IUserRepository;
  private _functionsRepository: IFunctionsRepository;
  private _audioFeatures?: SpotifyApi.AudioFeaturesObject[];
  private _savedTracks?: SpotifyApi.SavedTrackObject[];
  private _artists?: SpotifyApi.ArtistObjectFull[];

  constructor(
    @inject(TYPES.IAuthService) authService: IAuthService,
    @inject(TYPES.IFilterService) filterService: IFilterService,
    @inject(TYPES.ISpotifyRepository) spotifyRepository: ISpotifyRepository,
    @inject(TYPES.IPlaylistRepository) playlistRepository: IPlaylistRepository,
    @inject(TYPES.IUserRepository) userRepository: IUserRepository,
    @inject(TYPES.IFunctionsRepository)
    functionsRepository: IFunctionsRepository
  ) {
    this._authService = authService;
    this._filterService = filterService;
    this._spotifyRepository = spotifyRepository;
    this._playlistRepository = playlistRepository;
    this._userRepository = userRepository;
    this._functionsRepository = functionsRepository;
  }

  async updatePlaylist(playlistId: string, userId: string): Promise<void> {
    let playlist = await this._playlistRepository.getPlaylist(playlistId);

    if (playlist.userId !== userId) {
      throw new functions.https.HttpsError(
        "permission-denied",
        `The calling user does not own this playlist. Calling UserId: ${userId}, Playlist UserId: ${playlist.userId}.`
      );
    }

    try {
      const user = await this._userRepository.getUser(userId);
      await this._authService.connectToSpotify(user);

      playlist = await this.updatePlaylistInfo(
        playlist,
        PlaylistSyncStatus.inProgress
      );

      let tracks = await this.getTracksFromSources(playlist);

      tracks = await this.applyFilters(playlist, tracks);

      playlist = await this.createSpotifyPlaylistIfNew(
        playlist,
        user.settings.makeNewPlaylistsPublic
      );

      await this.updateTracksOnSpotify(playlist, tracks);

      playlist = await this.updatePlaylistInfo(
        playlist,
        PlaylistSyncStatus.success
      );
    } catch (e) {
      console.log(e);

      playlist = await this.updatePlaylistInfo(
        playlist,
        PlaylistSyncStatus.failure
      );

      // Retry updating the playlist automatically twice.
      // Users can then manually sync it, driving the retryCount above 2.
      if (playlist.lastSyncEvent.retryCount < 2) {
        this._functionsRepository.updatePlaylist(playlistId, userId);
      }
    }
  }

  async getTracksFromSources(
    playlist: MystifyPlaylist
  ): Promise<SpotifyApi.TrackObjectFull[]> {
    this._savedTracks = await this._spotifyRepository.getLikedTracks();
    return this._savedTracks.map((savedTrack) => savedTrack.track);
  }

  async applyFilters(
    playlist: MystifyPlaylist,
    tracks: SpotifyApi.TrackObjectFull[]
  ): Promise<SpotifyApi.TrackObjectFull[]> {
    let updatedTracks = tracks;
    for (const filter of playlist.filters) {
      updatedTracks = await this._getFilteredTracks(filter, updatedTracks);

      console.log(
        `Track length after applying ${filter.type} filter is ${updatedTracks.length}.`
      );
    }

    return updatedTracks;
  }

  async createSpotifyPlaylistIfNew(
    playlist: MystifyPlaylist,
    makePublic: boolean
  ): Promise<MystifyPlaylist> {
    if (playlist.spotifyId === null || !playlist.spotifyId.length) {
      const createPlaylistResponse = await this._spotifyRepository.createPlaylist(
        playlist,
        makePublic
      );

      playlist.spotifyId = createPlaylistResponse.id;
    }

    return playlist;
  }

  async updateTracksOnSpotify(
    playlist: MystifyPlaylist,
    tracks: SpotifyApi.TrackObjectFull[]
  ): Promise<void> {
    const currentTracks =
      playlist.songCount !== undefined && playlist.songCount > 0
        ? await this._spotifyRepository.getPlaylistTracks(playlist.spotifyId)
        : [];

    const currentTrackUris = currentTracks.map((track) => track.uri);

    const trackUris = tracks.map((track) => track.uri);

    const trackUrisToAdd = trackUris.filter(
      (uri) => !currentTrackUris.includes(uri)
    );

    const tracksToRemove = currentTracks
      .filter((track) => !trackUris.includes(track.uri))
      .map((track) => <SpotifyApi.TrackObjectFull>{ uri: track.uri });

    console.log(
      `Updating playlist tracks in Spotify. Track Lengths: Previous=${currentTrackUris.length}, Desired=${trackUris.length}, Adding=${trackUrisToAdd.length}, Removing=${tracksToRemove.length}.`
    );

    if (trackUrisToAdd.length) {
      await this._spotifyRepository.addTracksToPlaylist(
        playlist,
        trackUrisToAdd
      );
    }

    if (tracksToRemove.length) {
      await this._spotifyRepository.removeTracksFromPlaylist(
        playlist,
        tracksToRemove
      );
    }
  }

  async updatePlaylistInfo(
    playlist: MystifyPlaylist,
    syncStatus: PlaylistSyncStatus
  ): Promise<MystifyPlaylist> {
    try {
      const getPlaylistResponse = await this._spotifyRepository.getPlaylist(
        playlist.spotifyId
      );

      if (syncStatus === PlaylistSyncStatus.inProgress) {
        if (
          playlist.title !== getPlaylistResponse.name ||
          playlist.description !== getPlaylistResponse.description
        ) {
          if (playlist.dateModified > playlist.lastSyncEvent?.statusDate) {
            console.log(
              `Playlist details have changed in Mystify, updating details in Spotify. NewTitle=${playlist.title}, NewDescription=${playlist.description}, OldTitle=${getPlaylistResponse.name}, OldDescription=${getPlaylistResponse.description}.`
            );

            await this._spotifyRepository.changePlaylistDetails(
              playlist.spotifyId,
              playlist.title,
              playlist.description ?? undefined
            );
          } else {
            console.log(
              `Playlist details have changed in Spotify, updating details in Mystify. NewTitle=${getPlaylistResponse.name}, NewDescription=${getPlaylistResponse.description}, OldTitle=${playlist.title}, OldDescription=${playlist.description}.`
            );

            playlist.title = getPlaylistResponse.name;
            playlist.description = getPlaylistResponse.description ?? undefined;
          }
        }
      } else {
        if (getPlaylistResponse.images.length) {
          playlist.image = getPlaylistResponse.images[0].url;
        }

        playlist.songCount = getPlaylistResponse.tracks.total;
      }
    } catch (e) {
      console.log(e);
    }

    let retryCount = playlist.lastSyncEvent.retryCount;

    if (playlist.lastSyncEvent.status === PlaylistSyncStatus.failure) {
      retryCount = playlist.lastSyncEvent.retryCount + 1;
    }

    if (playlist.lastSyncEvent.status === PlaylistSyncStatus.success) {
      retryCount = 0;
    }

    playlist.lastSyncEvent = {
      status: syncStatus,
      statusDate: admin.firestore.Timestamp.now(),
      retryCount: retryCount,
    } as PlaylistSyncEvent;

    await this._playlistRepository.updatePlaylist(playlist);

    return playlist;
  }

  async _getFilteredTracks(
    filter: Filter,
    tracks: SpotifyApi.TrackObjectFull[]
  ): Promise<SpotifyApi.TrackObjectFull[]> {
    switch (filter.type) {
      case StringFilterType.songTitle: {
        return this._filterService.applyTrackTitleFilter(filter, tracks);
      }
      case SimpleFilterType.explicit: {
        return this._filterService.applyExplicitFilter(filter, tracks);
      }
      case SimpleFilterType.saved: {
        const savedTracks = await this._getSavedTracks();

        return this._filterService.applySavedFilter(
          filter,
          tracks,
          savedTracks.map((track) => track.track.id)
        );
      }
      case SliderFilterType.energy: {
        const audioFeatures = await this._getAudioFeatures(tracks);

        return this._filterService.applySliderFilter(
          filter,
          tracks,
          new Map(
            audioFeatures.map((feature) => [feature.id, feature.energy * 100])
          )
        );
      }
      case SliderFilterType.liveness: {
        const audioFeatures = await this._getAudioFeatures(tracks);

        return this._filterService.applySliderFilter(
          filter,
          tracks,
          new Map(
            audioFeatures.map((feature) => [feature.id, feature.liveness * 100])
          )
        );
      }
      case SliderFilterType.danceability: {
        const audioFeatures = await this._getAudioFeatures(tracks);

        return this._filterService.applySliderFilter(
          filter,
          tracks,
          new Map(
            audioFeatures.map((feature) => [
              feature.id,
              feature.danceability * 100,
            ])
          )
        );
      }
      case SliderFilterType.happiness: {
        const audioFeatures = await this._getAudioFeatures(tracks);

        return this._filterService.applySliderFilter(
          filter,
          tracks,
          new Map(
            audioFeatures.map((feature) => [feature.id, feature.valence * 100])
          )
        );
      }
      case SliderFilterType.speechiness: {
        const audioFeatures = await this._getAudioFeatures(tracks);

        return this._filterService.applySliderFilter(
          filter,
          tracks,
          new Map(
            audioFeatures.map((feature) => [
              feature.id,
              feature.speechiness * 100,
            ])
          )
        );
      }
      case SliderFilterType.instrumentalness: {
        const audioFeatures = await this._getAudioFeatures(tracks);

        return this._filterService.applySliderFilter(
          filter,
          tracks,
          new Map(
            audioFeatures.map((feature) => [
              feature.id,
              feature.instrumentalness * 100,
            ])
          )
        );
      }
      case SliderFilterType.acousticness: {
        const audioFeatures = await this._getAudioFeatures(tracks);

        return this._filterService.applySliderFilter(
          filter,
          tracks,
          new Map(
            audioFeatures.map((feature) => [
              feature.id,
              feature.acousticness * 100,
            ])
          )
        );
      }
      case SliderFilterType.trackPopularity: {
        return this._filterService.applySliderFilter(
          filter,
          tracks,
          new Map(tracks.map((track) => [track.id, track.popularity]))
        );
      }
      case SliderFilterType.artistPopularity: {
        const artists = await this._getArtists(tracks);

        return this._filterService.applySliderFilter(
          filter,
          tracks,
          new Map(
            tracks.map((track) => [
              track.id,
              artists.find((artist) => artist.id === track.artists[0].id)
                ?.popularity ?? 0,
            ])
          )
        );
      }
      default: {
        // TODO: Add support for remaining Filter types
        return tracks;
      }
    }
  }

  async _getSavedTracks(): Promise<SpotifyApi.SavedTrackObject[]> {
    if (this._savedTracks === undefined) {
      this._savedTracks = await this._spotifyRepository.getLikedTracks();
    }

    return this._savedTracks;
  }

  async _getAudioFeatures(
    tracks: SpotifyApi.TrackObjectFull[]
  ): Promise<SpotifyApi.AudioFeaturesObject[]> {
    if (this._audioFeatures === undefined) {
      const trackIds = tracks.map((track) => track.id);
      this._audioFeatures = await this._spotifyRepository.getAudioFeaturesForTracks(
        trackIds
      );
    }
    else if (this._audioFeatures.length > tracks.length) {
      const trackIds = tracks.map((track) => track.id);

      this._audioFeatures = this._audioFeatures.filter((feature) =>
        trackIds.includes(feature.id)
      );
    }

    return this._audioFeatures;
  }

  async _getArtists(
    tracks: SpotifyApi.TrackObjectFull[]
  ): Promise<SpotifyApi.ArtistObjectFull[]> {
    if (this._artists === undefined) {
      const artistIds = tracks.map((track) => track.artists[0].id);
      const uniqueArtistsIds = [...new Set(artistIds)];
      this._artists = await this._spotifyRepository.getArtists(
        uniqueArtistsIds
      );
    }

    return this._artists;
  }
}
