extension PriceFormatter on num {
  /// Converts a number into a beautifully formatted e-commerce price string
  /// based on the active app language code.
  String toPrice({required String currency}) {
    // 1. Ensure the number always shows 2 decimal places if needed, 
    // or format it cleanly for flat currencies like HUF.
    String formattedNumber;
    if (currency.toLowerCase() == 'huf') {
      // Hungarian retail styling typically drops decimals for HUF (e.g., 1000 HUF)
      formattedNumber = toStringAsFixed(0); 

      final RegExp regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      String separatedHuf = formattedNumber.replaceAllMapped(regex, (Match m) => '${m[1]} ');

      return "$separatedHuf HUF";

    } else {
      // English standard format with 2 decimal boundaries (e.g., 29.99 USD)
      formattedNumber = toStringAsFixed(2);

      final RegExp regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      String separatedUsd = formattedNumber.replaceAllMapped(regex, (Match m) => '${m[1]},');

      return "$separatedUsd USD";
    }
  }
}