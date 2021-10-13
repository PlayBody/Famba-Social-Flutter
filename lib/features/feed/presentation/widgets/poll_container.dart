import 'package:colibri/features/feed/data/models/feeds_response.dart';
import 'package:colibri/features/feed/presentation/widgets/poll_item.dart';
import 'package:flutter/material.dart';

class PollContainer extends StatelessWidget {
  const PollContainer(this.poll, {Key key}) : super(key: key);
  final Poll poll;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _mapLengthToHeight(),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: poll.options
            .map(
              (e) => PollItem(
                text: e.option,
                percentage: poll.hasVoted == 0 ? null : (e.percentage),
              ),
            )
            .toList(),
      ),
    );
  }

  double _mapLengthToHeight() {
    switch (poll.options.length) {
      case 2:
        return 100;
        break;
      case 3:
        return 150;
        break;
      case 4:
        return 180;
        break;
      default:
        return 180;
        break;
    }
  }
}
