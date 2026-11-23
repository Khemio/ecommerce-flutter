import '../models/user_profile.dart';

extension CheckoutPrefiller on String {
  /// Appends user profile information as query parameters to a Shopify checkout URL.
  String prefillWithProfile(UserProfile? profile) {
    if (profile == null || isEmpty) return this;

    // 1. Parse the base string into an editable URI object
    final Uri baseUri = Uri.parse(this);

    // 2. Map out the official Shopify checkout pre-fill query matrix parameters
    final Map<String, String> prefillParams = {
      'checkout[email]': profile.email,
      'checkout[shipping_address][first_name]': profile.firstName,
      'checkout[shipping_address][last_name]': profile.lastName,
      'checkout[shipping_address][zip]': profile.address.zipCode,
      'checkout[shipping_address][city]': profile.address.city,
      'checkout[shipping_address][address1]': profile.address.streetAddress,
      'checkout[shipping_address][country]':
          'HU', // Automatically lock country to Hungary for your drops
    };

    // 3. Merge existing query parameters from the server response with our new pre-fill parameters
    final Map<String, String> updatedQuery = Map<String, String>.from(
      baseUri.queryParameters,
    )..addAll(prefillParams);

    // 4. Rebuild the URI string completely intact with the structured query fields
    return baseUri.replace(queryParameters: updatedQuery).toString();
  }
}
