import { FilterService } from "../../services/filterService";
import {
  Filter,
  StringFilterType,
  StringFilterOption,
  SimpleFilterType,
  SimpleFilterOption,
  SliderFilterType,
  SliderFilterOption,
} from "../../models/playlist/filter";

let _filterService: FilterService;

beforeAll(() => {
  _filterService = new FilterService();
});

describe("applyTrackTitleFilter", () => {
  let _defaultFilter: Filter;
  let _whatADayTrack: SpotifyApi.TrackObjectFull;
  let _wellThenTrack: SpotifyApi.TrackObjectFull;
  let _defaultTracks: SpotifyApi.TrackObjectFull[];

  beforeEach(() => {
    _defaultFilter = {
      type: StringFilterType.songTitle,
      value: "day",
      option: StringFilterOption.isEqual,
    } as Filter;

    _whatADayTrack = { name: "What a Day" } as SpotifyApi.TrackObjectFull;
    _wellThenTrack = { name: "Well Then" } as SpotifyApi.TrackObjectFull;

    _defaultTracks = [_whatADayTrack, _wellThenTrack];
  });

  test("applying filter to empty list of tracks returns empty list", () => {
    const expectedTracks: SpotifyApi.TrackObjectFull[] = [];

    const actualTracks = _filterService.applyTrackTitleFilter(
      _defaultFilter,
      expectedTracks
    );

    expect(actualTracks).toEqual(expectedTracks);
  });

  test("applying filter without value returns original tracks", () => {
    const filter = _defaultFilter;
    filter.value = undefined;

    const actualTracks = _filterService.applyTrackTitleFilter(
      filter,
      _defaultTracks
    );

    expect(actualTracks).toEqual(_defaultTracks);
  });

  test("applying filter with empty value returns original tracks", () => {
    const filter = _defaultFilter;
    filter.value = "";

    const actualTracks = _filterService.applyTrackTitleFilter(
      filter,
      _defaultTracks
    );

    expect(actualTracks).toEqual(_defaultTracks);
  });

  test("applying filter without option returns original tracks", () => {
    const filter = _defaultFilter;
    filter.option = undefined;

    const actualTracks = _filterService.applyTrackTitleFilter(
      filter,
      _defaultTracks
    );

    expect(actualTracks).toEqual(_defaultTracks);
  });

  test("applying filter with invalid option returns original tracks", () => {
    const filter = _defaultFilter;
    filter.option = "thisIsWrong";

    const actualTracks = _filterService.applyTrackTitleFilter(
      filter,
      _defaultTracks
    );

    expect(actualTracks).toEqual(_defaultTracks);
  });

  test("applying filter returns only tracks that contain the value", () => {
    const filter = _defaultFilter;
    filter.option = StringFilterOption.contains;
    filter.value = "day";

    const expectedTracks: SpotifyApi.TrackObjectFull[] = [_whatADayTrack];

    const actualTracks = _filterService.applyTrackTitleFilter(
      filter,
      _defaultTracks
    );

    expect(actualTracks).toEqual(expectedTracks);
  });

  test("applying filter returns only tracks that equal the value", () => {
    const filter = _defaultFilter;
    filter.option = StringFilterOption.isEqual;
    filter.value = "Well Then";

    const expectedTracks: SpotifyApi.TrackObjectFull[] = [_wellThenTrack];

    const actualTracks = _filterService.applyTrackTitleFilter(
      filter,
      _defaultTracks
    );

    expect(actualTracks).toEqual(expectedTracks);
  });

  test("applying filter returns only tracks that do not contain the value", () => {
    const filter = _defaultFilter;
    filter.option = StringFilterOption.doesNotContain;
    filter.value = "Then";

    const expectedTracks: SpotifyApi.TrackObjectFull[] = [_whatADayTrack];

    const actualTracks = _filterService.applyTrackTitleFilter(
      filter,
      _defaultTracks
    );

    expect(actualTracks).toEqual(expectedTracks);
  });

  test("applying filter returns only tracks that do not equal the value", () => {
    const filter = _defaultFilter;
    filter.option = StringFilterOption.isNotEqual;
    filter.value = "WHAT A DAY";

    const expectedTracks: SpotifyApi.TrackObjectFull[] = [_wellThenTrack];

    const actualTracks = _filterService.applyTrackTitleFilter(
      filter,
      _defaultTracks
    );

    expect(actualTracks).toEqual(expectedTracks);
  });
});

