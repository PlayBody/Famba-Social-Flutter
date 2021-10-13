import 'package:flutter/material.dart';
import '../../extensions.dart';

class ErrorScreen extends StatefulWidget {
  final String error;
  const ErrorScreen({Key key, this.error}) : super(key: key);
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
              child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error),
            10.toSizedBox,
            widget.error
                .toSubTitle2(color: Colors.red, align: TextAlign.center)
                .toPadding(12),
          ],
        ),
      )));
}
