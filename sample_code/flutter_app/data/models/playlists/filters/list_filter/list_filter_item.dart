import 'package:json_annotation/json_annotation.dart';

part 'list_filter_item.g.dart';

@JsonSerializable()
class ListFilterItem {
  String id;
  String name;
  String image;

  ListFilterItem({this.id, this.name, this.image});

  factory ListFilterItem.fromJson(Map<String, dynamic> json) =>
      _$ListFilterItemFromJson(json);

  Map<String, dynamic> toJson() => _$ListFilterItemToJson(this);
}
