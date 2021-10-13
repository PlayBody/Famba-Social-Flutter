import 'package:injectable/injectable.dart';
import 'package:share/share.dart';

@injectable
class MySocialShare{

  shareToOtherPlatforms({List<String> files=const [],String text})async{

    // files.forEach((element) {
    //   text="$text\n $element";
    // });

    // if(files.isNotEmpty){
    //   await Share.shareFiles(files,text: text);
    // }
    // else
    await Share.share(text);

  }
}