import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class ReportPostModel extends Equatable {
  final String seesionId;
  final int postId;
  final String reason;
  final String comment;

  const ReportPostModel({
    @required this.seesionId,
    @required this.postId,
    @required this.reason,
    @required this.comment,
  });

  @override
  List<Object> get props => [
        this.seesionId,
        this.postId,
        this.reason,
        this.comment,
      ];

  Map<String, dynamic> toJson() {
    return {
      'seesionId': seesionId,
      'postId': postId,
      'reason': reason,
      'comment': comment,
    };
  }
}
