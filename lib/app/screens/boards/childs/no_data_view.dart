import 'package:flutter/material.dart';

class NoDataView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.block, size: 48, color: Colors.black26),
          SizedBox(height: 8.0),
          Text(
            "No Data Found",
            style: TextStyle(
              color: Colors.black26,
              fontSize: 19,
              fontWeight: FontWeight.w600
            ),
          )
        ],
      ),
    );
  }
}
