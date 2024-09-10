import 'package:flutter/material.dart';
import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/data/models/playlists/filters/string_filter/string_filter.dart';
import 'package:mystify/data/models/playlists/filters/string_filter/string_filter_option.dart';
import 'package:mystify/ui/screens/edit_playlist/edit_playlist_vm.dart';
import 'package:mystify/ui/shared/view_models/base_vm.dart';

class StringFilterBodyVM extends BaseVM {
  StringFilter _filter;
  StringFilterOption _option;
  final _textController = TextEditingController();
  void Function(Filter) _updateFilter;

  StringFilter get filter => _filter;
  StringFilterOption get option => _option;
  TextEditingController get textController => _textController;

  void init(StringFilter filter) async {
    setBusy(true);
    _filter = filter;
    _option = filter.option;
    _textController.text = filter.value;
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

  void setOption(StringFilterOption option) {
    _option = option;
    _filter.option = _option;
    _updateFilter(_filter);
    notifyListeners();
  }

  void setValue(String value) {
    _filter.value = value.trim();
    _updateFilter(_filter);
    notifyListeners();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
