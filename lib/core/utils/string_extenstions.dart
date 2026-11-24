extension AssetPathNormalizer on String {
  String toAssetPath() {
    // If the path already has 'assets/', leave it alone
    if (startsWith('assets/')) {
      return this;
    }
    // If it starts with 'images/', prepend 'assets/'
    if (startsWith('images/')) {
      return 'assets/$this';
    }
    // Fallback default prefix
    return 'assets/images/$this';
  }
}
