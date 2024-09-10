import 'package:flutter/material.dart';
import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/data/models/playlists/filters/slider_filter/slider_filter.dart';
import 'package:mystify/data/models/playlists/filters/slider_filter/slider_filter_option.dart';
import 'package:mystify/ui/screens/edit_playlist/edit_playlist_vm.dart';
import 'package:mystify/ui/shared/view_models/base_vm.dart';

class SliderFilterBodyVM extends BaseVM {
  SliderFilter _filter;
  SliderFilterOption _option;
  RangeValues _sliderValues;
  void Function(Filter) _updateFilter;

  SliderFilter get filter => _filter;
  SliderFilterOption get option => _option;
  RangeValues get sliderValues => _sliderValues;

  void init(SliderFilter filter) async {
    setBusy(true);
    _filter = filter;
    _option = filter.option;
    _sliderValues = RangeValues(filter.start, filter.end);
    setBusy(false);
  }

  void onChange(EditPlaylistVM vm) {
    setUpdateFilter(vm.updateFilter);
  }

  void setUpdateFilter(void Function(Filter) updateFilter) {
    if (updateFilter != _updateFilter) {
      _updateFilter = updateFilter;
      notifyListeners();
    }
  }

  void setOption(SliderFilterOption option) {
    _option = option;
    _filter.option = _option;
    _updateFilter(_filter);
    notifyListeners();
  }

  void setSliderValues(RangeValues values) {
    _sliderValues = values;
    _filter.start = _sliderValues.start;
    _filter.end = _sliderValues.end;
    _updateFilter(_filter);
    notifyListeners();
  }
}