describe("applyExplicitFilter", () => {
  let _defaultFilter: Filter;
  let _explicitTrack: SpotifyApi.TrackObjectFull;
  let _cleanTrack: SpotifyApi.TrackObjectFull;
  let _defaultTracks: SpotifyApi.TrackObjectFull[];

  beforeEach(() => {
    _defaultFilter = {
      type: SimpleFilterType.explicit,
      option: SimpleFilterOption.isTrue,
    } as Filter;

    _cleanTrack = {
      name: "Good",
      explicit: false,
    } as SpotifyApi.TrackObjectFull;

    _explicitTrack = {
      name: "Bad",
      explicit: true,
    } as SpotifyApi.TrackObjectFull;

    _defaultTracks = [_cleanTrack, _explicitTrack];
  });

  test("applying filter to empty list of tracks returns empty list", () => {
    const expectedTracks: SpotifyApi.TrackObjectFull[] = [];

    const actualTracks = _filterService.applyExplicitFilter(
      _defaultFilter,
      expectedTracks
    );

    expect(actualTracks).toEqual(expectedTracks);
  });

  test("applying filter without option returns original tracks", () => {
    const filter = _defaultFilter;
    filter.option = undefined;

    const actualTracks = _filterService.applyExplicitFilter(
      filter,
      _defaultTracks
    );

    expect(actualTracks).toEqual(_defaultTracks);
  });

  test("applying filter with invalid option returns original tracks", () => {
    const filter = _defaultFilter;
    filter.option = "thisIsWrong";

    const actualTracks = _filterService.applyExplicitFilter(
      filter,
      _defaultTracks
    );

    expect(actualTracks).toEqual(_defaultTracks);
  });

  test("applying filter returns only explicit tracks", () => {
    const filter = _defaultFilter;
    filter.option = SimpleFilterOption.isTrue;

    const expectedTracks: SpotifyApi.TrackObjectFull[] = [_explicitTrack];

    const actualTracks = _filterService.applyExplicitFilter(
      filter,
      _defaultTracks
    );

    expect(actualTracks).toEqual(expectedTracks);
  });

  test("applying filter returns only clean tracks", () => {
    const filter = _defaultFilter;
    filter.option = SimpleFilterOption.isFalse;

    const expectedTracks: SpotifyApi.TrackObjectFull[] = [_cleanTrack];

    const actualTracks = _filterService.applyExplicitFilter(
      filter,
      _defaultTracks
    );

    expect(actualTracks).toEqual(expectedTracks);
  });
});

describe("applySavedFilter", () => {
  let _defaultFilter: Filter;
  let _savedTrack: SpotifyApi.TrackObjectFull;
  let _unsavedTrack: SpotifyApi.TrackObjectFull;
  let _defaultTracks: SpotifyApi.TrackObjectFull[];
  let _defaultSavedTrackIds: string[];

  beforeEach(() => {
    _defaultFilter = {
      type: SimpleFilterType.explicit,
      option: SimpleFilterOption.isTrue,
    } as Filter;

    _savedTrack = {
      id: "1",
    } as SpotifyApi.TrackObjectFull;

    _unsavedTrack = {
      id: "2",
    } as SpotifyApi.TrackObjectFull;

    _defaultTracks = [_savedTrack, _unsavedTrack];

    _defaultSavedTrackIds = ["1", "3"];
  });

  test("applying filter to empty list of tracks returns empty list", () => {
    const expectedTracks: SpotifyApi.TrackObjectFull[] = [];

    const actualTracks = _filterService.applySavedFilter(
      _defaultFilter,
      expectedTracks,
      _defaultSavedTrackIds
    );

    expect(actualTracks).toEqual(expectedTracks);
  });

  test("applying filter without option returns original tracks", () => {
    const filter = _defaultFilter;
    filter.option = undefined;

    const actualTracks = _filterService.applySavedFilter(
      filter,
      _defaultTracks,
      _defaultSavedTrackIds
    );

    expect(actualTracks).toEqual(_defaultTracks);
  });

  test("applying filter with invalid option returns original tracks", () => {
    const filter = _defaultFilter;
    filter.option = "thisIsWrong";

    const actualTracks = _filterService.applySavedFilter(
      filter,
      _defaultTracks,
      _defaultSavedTrackIds
    );

    expect(actualTracks).toEqual(_defaultTracks);
  });

  test("applying filter returns only saved tracks", () => {
    const filter = _defaultFilter;
    filter.option = SimpleFilterOption.isTrue;

    const expectedTracks: SpotifyApi.TrackObjectFull[] = [_savedTrack];

    const actualTracks = _filterService.applySavedFilter(
      filter,
      _defaultTracks,
      _defaultSavedTrackIds
    );

    expect(actualTracks).toEqual(expectedTracks);
  });

  test("applying filter returns only unsaved tracks", () => {
    const filter = _defaultFilter;
    filter.option = SimpleFilterOption.isFalse;

    const expectedTracks: SpotifyApi.TrackObjectFull[] = [_unsavedTrack];

    const actualTracks = _filterService.applySavedFilter(
      filter,
      _defaultTracks,
      _defaultSavedTrackIds
    );

    expect(actualTracks).toEqual(expectedTracks);
  });
});

