import 'dart:convert';

import 'package:get/get.dart';
import 'package:hex/utils.dart';

enum Encoders { base64, hex, escape_html, escape_url }

enum Modes { ascii, code, hex }

extension ModeExt on Modes {
  String decode(String text) {
    switch (this) {
      case Modes.ascii:
        return toASCII(text);
      case Modes.code:
        return toCodes(text);
      case Modes.hex:
        return toHex(text);
      default:
        return text;
    }
  }
}

class HexController {
  var modeSelectedEncoded = Modes.ascii.obs;
  var modeSelectedDecoded = Modes.ascii.obs;
  var textEncoded = "".obs;
  var textDecoded = "".obs;
  var encodedMap = "".obs;
  var decodedMap = "".obs;
  final encoders = Encoders.values;
  final base64Encoder = const Base64Encoder();
  final base64Decoder = const Base64Decoder();

  // final htmlEscapeMode = const HtmlEscapeMode(
  //   name: 'custom',
  //   escapeLtGt: true,
  //   escapeQuot: true,
  //   escapeApos: true,
  //   escapeSlash: true,
  // );
  late var htmlEscape = const HtmlEscape();
  var selectedEncoder = Encoders.values.first;

  String _encodeHex(String val) => toHex(val);

  String _decodeHex(String val) => List.generate(
          val.length ~/ 2,
          (index) => String.fromCharCode(
              int.parse(val.substring(index * 2, index * 2 + 2), radix: 16)))
      .join();

  String decode(String val) {
    print('Decoding $val with ${selectedEncoder.name}');

    textEncoded.value = val;

    textDecoded.value = _decode(val);

    print('Decoded: ${textDecoded.value}');

    updateUpperMap();
    updateLowerMap();

    return textDecoded.value;
  }

  String encode(String val) {
    print('Encoding $val with ${selectedEncoder.name}');

    textDecoded.value = val;

    textEncoded.value = _encode(val);

    print('Encoded: ${textEncoded.value}');

    updateUpperMap();
    updateLowerMap();

    return textEncoded.value;
  }

  void setLowerMode(Modes mode) {
    modeSelectedDecoded.value = mode;

    updateLowerMap();
  }

  void setUpperMode(Modes mode) {
    modeSelectedEncoded.value = mode;

    updateUpperMap();
  }

  void updateUpperMap() {
    encodedMap.value = modeSelectedEncoded.value.decode(textEncoded.value);
  }

  void updateLowerMap() {
    decodedMap.value = modeSelectedDecoded.value.decode(textDecoded.value);
  }

  String _decode(String val) {
    try {
      switch (selectedEncoder) {
        case Encoders.base64:
          return utf8.decode(base64Decoder.convert(val), allowMalformed: true);
        case Encoders.hex:
          return _decodeHex(val);
        case Encoders.escape_html:
          return _decodeHex(val);
        case Encoders.escape_url:
          return Uri.decodeFull(val);
        default:
          return val;
      }
    } catch (ex) {
      print(ex);

      return textDecoded.value;
    }
  }

  String _encode(String val) {
    try {
      switch (selectedEncoder) {
        case Encoders.base64:
          return base64Encoder.convert(utf8.encode(val));
        case Encoders.hex:
          return _encodeHex(val);
        case Encoders.escape_html:
          return htmlEscape.convert(val);
        case Encoders.escape_url:
          return Uri.encodeFull(val);
        default:
          return val;
      }
    } catch (ex) {
      print(ex);

      return textEncoded.value;
    }
  }

  void setEncoder(Encoders val) {
    selectedEncoder = val;

    decode(textEncoded.value);
  }
}
