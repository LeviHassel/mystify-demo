export interface Filter {
  // All filters
  id: string;
  runtimeType: string;
  type: string;
  option?: string;

  // Date filter
  timeType?: string;
  timeLength?: number;
  year?: number;
  endingYear?: number;
  isOptionTrue?: boolean;

  // List filter
  items?: any[];

  // Slider filter
  start?: number;
  end?: number;

  // String filter
  value?: string;
}

export enum DateFilterOption {
  inTheLast = "inTheLast",
  inTheYear = "inTheYear",
  before = "before",
  after = "after",
  between = "between",
}

export enum DateFilterTimeType {
  day = "day",
  week = "week",
  month = "month",
  year = "year",
}

export enum DateFilterType {
  releaseDate = "releaseDate",
  saveDate = "saveDate",
}

export enum ListFilterOption {
  isAny = "isAny",
  isNotAny = "isNotAny",
  isAll = "isAll",
}

export enum ListFilterType {
  artist = "artist",
  genre = "genre",
  playlist = "playlist",
}

export enum SimpleFilterOption {
  isTrue = "isTrue",
  isFalse = "isFalse",
}

export enum SimpleFilterType {
  saved = "saved",
  explicit = "explicit",
}

export enum SliderFilterOption {
  isEqual = "isEqual",
  isNotEqual = "isNotEqual",
}

export enum SliderFilterType {
  energy = "energy",
  liveness = "liveness",
  danceability = "danceability",
  tempo = "tempo",
  duration = "duration",
  happiness = "happiness",
  speechiness = "speechiness",
  loudness = "loudness",
  instrumentalness = "instrumentalness",
  acousticness = "acousticness",
  trackPopularity = "trackPopularity",
  artistPopularity = "artistPopularity",
  artistFollowers = "artistFollowers",
}

export enum StringFilterOption {
  contains = "contains",
  doesNotContain = "doesNotContain",
  isEqual = "isEqual",
  isNotEqual = "isNotEqual",
}

export enum StringFilterType {
  songTitle = "songTitle",
}
