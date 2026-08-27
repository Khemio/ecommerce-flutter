import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; 
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter_app/app_theme.dart';
import '../app_localizations.dart';
import '../providers/shop_provider.dart';
import 'detail_screen.dart';
import 'cart_screen.dart';
import 'widgets/social_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShopProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/azkomoly_new_logo.webp',
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Text('AZKOMOLY', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            // const Text('Azkomoly Mystery Boxes'),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              AppLocalizations.currentLanguage == 'hu' ? 'EN' : 'HU',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            onPressed: () {
              setState(() {
                // Toggle the translation engine string parameters instantly
                AppLocalizations.currentLanguage = AppLocalizations.currentLanguage == 'hu' ? 'en' : 'hu';
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const CartScreen())
            ),
          )
        ],
      ),
      body: shopProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 180.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayInterval: const Duration(seconds: 4),
                  ),
                  items: [
                    shopProvider.products[0].imageUrl,
                    shopProvider.products[1].imageUrl,
                    shopProvider.products[2].imageUrl,
                    shopProvider.products[3].imageUrl,
                    shopProvider.products[4].imageUrl,
                    shopProvider.products[5].imageUrl,
                  ].map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).cardColor,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              errorWidget: (c, u, e) => const Icon(Icons.broken_image, size: 50),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  // 'CHOOSE YOUR MYSTERY BOX', 
                  AppLocalizations.translate('choose_box'),
                  style: Theme.of(context).textTheme.headlineLarge
                  // style: AppTheme.textStyle.headlineLarge
                  // style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white),
                  
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quick Toggle Sort Pill Button
                    DropdownButton<String>(
                      value: shopProvider.selectedSortOrder,
                      icon: const Icon(Icons.sort, color: Color(0xFFFFFFFF),),
                      underline: const SizedBox(),
                      onChanged: (String? newSort) {
                        shopProvider.updateFilters(vendor: shopProvider.selectedVendorFilter, sort: newSort ?? 'None');
                      },
                      items: const [
                        DropdownMenuItem(value: 'None', child: Text('Sort: Default', style: TextStyle(color: AppTheme.backgroundWhite))),
                        DropdownMenuItem(value: 'LowToHigh', child: Text('Price: Low to High', style: TextStyle(color: AppTheme.backgroundWhite))),
                        DropdownMenuItem(value: 'HighToLow', child: Text('Price: High to Low', style: TextStyle(color: AppTheme.backgroundWhite))),
                      ],
                    ),

                    // Quick Vendor Brand Filter Dropdown Pill Button
                    DropdownButton<String>(
                      value: shopProvider.selectedVendorFilter,
                      icon: const Icon(Icons.filter_alt_outlined, color: AppTheme.backgroundWhite),
                      underline: const SizedBox(),
                      onChanged: (String? newVendor) {
                        shopProvider.updateFilters(vendor: newVendor ?? 'All', sort: shopProvider.selectedSortOrder);
                      },
                      items: shopProvider.uniqueVendors.map((String vendor) {
                        return DropdownMenuItem(value: vendor, child: Text(vendor.toUpperCase(), style: TextStyle(color: AppTheme.backgroundWhite)));
                      }).toList(),
                    ),
                  ],
                ),
              ),
              
              GridView.builder(
                shrinkWrap: true,                  // 💡 CRITICAL: Allows Grid to live inside a ListView
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: shopProvider.filteredProducts.length,
                // itemCount: shopProvider.products.length,
                itemBuilder: (ctx, i) {
                  final product = shopProvider.filteredProducts[i];
                  // final product = shopProvider.products[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => DetailScreen(product: product))
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: CachedNetworkImage(
                                imageUrl: product.imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                // errorWidget: (context, url, error) => const Icon(
                                //   Icons.broken_image, 
                                //   size: 50, 
                                //   color: Colors.grey,
                                // ),
                                errorWidget: (context, url, error) => Container(
                                  color: const Color(0xFFE8DDFF), // Soft neon purple background tint
                                  child: Center(
                                  child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.inventory_2_outlined, size: 40, color: AppTheme.brandViolet),
                                            const SizedBox(height: 8),
                                            Text(
                                              // 'MYSTERY BOX IMAGE',
                                              AppLocalizations.translate('box_image'),
                                              style: TextStyle(
                                                fontFamily: 'Anton',
                                                color: AppTheme.brandViolet.withValues(alpha: 0.6),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                  )
                                ),
                              ),
                            ),
                          ),
                          // ----------------------------------------
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title, 
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Text('${product.price} HUF', style: const TextStyle(color: AppTheme.successColor)),
                                Text('${product.price} HUF', style: Theme.of(context).textTheme.bodyMedium,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              SocialCarousel(), 
              
              const SizedBox(height: 40),
          ]),
    );
  }
}
