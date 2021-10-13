import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class ReportProfileEntity extends Equatable {
  final String sessionId;
  final String userId;
  final int reason;
  final String comment;

  ReportProfileEntity({
    @required this.sessionId,
    @required this.userId,
    @required this.reason,
    @required this.comment,
  });

  @override
  List<Object> get props => [
        this.sessionId,
        this.userId,
        this.reason,
        this.comment,
      ];

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'reason': reason,
      'comment': comment,
    };
  }
}
