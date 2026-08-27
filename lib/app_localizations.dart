class AppLocalizations {
  static String currentLanguage = 'en'; // Global active flag ('hu' or 'en')

  // Dictionary database matrix
  static const Map<String, Map<String, String>> _localizedValues = {
    'hu': {
      'title': 'AzKomoly Mystery Boxes',
      'choose_box': 'VÁLASSZ REJTÉLYES DOBOZT',
      'add_to_bag': 'DOBOZ HOZZÁADÁSA A TASAKHOZ',
      'cart_title': 'A Kosarad',
      'checkout': 'TOVÁBB A FIZETÉSHEZ',
      'select_size': 'VÁLASSZ MÉRETET',
      'box_image': 'REJTÉLYES DOBOZ KÉP',
      'how_much': 'MENNYIT AKARSZ TE?',
      'description': 'LEÍRÁSA',
      'default_description': 'Ez az exkluzív rejtélyes doboz rendkívül válogatott utcai ruhákat és ritka tárgyakat tartalmaz, amelyek megfelelnek a prémium cseppeknek.',
      'order_success': '🎉 Rendelés sikeresen leadva!',
      'secure_checkout': 'Biztonságos Shopify Checkout',
      'cart_empty': 'A kosarad jelenleg üres.\nMenj, adj hozzá néhány rejtélyes dobozt!',
      'total': 'Összérték:',
      'socials_title': '#AZKOMOLY · OSSZA MEG',

      'sort_default': 'Rendezés: Alapértelmezett',
      'price_low_high': 'Ár: Alacsonytól a Magasig',
      'price_high_low': 'Ár: Magastól az Alacsonyig',
      'all_vendors': 'MINDEN MÁRKA',
    },
    'en': {
      'title': 'AzKomoly Mystery Boxes',
      'choose_box': 'CHOOSE YOUR MYSTERY BOX',
      'add_to_bag': 'ADD MYSTERY BOX TO BAG',
      'cart_title': 'Your Cart Bag',
      'checkout': 'PROCEED TO CHECKOUT',
      'select_size': 'SELECT BOX SIZE',
      'box_image': 'MYSTERY BOX IMAGE',
      'how_much': 'HOW MUCH DO YOU WANT?',
      'description': 'DESCRIPTION',
      'default_description': 'This exclusive mystery box features highly curated street clothing and rare items matching premium drops.',
      'order_success': '🎉 Order Placed Successfully!',
      'secure_checkout': 'Secure Shopify Checkout',
      'cart_empty': 'Your cart is currently empty.\nGo add some mystery boxes!',
      'total': 'Total Value:',
      'socials_title': '#AZKOMOLY · SHARE IT',

      'sort_default': 'Sort: Default',
      'price_low_high': 'Price: Low to High',
      'price_high_low': 'Price: High to Low',
      'all_vendors': 'ALL BRANDS',
    },
  };

  // Static helper methods to retrieve translations instantly on any widget page
  static String translate(String key) {
    return _localizedValues[currentLanguage]?[key] ?? key;
  }
}
