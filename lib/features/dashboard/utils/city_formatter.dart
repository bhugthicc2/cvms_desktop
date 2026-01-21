class CityFormatter {
  String formatCity(String raw) {
    if (raw.isEmpty) return raw;

    // Convert to lowercase first, then capitalize each word
    final words = raw.toLowerCase().split(' ');

    return words
        .map((word) {
          if (word.isEmpty) return word;

          // Handle special cases
          switch (word.toLowerCase()) {
            case 'city':
              return 'City';
            case 'municipality':
              return 'Municipality';
            default:
              // Capitalize first letter of each word
              return word[0].toUpperCase() + word.substring(1);
          }
        })
        .join(' ');
  }
}
