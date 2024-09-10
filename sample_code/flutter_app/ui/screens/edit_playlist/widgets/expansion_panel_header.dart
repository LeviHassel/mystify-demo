import 'package:flutter/material.dart';

class ExpansionPanelHeader extends StatelessWidget {
  final String type;
  final String value;

  ExpansionPanelHeader(this.type, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 15.0),
            width: 135.0,
            child: Text(
              type,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ],
      ),
    );
  }
}
