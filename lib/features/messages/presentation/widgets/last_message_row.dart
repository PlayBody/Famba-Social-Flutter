import '../../../../core/constants/appconstants.dart';
import '../../domain/entity/chat_entity.dart';
import 'package:flutter/material.dart';

class LastMessageRow extends StatelessWidget {
  const LastMessageRow({
    Key key,
    @required this.isSeen,
    @required this.chatEntity,
  }) : super(key: key);
  final bool isSeen;
  final ChatEntity chatEntity;

  @override
  Widget build(BuildContext context) {
    return !isSeen
        ? Text(
            chatEntity.time,
            style: TextStyle(
              color: const Color(0xFF737880),
              fontSize: AC.getDeviceHeight(context) * 0.013,
              fontWeight: FontWeight.w600,
              fontFamily: "CeraPro",
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  chatEntity.time,
                  style: TextStyle(
                    color: const Color(0xFF737880),
                    fontSize: AC.getDeviceHeight(context) * 0.013,
                    fontWeight: FontWeight.w600,
                    fontFamily: "CeraPro",
                  ),
                ),
                Text(
                  'Seen',
                  style: TextStyle(
                    color: const Color(0xFF737880),
                    fontSize: AC.getDeviceHeight(context) * 0.013,
                    fontWeight: FontWeight.w600,
                    fontFamily: "CeraPro",
                  ),
                ),
              ],
            ),
          );
  }
}
