import 'package:mystify/data/models/playlists/filters/filter.dart';
import 'package:mystify/data/models/playlists/filters/list_filter/list_filter.dart';
import 'package:mystify/data/models/playlists/filters/list_filter/list_filter_item.dart';
import 'package:mystify/data/models/playlists/filters/list_filter/list_filter_option.dart';
import 'package:mystify/ui/screens/edit_playlist/edit_playlist_vm.dart';
import 'package:mystify/ui/shared/view_models/base_vm.dart';

class ListFilterBodyVM extends BaseVM {
  ListFilter _filter;
  ListFilterOption _option;
  List<ListFilterItem> _listItems;
  void Function(Filter) _updateFilter;

  ListFilter get filter => _filter;
  ListFilterOption get option => _option;
  List<ListFilterItem> get listItems => _listItems;

  void init(ListFilter filter) {
    setBusy(true);
    _filter = filter;
    _option = filter.option;
    _listItems = filter.items.toList();
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

  void setOption(ListFilterOption option) {
    _option = option;
    _filter.option = _option;
    _updateFilter(_filter);
    notifyListeners();
  }

  void addListItem(ListFilterItem item) {
    _listItems.add(item);
    _updateListItems();
  }

  void removeListItem(ListFilterItem item) {
    _listItems.remove(item);
    _updateListItems();
  }

  void _updateListItems() {
    _filter.items = _listItems;
    _updateFilter(_filter);
    notifyListeners();
  }
}
