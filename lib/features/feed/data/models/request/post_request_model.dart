import 'dart:collection';

class PostRequestModel {
  final String postText;
  final String gifUrl;
  final String threadId;
  final String ogData;
  final List<Map<String, String>> poll_data;

  PostRequestModel({
    this.postText,
    this.gifUrl,
    this.threadId,
    this.ogData,
    this.poll_data,
  });

  HashMap<String, String> toMap() {
    return HashMap.from({
      "post_text": postText,
      "thread_id": threadId,
      "gif_src": gifUrl,
      "og_data": ogData,
      'poll_data': poll_data.toString(),
    });
  }
}
