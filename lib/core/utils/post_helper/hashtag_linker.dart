import 'package:flutter_linkify/flutter_linkify.dart';

class HashTagLinker extends Linkifier {
  const HashTagLinker();
  @override
  List<LinkifyElement> parse(
      List<LinkifyElement> elements, LinkifyOptions options) {
    List<LinkifyElement> items = [];
    // var newElement="Hey there testing the hashtag issue, \n I hope this gets fixed soon. #bug #mobileapp #dukhiKarDitta #FixHoJaHun".split("").map((e) => TextElement(e));
    // get all items
    elements.forEach((element) {

      // check if it's contains hashtags
      if (element.text.contains("#")) {
        // helps to keep the index of current iteration
        var index = 0;

        //  remove spaced from beginning and end
        element.text.trim().split(" ").forEach((innerText) {
          // added linkable text if it's hashtag
          if (innerText.contains("#")) {
            // added space in front of all hashtags
            if (index != 0) {
              // addling space
              items.add(TextElement(" "));
              items.add(LinkableElement("$innerText", innerText));
            } else
              // add item linkable without space
              items.add(LinkableElement("$innerText", innerText));
          }
          // else if (innerText.isEmpty)
          //   // because we're splitting on basis of space, so we might get a blank space
          //   // add empty text element if there is only space
          //   items.add(TextElement(" "));
          else
            // add items without hashtags
            // if(innerText.contains("\r\n")){
            //   innerText=innerText.replaceAll("\r\n", "\n ");
            // }
            items.add(TextElement(innerText + " "));
          index = index + 1;
        });
      } else
        // add non hastags item
        items.add(element);
    });
    return items;
  }
}

// if (innerText.contains("#")) {
// // added space in front of all hashtags
// if (index != 0) {
// // addling space
// var r=innerText.split("#");
//
// items.add(TextElement(r[0]));
// items.add(LinkableElement("#${r[1]}", r[1]));
// }
// // add item linkable without space
// // items.add(LinkableElement("$innerText", innerText));
// }