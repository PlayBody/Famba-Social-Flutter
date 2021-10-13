class VotePollEntity {
  int code;
  String message;
  Data data;

  VotePollEntity({this.code, this.message, this.data});

  VotePollEntity.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  PollData pollData;

  Data({this.pollData});

  Data.fromJson(Map<String, dynamic> json) {
    pollData =
        json['poll_data'] != null ? PollData.fromJson(json['poll_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.pollData != null) {
      data['poll_data'] = this.pollData.toJson();
    }
    return data;
  }
}

class PollData {
  int hasVoted;
  int total;
  List<Options> options;

  PollData({this.hasVoted, this.total, this.options});

  PollData.fromJson(Map<String, dynamic> json) {
    hasVoted = json['has_voted'];
    total = json['total'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['has_voted'] = this.hasVoted;
    data['total'] = this.total;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String percentage;
  int total;
  String option;

  Options({this.percentage, this.total, this.option});

  Options.fromJson(Map<String, dynamic> json) {
    percentage = json['percentage'];
    total = json['total'];
    option = json['option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['percentage'] = this.percentage;
    data['total'] = this.total;
    data['option'] = this.option;
    return data;
  }
}
