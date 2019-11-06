import 'package:flutter/material.dart';
import 'package:wan_flutter/common/GlobalConfig.dart';
import 'package:wan_flutter/fonts/IconF.dart';

class QuickTopFloatBtn extends StatefulWidget {
  final VoidCallback onPressed;
  final bool defaultVisible;

  QuickTopFloatBtn({Key key, this.onPressed, this.defaultVisible})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return QuickTopFloatBtnState();
  }
}

class QuickTopFloatBtnState extends State<QuickTopFloatBtn> {
  bool _visible = false;

  refreshVisible(bool visible) {
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _visible = widget.defaultVisible;
  }

  @override
  Widget build(BuildContext context) {
    return _visible
        ? Padding(
            child: FloatingActionButton(
                backgroundColor: Colors.white,
                foregroundColor: GlobalConfig.colorPrimary,
                child: Icon(IconF.top),
                onPressed: widget.onPressed),
            padding: EdgeInsets.all(10.0))
        : SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }
}
