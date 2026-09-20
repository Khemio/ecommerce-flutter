class AppLocalizations {
  static const _keys = {
    'title', 'choose_box', 'add_to_bag', 'cart_title', 'checkout', 'select_size', 
    'box_image', 'how_much', 'description', 'default_description', 'order_success', 
    'secure_checkout', 'cart_empty', 'total', 'socials_title', 'sort_default', 
    'price_low_high', 'price_high_low', 'all_products', 'all_vendors', 'lang_label','added_to_bag_msg',
    'explore_tab', 'bag_tab', 'profile_tab', 'retry_btn', 'quantity_label', 'no_description',
    'empty_cart', 'total_value', 'checkout_btn', 'clear_cart_title', 'clear_cart_body', 'clear_cart_cancel', 
    'clear_cart_confirm', 'cart_cleared_toast', 'profile_header', 'profile_info_section', 
    'save_btn', 'profile_saved_toast', 'order_history_shortcut', 'orders_count_suffix', 
    'order_history_title', 'sold_out', 'empty_orders', 'network_error_title', 'network_error_body', 
    'checkout_error', 'follow_us', 'field_name_last', 'field_name_first', 'field_email', 'field_address_zip',
    'field_address_city', 'field_address_street', 'field_name', 'field_address', 'input_error_name',
    'input_error_email_empty', 'input_error_email_format', 'input_error_address_city', 'input_error_address_street', 
    'input_error_address_zip_empty', 'input_error_address_zip_invalid', 'order_number',
    'confirmation_number', 'email_confirmation', 'back_to_main', 'timeout_title', 'timeout_subtitle',
    'timeout_msg','timeout_status_check', 'timeout_status_action', 'timeout_back_to_main',
    'payment_fail_title', 'payment_fail_subtitle', 'payment_fail_msg', 'payment_fail_back_to_main', 
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
      'cart_title': 'A Kosarad Tasakja',
      'empty_cart': 'A kosarad jelenleg teljesen üres.\nMenj és válassz ki egy rejtélyes dobozt!',
      'total_value': 'Teljes érték:',
      'checkout_btn': 'TOVÁBB A FIZETÉSHEZ',
      'clear_cart_title': 'Kosár ürítése?',
      'clear_cart_body': 'Biztosan törölni szeretnéd az összes elemet a kosárból?',
      'clear_cart_cancel': 'Mégse',
      'clear_cart_confirm': 'Törlés',
      'cart_cleared_toast': 'Kosár sikeresen kiürítve!',

      // Order Success
      'order_success': 'Sikeres vásárlás!',
      // 'order_success': '🎉 Rendelés sikeresen leadva!',
      'order_number': 'RENDELÉSSZÁM: #',
      'confirmation_number': 'Megerősítő kód: ',
      'email_confirmation': 'A tranzakciót sikeresen rögzítettük!\nA nyugtát az Ön e-mail címére küldjük.', 
      'back_to_main': 'VISSZA A FŐOLDALRA',
      
      // SSE Timeout
      'timeout_title': 'ELLENŐRZÉS...',
      'timeout_subtitle': 'A FIZETÉS SIKERES VOLT?',
      'timeout_msg': 'Lehet, hogy a fizetés sikeres volt, de a rendelés visszaigazolása késik.\nKérjük, ne indítsa újra a vásárlást!',
      'timeout_status_check': 'ELLENŐRZÉS FOLYAMATBAN...',
      'timeout_status_action': 'RENDELÉS ÁLLAPOTÁNAK FRISSÍTÉSE',
      'timeout_back_to_main': 'Vissza a főoldalra, később ellenőrzöm',

      // Payment Failure
      //TODO: Hungarian
      'payment_fail_title': 'SIKERTELEN FIZETÉS',
      'payment_fail_subtitle': 'A TRANZAKCIÓ MEGSZAKADT',
      'payment_fail_msg': 'A fizetés sikertelen volt vagy megszakításra került a banki felületen.\nA kosarad tartalma változatlan maradt."',
      'payment_fail_back_to_main': 'VISSZA A FŐOLDALRA',

      // Profile Screen Layout Elements
      'profile_header': 'PROFIL BEÁLLÍTÁSOK',
      'lang_label': 'Rendszer Nyelve',
      'profile_info_section': 'SZEMÉLYES ADATOK',

      'field_name': 'Teljes Név',
      'field_name_last': 'Vezetéknév',
      'field_name_first': 'Keresztnév',
      'field_email': 'E-mail cím',
      'field_address': 'Szállítási cím',
      'field_address_zip': 'Irányítószám',
      'field_address_city': 'Város',
      'field_address_street': 'Utca, házszám',

      'input_error_name': 'A név mezők kitöltése kötelező',
      'input_error_email_empty': 'E-mail cím megadása kötelező',
      'input_error_email_format': 'Érvénytelen e-mail cím formátum',
      'input_error_address_city': 'Város megadása kötelező',
      'input_error_address_street': 'Utca, házszám megadása kötelező',
      'input_error_address_zip_empty': 'Irányítószám megadása kötelező',
      'input_error_address_zip_invalid': 'Érvénytelen irányítószám (4 számjegy szükséges)',

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

      // Order Success
      'order_success': 'Successful Purchase!',
      // 'order_success': '🎉 Order Placed Successfully!',
      'order_number': 'Order number: #',
      'confirmation_number': 'Confirmation number: ',
      'email_confirmation': 'The transaction was recorded successfully!\nThe receipt will be sent to your email address.',  // You will receive the receipt via email
      'back_to_main': 'BACK TO THE MAIN PAGE',

      // SSE Timeout
      'timeout_title': 'CHECKING...',
      'timeout_subtitle': 'PAYMENT WAS SUCCESSFUL?',
      'timeout_msg': 'The payment may have been successful, but Order confirmation is delayed.\nPlease don’t restart your purchase!',
      'timeout_status_check': 'INSPECTION IN PROGRESS...',
      'timeout_status_action': 'UPDATE ORDER STATUS',
      'timeout_back_to_main': 'Back to main page, I\'ll check later',

      // Payment Failure
      //TODO: English
      'payment_fail_title': 'PAYMENT FAILED',
      'payment_fail_subtitle': 'THE TRANSACTION WAS TERMINATED',
      'payment_fail_msg': 'The payment was unsuccessful or interrupted on the bank interface.\nThe contents of your cart have remained unchanged.',
      'payment_fail_back_to_main': 'BACK TO THE MAIN PAGE',

      // Profile Screen Layout Elements
      'profile_header': 'PROFILE SETTINGS',
      'lang_label': 'Language',
      'profile_info_section': 'PERSONAL INFORMATION',

      'field_name': 'Full Name',
      'field_name_last': 'Last Name',
      'field_name_first': 'First Name',
      'field_email': 'Email Address',
      'field_address': 'Shipping Address',
      'field_address_zip': 'Zip',
      'field_address_city': 'City',
      'field_address_street': ' Street, Apt',

      'input_error_name': 'Name fields are required',
      'input_error_email_empty': 'Email is required',
      'input_error_email_format': 'Invalid email format',
      'input_error_address_city': 'City is required',
      'input_error_address_street': 'Street address is required',
      'input_error_address_zip_empty': 'Zip code is required',
      'input_error_address_zip_invalid': 'Invalid 4-digit zip code',

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
