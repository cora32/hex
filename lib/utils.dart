String toHex(String text) {
  return text.codeUnits.map((e) => e.toRadixString(16)).join().toUpperCase();
}

String toASCII(String text) {
  return text;
}

String toCodes(String text) {
  return text.codeUnits.join();
}
