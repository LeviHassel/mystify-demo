import {
  Filter,
  StringFilterOption,
  SimpleFilterOption,
  SliderFilterOption,
} from "../models/playlist/filter";
import { IFilterService } from "./interfaces/iFilterService";
import { injectable } from "inversify";

@injectable()
export class FilterService implements IFilterService {
  applyTrackTitleFilter(
    filter: Filter,
    tracks: SpotifyApi.TrackObjectFull[]
  ): SpotifyApi.TrackObjectFull[] {
    const songTitle = filter.value?.toLowerCase();

    if (!songTitle) {
      return tracks;
    }

    switch (filter.option) {
      case StringFilterOption.contains: {
        return tracks.filter((track) =>
          track.name.toLowerCase().includes(songTitle)
        );
      }
      case StringFilterOption.doesNotContain: {
        return tracks.filter(
          (track) => !track.name.toLowerCase().includes(songTitle)
        );
      }
      case StringFilterOption.isEqual: {
        return tracks.filter((track) => track.name.toLowerCase() === songTitle);
      }
      case StringFilterOption.isNotEqual: {
        return tracks.filter((track) => track.name.toLowerCase() !== songTitle);
      }
      default: {
        return tracks;
      }
    }
  }

  applyExplicitFilter(
    filter: Filter,
    tracks: SpotifyApi.TrackObjectFull[]
  ): SpotifyApi.TrackObjectFull[] {
    switch (filter.option) {
      case SimpleFilterOption.isTrue: {
        return tracks.filter((track) => track.explicit);
      }
      case SimpleFilterOption.isFalse: {
        return tracks.filter((track) => !track.explicit);
      }
      default: {
        return tracks;
      }
    }
  }

  applySavedFilter(
    filter: Filter,
    tracks: SpotifyApi.TrackObjectFull[],
    savedTrackIds: string[]
  ): SpotifyApi.TrackObjectFull[] {
    switch (filter.option) {
      case SimpleFilterOption.isTrue: {
        return tracks.filter((track) => savedTrackIds.includes(track.id));
      }
      case SimpleFilterOption.isFalse: {
        return tracks.filter((track) => !savedTrackIds.includes(track.id));
      }
      default: {
        return tracks;
      }
    }
  }

  applySliderFilter(
    filter: Filter,
    tracks: SpotifyApi.TrackObjectFull[],
    trackIdValueMap: Map<string, number>
  ): SpotifyApi.TrackObjectFull[] {
    return tracks.filter((track) => {
      const sliderValue = trackIdValueMap.get(track.id);

      if (
        sliderValue === undefined ||
        filter.start === undefined ||
        filter.end === undefined
      ) {
        return true;
      }

      const filterStart = filter.start - 10;
      const filterEnd = filter.end + 10;
      const valueInRange =
        sliderValue >= filterStart && sliderValue <= filterEnd;

      console.log(
        `Applying Slider Filter to Track. Id=${track.id}, Value=${sliderValue}, FilterStart=${filterStart}, FilterEnd=${filterEnd}, InRange=${valueInRange}, Option=${filter.option}.`
      );

      switch (filter.option) {
        case SliderFilterOption.isEqual: {
          return valueInRange;
        }
        case SliderFilterOption.isNotEqual: {
          return !valueInRange;
        }
        default: {
          return true;
        }
      }
    });
  }
}
