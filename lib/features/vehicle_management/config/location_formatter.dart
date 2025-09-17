class LocationFormatter {
  String toProperCase(String text) {
    if (text.isEmpty) return text;
    final lowercaseWords = {
      'del',
      'de',
      'la',
      'las',
      'los',
      'y',
      'and',
      'of',
      'the',
    };

    final words = text.toLowerCase().split(' ');
    final properCaseWords = <String>[];

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      if (i == 0 || !lowercaseWords.contains(word)) {
        properCaseWords.add(word[0].toUpperCase() + word.substring(1));
      } else {
        properCaseWords.add(word);
      }
    }

    return properCaseWords.join(' ');
  }
}
