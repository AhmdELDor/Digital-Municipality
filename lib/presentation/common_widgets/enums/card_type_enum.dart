enum CardType { visa, mastercard, amex, discover, rupay, other, invalid }

CardType detectCardType(String input) {
  if (input.startsWith(RegExp(r'4'))) return CardType.visa;
  if (input.startsWith(RegExp(r'5[1-5]'))) return CardType.mastercard;
  if (input.startsWith(RegExp(r'3[47]'))) return CardType.amex;
  if (input.startsWith(RegExp(r'6'))) return CardType.discover;
  if (input.startsWith(RegExp(r'^(6522|60|508|6531)'))) return CardType.rupay;

  return input.length < 4 ? CardType.other : CardType.invalid;
}
