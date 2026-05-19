void main() {
  String str = 'Hello';
  Runes runes1 = str.runes;

  Runes runes = Runes('\u2665');
  print(runes);

  Runes runes2 = Runes('\u{1F600}');

  //Biểu tượng

  //Runes  sang String
  String heartSymbol = String.fromCharCodes(runes);
  print(heartSymbol);
  //Từ mã emoji sang String
  String emoji = String.fromCharCode(0x1F600);
  print(emoji);
  String symbol = String.fromCharCode(0x2665);
  print(symbol);

  print(runes.length);
  print(runes.first);
  print(runes.last);
  runes1 = 'Xin chào 😀 , toi rat ♥'.runes;
  runes1.forEach((int rune) {
    print('Unicode:  $rune , Ky tu: ${String.fromCharCode(rune)}');
  });
}
