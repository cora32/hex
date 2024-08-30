import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';

const asciiCodec = AsciiCodec(allowInvalid: true);
const base64Encoder = Base64Encoder();
const base64Decoder = Base64Decoder();
const htmlEscape = HtmlEscape();
var htmlUnescape = HtmlUnescape();

String toASCII(String text) {
  return asciiCodec.decode(text.codeUnits, allowInvalid: true);
}

String toCodes(String text) {
  return text.codeUnits.join();
}

String toHex(String text) {
  return text.codeUnits.map((e) => e.toRadixString(16)).join().toUpperCase();
}

String fromHex(String text) => List.generate(
    text.length ~/ 2,
    (index) => String.fromCharCode(
        int.parse(text.substring(index * 2, index * 2 + 2), radix: 16))).join();

String toEscapedHtml(String text) => htmlEscape.convert(text);

String fromEscapedHtml(String text) => htmlUnescape.convert(text);

String fromBase64(String text) =>
    utf8.decode(base64Decoder.convert(text), allowMalformed: true);

String toBase64(String text) => base64Encoder.convert(utf8.encode(text));

// computeSync() async {
//   return await compute((map) {
//     final text = map['text'] as String;
//     final encoder = map['encoder'] as Encoders;
//     final defaultValue = map['defaultValue'] as String;
//
//     return decodeTask(text, encoder, defaultValue);
//   }, {
//     "text": val,
//     "encoder": selectedEncoder,
//     "defaultValue": textDecoded.value
//   });
// }