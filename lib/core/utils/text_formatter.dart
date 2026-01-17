class TextFormatter {
  // Format category labels to title case
  String formatCategoryLabel(String category) {
    return category
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : '',
        )
        .join(' ');
  }
}
