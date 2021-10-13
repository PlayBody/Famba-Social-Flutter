import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:mime/mime.dart';

import '../../../features/feed/presentation/widgets/create_post_card.dart';
import '../../datasource/local_data_source.dart';
import '../failure.dart';
import '../media/media_data.dart';
import 'api_constants.dart';

@injectable
class UploadManager {
  final LocalDataSource localDataSource;

  UploadManager(this.localDataSource);

  Future<Either<Failure, dynamic>> uploadMedia(MediaData mediaData) async {
    // real api
    var loginResponse = await localDataSource.getUserData();
    var request = http.MultipartRequest('POST',
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.uploadPostMedia}'));

    request.fields.addAll({
      'session_id': loginResponse.auth.authToken,
      'type': mediaData.type == MediaTypeEnum.VIDEO ? "video" : "image",
    });
    final mimeTypeData =
        lookupMimeType(mediaData.path, headerBytes: [0xFF, 0xD8]).split('/');
    request.files.add(await http.MultipartFile.fromPath("file", mediaData.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var req = await response.stream.bytesToString();
      print(req);
      return right("");
    } else {
      print(response.reasonPhrase);
      return left(ServerFailure(""));
    }
  }
}