describe("applySliderFilter", () => {
  let _defaultFilter: Filter;
  let _lowValueTrack: SpotifyApi.TrackObjectFull;
  let _edgeValueTrack: SpotifyApi.TrackObjectFull;
  let _averageValueTrack: SpotifyApi.TrackObjectFull;
  let _highValueTrack: SpotifyApi.TrackObjectFull;
  let _defaultTracks: SpotifyApi.TrackObjectFull[];
  let _defaultTrackIdValueMap: Map<string, number>;

  beforeEach(() => {
    _defaultFilter = {
      type: SliderFilterType.energy,
      option: SliderFilterOption.isEqual,
      start: 30,
      end: 70,
    } as Filter;

    _lowValueTrack = {
      id: "1",
    } as SpotifyApi.TrackObjectFull;

    _edgeValueTrack = {
      id: "2",
    } as SpotifyApi.TrackObjectFull;

    _averageValueTrack = {
      id: "3",
    } as SpotifyApi.TrackObjectFull;

    _highValueTrack = {
      id: "4",
    } as SpotifyApi.TrackObjectFull;

    _defaultTracks = [
      _lowValueTrack,
      _edgeValueTrack,
      _averageValueTrack,
      _highValueTrack,
    ];

    _defaultTrackIdValueMap = new Map();
    _defaultTrackIdValueMap.set(_lowValueTrack.id, 10);
    _defaultTrackIdValueMap.set(_edgeValueTrack.id, 30);
    _defaultTrackIdValueMap.set(_averageValueTrack.id, 50);
    _defaultTrackIdValueMap.set(_highValueTrack.id, 90);
  });

  test("applying filter to empty list of tracks returns empty list", () => {
    const expectedTracks: SpotifyApi.TrackObjectFull[] = [];

    const actualTracks = _filterService.applySliderFilter(
      _defaultFilter,
      expectedTracks,
      _defaultTrackIdValueMap
    );

    expect(actualTracks).toEqual(expectedTracks);
  });

  test("applying filter without option returns original tracks", () => {
    const filter = _defaultFilter;
    filter.option = undefined;

    const actualTracks = _filterService.applySliderFilter(
      filter,
      _defaultTracks,
      _defaultTrackIdValueMap
    );

    expect(actualTracks).toEqual(_defaultTracks);
  });

  test("applying filter with invalid option returns original tracks", () => {
    const filter = _defaultFilter;
    filter.option = "thisIsWrong";

    const actualTracks = _filterService.applySliderFilter(
      filter,
      _defaultTracks,
      _defaultTrackIdValueMap
    );

    expect(actualTracks).toEqual(_defaultTracks);
  });

  test("applying filter without start returns original tracks", () => {
    const filter = _defaultFilter;
    filter.start = undefined;

    const actualTracks = _filterService.applySliderFilter(
      filter,
      _defaultTracks,
      _defaultTrackIdValueMap
    );

    expect(actualTracks).toEqual(_defaultTracks);
  });

  test("applying filter without end returns original tracks", () => {
    const filter = _defaultFilter;
    filter.end = undefined;

    const actualTracks = _filterService.applySliderFilter(
      filter,
      _defaultTracks,
      _defaultTrackIdValueMap
    );

    expect(actualTracks).toEqual(_defaultTracks);
  });

  test("applying filter returns only tracks with values in range", () => {
    const filter = _defaultFilter;
    filter.option = SliderFilterOption.isEqual;

    const expectedTracks: SpotifyApi.TrackObjectFull[] = [
      _edgeValueTrack,
      _averageValueTrack,
    ];

    const actualTracks = _filterService.applySliderFilter(
      filter,
      _defaultTracks,
      _defaultTrackIdValueMap
    );

    expect(actualTracks).toEqual(expectedTracks);
  });

  test("applying filter returns only tracks with values out of range", () => {
    const filter = _defaultFilter;
    filter.option = SliderFilterOption.isNotEqual;

    const expectedTracks: SpotifyApi.TrackObjectFull[] = [
      _lowValueTrack,
      _highValueTrack,
    ];

    const actualTracks = _filterService.applySliderFilter(
      filter,
      _defaultTracks,
      _defaultTrackIdValueMap
    );

    expect(actualTracks).toEqual(expectedTracks);
  });

  test("applying full range filter returns all tracks", () => {
    const filter = _defaultFilter;
    filter.option = SliderFilterOption.isEqual;
    filter.start = 10;
    filter.end = 90;

    const actualTracks = _filterService.applySliderFilter(
      filter,
      _defaultTracks,
      _defaultTrackIdValueMap
    );

    expect(actualTracks).toEqual(_defaultTracks);
  });
});
