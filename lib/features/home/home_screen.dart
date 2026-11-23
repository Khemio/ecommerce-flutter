import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/core/widgets/cart_btn.dart';
import 'package:azkomoly_app/core/providers/shop_provider.dart';
import 'package:azkomoly_app/core/utils/string_extenstions.dart';

import 'widgets/product_grid.dart';
import 'widgets/promo_carousel.dart';
import 'widgets/refetch_widget.dart';
import 'widgets/filter_pill_row.dart';
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

  Future<void> _onRefresh(BuildContext context) async {
    await Provider.of<ShopProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'azkomoly_new_logo.webp'.toAssetPath(),
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Text(
                'AZKOMOLY',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [CartButton(), const SizedBox(width: 8)],
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: shopProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : shopProvider.products.isEmpty
            ? RefetchWidget(
                appLanguage: shopProvider.appLanguage,
                onRefresh: _onRefresh,
              )
            // Body
            : ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(), // Ensures drag pull handles correctly
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: PromoCarousel(products: shopProvider.products),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      AppLocalizations.translate(
                        'choose_box',
                        shopProvider.appLanguage,
                      ),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),

                  FilterPillRow(),
                  ProductGrid(),
                  const SizedBox(height: 20),
                  SocialCarousel(),
                  const SizedBox(height: 40),
                ],
              ),
      ),
    );
  }
}
