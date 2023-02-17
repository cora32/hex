import 'dart:convert';

enum Encoders { base64, hex, escape }

class HexController {
  final encoders = Encoders.values;
  final base64Encoder = const Base64Encoder();
  final base64Decoder = const Base64Decoder();
  final htmlEscapeMode = const HtmlEscapeMode(
    name: 'custom',
    escapeLtGt: true,
    escapeQuot: false,
    escapeApos: false,
    escapeSlash: false,
  );

  late var htmlEscape = HtmlEscape(htmlEscapeMode);

  var selectedEncoder = Encoders.values.first;

  String _encodeHex(String val) =>
      val.codeUnits.map((e) => e.toRadixString(16)).join().toUpperCase();

  String _decodeHex(String val) => List.generate(
          val.length ~/ 2,
          (index) => String.fromCharCode(
              int.parse(val.substring(index * 2, index * 2 + 2), radix: 16)))
      .join();

  String encode(String val) {
    print('Encoding $val with ${selectedEncoder.name}');

    switch (selectedEncoder) {
      case Encoders.base64:
        return base64Encoder.convert(utf8.encode(val));
      case Encoders.hex:
        return _encodeHex(val);
      case Encoders.escape:
        return htmlEscape.convert(val);
      default:
        return val;
    }
  }

  String decode(String val) {
    print('Decoding $val with ${selectedEncoder.name}');

    switch (selectedEncoder) {
      case Encoders.base64:
        return utf8.decode(base64Decoder.convert(val));
      case Encoders.hex:
        return _decodeHex(val);
      case Encoders.escape:
        return _decodeHex(val);
      default:
        return val;
    }
  }
}
