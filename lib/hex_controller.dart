import 'dart:convert';

import 'package:get/get.dart';
import 'package:hex/utils.dart';

enum Encoders { base64, hex, escape }

enum Modes { ascii, code, hex }

extension ModeExt on Modes {
  String decode(String text) {
    switch (this) {
      case Modes.ascii:
        return toHex(text);
      case Modes.code:
        return toHex(text);
      case Modes.hex:
        return toHex(text);
      default:
        return text;
    }
  }
}

class HexController {
  var modeSelectedUpper = Modes.ascii.obs;
  var modeSelectedLower = Modes.ascii.obs;
  var textUpper = "".obs;
  var textLower = "".obs;
  var hexMapTextUpper = "";
  var hexMapTextLower = "";
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

  final text = "asdfghjk\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n"
      "........\n";

  String _encodeHex(String val) => toHex(val);

  String _decodeHex(String val) => List.generate(
          val.length ~/ 2,
          (index) => String.fromCharCode(
              int.parse(val.substring(index * 2, index * 2 + 2), radix: 16)))
      .join();

  String encode(String val) {
    print('Encoding $val with ${selectedEncoder.name}');

    textUpper.value = val;
    hexMapTextUpper = modeSelectedUpper.value.decode(val);

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

    textLower.value = val;
    hexMapTextLower = modeSelectedLower.value.decode(val);

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

  void setLowerMode(Modes mode) {
    modeSelectedLower.value = mode;

    hexMapTextLower = mode.decode(textLower.value);
  }
}
