import { Filter } from "../../models/playlist/filter";

export interface IFilterService {
  applyTrackTitleFilter(
    filter: Filter,
    tracks: SpotifyApi.TrackObjectFull[]
  ): SpotifyApi.TrackObjectFull[];

  applyExplicitFilter(
    filter: Filter,
    tracks: SpotifyApi.TrackObjectFull[]
  ): SpotifyApi.TrackObjectFull[];

  applySavedFilter(
    filter: Filter,
    tracks: SpotifyApi.TrackObjectFull[],
    savedTrackIds: string[]
  ): SpotifyApi.TrackObjectFull[];

  applySliderFilter(
    filter: Filter,
    tracks: SpotifyApi.TrackObjectFull[],
    trackIdValueMap: Map<string, number>
  ): SpotifyApi.TrackObjectFull[];
}
