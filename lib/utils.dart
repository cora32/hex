import 'dart:convert';

const asciiCodec = AsciiCodec(allowInvalid: true);

String toASCII(String text) {
  return asciiCodec.decode(text.codeUnits, allowInvalid: true);
}

String toCodes(String text) {
  return text.codeUnits.join();
}

String toHex(String text) {
  return text.codeUnits.map((e) => e.toRadixString(16)).join().toUpperCase();
}
