import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/data/models/playlists/filters/simple_filter/simple_filter.dart';
import 'package:mystify/data/models/playlists/filters/simple_filter/simple_filter_option.dart';
import 'package:mystify/ui/screens/edit_playlist/edit_playlist_vm.dart';
import 'package:mystify/ui/shared/view_models/base_vm.dart';

class SimpleFilterBodyVM extends BaseVM {
  SimpleFilter _filter;
  SimpleFilterOption _option;
  void Function(Filter) _updateFilter;

  SimpleFilter get filter => _filter;
  SimpleFilterOption get option => _option;

  void init(SimpleFilter filter) async {
    setBusy(true);
    _filter = filter;
    _option = filter.option;
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

  void setOption(SimpleFilterOption option) {
    _option = option;
    _filter.option = _option;
    _updateFilter(_filter);
    notifyListeners();
  }
}
