import 'package:flutter/material.dart';
import 'package:mystify/ui/screens/edit_playlist/edit_playlist_vm.dart';
import 'package:mystify/ui/shared/view_models/base_vm.dart';
import 'package:mystify/data/models/playlists/filters/date_filter/date_filter.dart';
import 'package:mystify/data/models/playlists/filters/date_filter/date_filter_option.dart';
import 'package:mystify/data/models/playlists/filters/date_filter/date_filter_time_type.dart';
import 'package:mystify/data/models/playlists/filters/filter.dart';

class DateFilterBodyVM extends BaseVM {
  DateFilter _filter;
  DateFilterOption _option;
  bool _isOptionTrue;
  DateFilterTimeType _timeType;
  final TextEditingController _timeLengthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _endingYearController = TextEditingController();
  void Function(Filter) _updateFilter;

  DateFilter get filter => _filter;
  DateFilterOption get option => _option;
  bool get isOptionTrue => _isOptionTrue;
  DateFilterTimeType get timeType => _timeType;
  TextEditingController get timeLengthController => _timeLengthController;
  TextEditingController get yearController => _yearController;
  TextEditingController get endingYearController => _endingYearController;

  void init(DateFilter filter) async {
    setBusy(true);
    _filter = filter;
    _option = filter.option;
    _isOptionTrue = filter.isOptionTrue;
    _timeType = filter.timeType;
    _timeLengthController.text =
        filter.timeLength != null ? filter.timeLength.toString() : '';
    _yearController.text = filter.year != null ? filter.year.toString() : '';
    _endingYearController.text =
        filter.endingYear != null ? filter.endingYear.toString() : '';
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

  void setOption(DateFilterOption option) {
    var previousOption = _option;
    _option = option;

    if (_option == previousOption) {
      return;
    }

    if (_option == DateFilterOption.inTheLast) {
      _yearController.text = '';
      _endingYearController.text = '';
      _timeType = DateFilterTimeType.month;
      _filter.option = _option;
      _filter.timeType = _timeType;
      _filter.year = int.tryParse(_yearController.text);
      _filter.endingYear = int.tryParse(_endingYearController.text);
    } else if (previousOption == DateFilterOption.between) {
      _endingYearController.text = '';
      _filter.option = _option;
      _filter.endingYear = int.tryParse(_endingYearController.text);
    } else {
      _timeType = null;
      _timeLengthController.text = '';
      _filter.option = _option;
      _filter.timeType = _timeType;
      _filter.timeLength = int.tryParse(_timeLengthController.text);
    }

    _updateFilter(_filter);

    notifyListeners();
  }

  void setIsOptionTrue(bool value) {
    _isOptionTrue = value;
    _filter.isOptionTrue = _isOptionTrue;
    _updateFilter(_filter);
    notifyListeners();
  }

  void setTimeLength(int value) {
    _filter.timeLength = value;
    _updateFilter(_filter);
    notifyListeners();
  }

  void setTimeType(DateFilterTimeType type) {
    _timeType = type;
    _filter.timeType = _timeType;
    _updateFilter(_filter);
    notifyListeners();
  }

  void setYear(int value) {
    _filter.year = value;
    _updateFilter(_filter);
    notifyListeners();
  }

  void setEndingYear(int value) {
    _filter.endingYear = value;
    _updateFilter(_filter);
    notifyListeners();
  }

  @override
  void dispose() {
    _timeLengthController.dispose();
    _yearController.dispose();
    _endingYearController.dispose();
    super.dispose();
  }
}
