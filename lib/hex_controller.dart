import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hex/utils.dart';

enum Encoders { base64, hex, escape_html, escape_url }

enum Modes { ascii, code, hex }

class HexController {
  var modeSelectedEncoded = Modes.ascii.obs;
  var modeSelectedDecoded = Modes.ascii.obs;
  var textEncoded = "".obs;
  var textDecoded = "".obs;
  var encodedMap = "".obs;
  var decodedMap = "".obs;
  final encoders = Encoders.values;
  var selectedEncoder = Encoders.values.first;

  static String decodeForMap(Modes mode, String text) {
    switch (mode) {
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

  static String decodeTask(
      String val, Encoders selectedEncoder, String defaultValue) {
    try {
      switch (selectedEncoder) {
        case Encoders.base64:
          return fromBase64(val);
        case Encoders.hex:
          return fromHex(val);
        case Encoders.escape_html:
          return fromEscapedHtml(val);
        case Encoders.escape_url:
          return Uri.decodeFull(val);
        default:
          return val;
      }
    } catch (ex) {
      print(ex);

      return defaultValue;
    }
  }

  static String encodeTask(
      String val, Encoders selectedEncoder, String defaultValue) {
    try {
      switch (selectedEncoder) {
        case Encoders.base64:
          return toBase64(val);
        case Encoders.hex:
          return toHex(val);
        case Encoders.escape_html:
          return toEscapedHtml(val);
        case Encoders.escape_url:
          return Uri.encodeFull(val);
        default:
          return val;
      }
    } catch (ex) {
      print(ex);

      return defaultValue;
    }
  }

  static String decodeTask2(String val) {
    return val + val;
  }

  Future<String> decode(String val) async {
    print('Decoding $val with ${selectedEncoder.name}');

    textEncoded.value = val;
    textDecoded.value = await compute((map) {
      final text = map['text'] as String;
      final encoder = map['encoder'] as Encoders;
      final defaultValue = map['defaultValue'] as String;

      return decodeTask(text, encoder, defaultValue);
    }, {
      "text": val,
      "encoder": selectedEncoder,
      "defaultValue": textDecoded.value
    });

    print('Decoded: ${textDecoded.value}');

    updateUpperMap();
    updateLowerMap();

    return textDecoded.value;
  }

  Future<String> encode(String val) async {
    print('Encoding $val with ${selectedEncoder.name}');

    textDecoded.value = val;
    textEncoded.value = await compute((map) {
      final text = map['text'] as String;
      final encoder = map['encoder'] as Encoders;
      final defaultValue = map['defaultValue'] as String;

      return encodeTask(text, encoder, defaultValue);
    }, {
      "text": val,
      "encoder": selectedEncoder,
      "defaultValue": textEncoded.value
    });

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

  Future<void> updateUpperMap() async {
    encodedMap.value = await compute((map) {
      final text = map['text'] as String;
      final mode = map['mode'] as Modes;

      return decodeForMap(mode, text);
    }, {'text': textEncoded.value, 'mode': modeSelectedDecoded.value});
  }

  Future<void> updateLowerMap() async {
    decodedMap.value = await compute((map) {
      final text = map['text'] as String;
      final mode = map['mode'] as Modes;

      return decodeForMap(mode, text);
    }, {'text': textDecoded.value, 'mode': modeSelectedDecoded.value});
  }

  void setEncoder(Encoders val) {
    selectedEncoder = val;

    decode(textEncoded.value);
  }
}
