class AppLocalizations {
  static const _keys = {
    'title', 'choose_box', 'add_to_bag', 'cart_title', 'checkout', 'select_size', 
    'box_image', 'how_much', 'description', 'default_description', 'order_success', 
    'secure_checkout', 'cart_empty', 'total', 'socials_title', 'sort_default', 
    'price_low_high', 'price_high_low', 'all_products', 'all_vendors', 'lang_label','added_to_bag_msg',
    'explore_tab', 'bag_tab', 'profile_tab', 'retry_btn', 'quantity_label', 'no_description',
    'empty_cart', 'total_value', 'checkout_btn', 'clear_cart_title', 'clear_cart_body', 'clear_cart_cancel', 
    'clear_cart_confirm', 'cart_cleared_toast', 'profile_header', 'profile_info_section', 
    'field_name', 'field_email', 'field_address', 'save_btn', 'profile_saved_toast', 
    'order_history_shortcut', 'orders_count_suffix', 'order_history_title', 'sold_out',
    'empty_orders', 'network_error_title', 'network_error_body', 'checkout_error', 
    'follow_us',
};

  // Dictionary database matrix
  static const Map<String, Map<String, String>> _localizedValues = {
    'hu': {
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

       // General App Headers & Layout Elements
      'title': 'Azkomoly Mystery Boxes',
      'explore_tab': 'Felfedezés',
      'bag_tab': 'Tasak',
      'profile_tab': 'Profil',
      'retry_btn': 'ÚJRA',

       // Home Screen / Explore View Elements
      'choose_box': 'VÁLASSZ REJTÉLYES DOBOZT',
      'socials_title': '#AZKOMOLY · OSSZA MEG',
      'all_products': 'MINDEN TERMÉK',
      'all_vendors': 'MINDEN MÁRKA',
      'sort_default': 'Rendezés: Alap',
      'price_low_high': 'Ár: Olcsóbbak elöl',
      'price_high_low': 'Ár: Drágábbak elöl',
      'sold_out': 'ELFOGYOTT',

      // Detail Screen Page Elements
      'add_to_bag': 'DOBOZ HOZZÁADÁSA A TASAKHOZ',
      'quantity_label': 'MENNYISÉG',
      'no_description': 'Ez az exkluzív rejtélyes doboz gondosan válogatott prémium darabokat tartalmaz a legújabb dropokból.',
      'added_to_bag_msg': 'Tasakhoz hozzáadva: {quantity} x {title}',
      // 'added_to_bag_msg': '{quantity} db tétel ({title}) hozzáadva a tasakhoz!',

      // Cart Screen Elements
      // 'cart_title': 'A Kosarad',
      'cart_title': 'A Kosarad Tasakja',
      'empty_cart': 'A kosarad jelenleg teljesen üres.\nMenj és válassz ki egy rejtélyes dobozt!',
      'total_value': 'Teljes érték:',
      'checkout_btn': 'TOVÁBB A FIZETÉSHEZ',
      'clear_cart_title': 'Kosár ürítése?',
      'clear_cart_body': 'Biztosan törölni szeretnéd az összes elemet a kosárból?',
      'clear_cart_cancel': 'Mégse',
      'clear_cart_confirm': 'Törlés',
      'cart_cleared_toast': 'Kosár sikeresen kiürítve!',

      // Profile Screen Layout Elements
      'profile_header': 'PROFIL BEÁLLÍTÁSOK',
      'lang_label': 'Rendszer Nyelve',
      'profile_info_section': 'SZEMÉLYES ADATOK',
      'field_name': 'Név',
      'field_email': 'E-mail cím',
      'field_address': 'Szállítási cím (Irányítószám, Város, Utca)',
      'save_btn': 'MENTÉS ÉS RÖGZÍTÉS',
      'profile_saved_toast': 'Profil adatok sikeresen mentve!',
      'order_history_shortcut': 'KORÁBBI RENDELÉSEK ELŐZMÉNYEI',
      'orders_count_suffix': '{count} db korábbi tranzakció',
      'follow_us': 'KÖVESS MINKET',

      // Order History Screen Page Elements
      'order_history_title': 'Rendelési Előzmények',
      'empty_orders': 'Még nem adtál le rendelést.\nA sikeres vásárlásaid itt fognak megjelenni.',

      // Critical System Exceptions & Network Fallbacks
      'network_error_title': 'Hálózati kapcsolódási hiba',
      // 'network_error_body': 'Nem sikerült betölteni az adatokat.\nEllenőrizd az internetkapcsolatot vagy a helyi szervert.',
      'network_error_body': 'Nem sikerült betölteni az adatokat.\nEllenőrizze az internetkapcsolatot.',
      'checkout_error': 'Hiba történt a fizetési munkamenet indítása során. Kérjük, próbálja újra később.',
    },
    'en': {
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

      // General App Headers & Layout Elements
      'title': 'Azkomoly Mystery Boxes',
      'explore_tab': 'Explore',
      'bag_tab': 'Bag',
      'profile_tab': 'Profile',
      'retry_btn': 'RETRY',

      // Home Screen / Explore View Elements
      'choose_box': 'CHOOSE YOUR MYSTERY BOX',
      'socials_title': '#AZKOMOLY · SHARE IT',
      'sort_default': 'Sort: Default',
      'price_low_high': 'Price: Low to High',
      'price_high_low': 'Price: High to Low',
      'all_products': 'ALL PRODUCTS',
      'all_vendors': 'ALL VENDORS',
      'sold_out': 'SOLD OUT',

      // Detail Screen Page Elements
      'add_to_bag': 'ADD MYSTERY BOX TO BAG',
      'quantity_label': 'QUANTITY',
      'no_description': 'This exclusive mystery box features highly curated streetwear and rare collectible grails from the latest drops.',
      'added_to_bag_msg': 'Added to bag: {quantity} x {title}',
      // 'added_to_bag_msg_singular': '{quantity} item ({title}) added to bag!',
      // 'added_to_bag_msg_plural': '{quantity} items ({title}) added to bag!',

      // Cart Screen Elements
      'cart_title': 'Your Cart Bag',
      'empty_cart': 'Your cart is currently completely empty.\nGo add some exclusive mystery boxes!',
      'total_value': 'Total Value:',
      'checkout_btn': 'PROCEED TO CHECKOUT',
      'clear_cart_title': 'Clear Cart?',
      'clear_cart_body': 'Are you sure you want to remove all mystery boxes from your bag?',
      'clear_cart_cancel': 'Cancel',
      'clear_cart_confirm': 'Clear All',
      'cart_cleared_toast': 'Shopping bag successfully cleared!',

      // Profile Screen Layout Elements
      'profile_header': 'PROFILE SETTINGS',
      'lang_label': 'Language',
      'profile_info_section': 'PERSONAL INFORMATION',
      'field_name': 'Full Name',
      'field_email': 'Email Address',
      'field_address': 'Shipping Address (Zip, City, Street, Apt)',
      'save_btn': 'SAVE PROFILE CHANGES',
      'profile_saved_toast': 'Profile updates successfully saved!',
      'order_history_shortcut': 'PAST ORDERS HISTORY TRACKING',
      'orders_count_suffix': '{count} past transaction records',
      'follow_us': 'FOLLOW US',

      // Order History Screen Page Elements
      'order_history_title': 'Order History',
      'empty_orders': 'You haven\'t placed any orders yet.\nYour successful checkouts will appear right here.',

      // Critical System Exceptions & Network Fallbacks
      'network_error_title': 'Network Connection Failure',
      'network_error_body': 'Could not sync records.\nVerify your internet connectivity.',
      'checkout_error': 'An error occurred while establishing your checkout token session. Please try again later.',
    },
  };

  static String translate(String key, String languageCode) {
    assert(_keys.contains(key), 'Unknown translation key: $key');
    return _localizedValues[languageCode]?[key] ?? key;
  }
}
