import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app/app_localizations.dart';
import 'package:flutter_app/app_theme.dart';
import 'package:flutter_app/core/providers/shop_provider.dart';

//TODO: Remake dropdowns to support Themes
class FilterPillRow extends StatelessWidget {
  const FilterPillRow({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final bool canFilterType = shopProvider.isTypeFilteringEnabled;
    final bool canFilterVendor = shopProvider.isVendorFilteringEnabled;
    
    return  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    // return SingleChildScrollView(
    // scrollDirection: Axis.horizontal,
    // padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            value: shopProvider.selectedSortOrder,
            icon: const Icon(Icons.sort, color: Color(0xFFFFFFFF),),
            dropdownColor: AppTheme.brandViolet,
            underline: const SizedBox(),
            onChanged: (String? newSort) {
              shopProvider.updateFilters(
                productType: shopProvider.selectedTypeFilter, 
                vendor: shopProvider.selectedVendorFilter, 
                sort: newSort ?? 'None'
              );
            },
            items: [
              DropdownMenuItem(
                value: 'None', 
                child: Text(
                  // 'Sort: Default', 
                  AppLocalizations.translate('sort_default', shopProvider.appLanguage),
                  style: TextStyle(color: AppTheme.backgroundWhite)
                )
              ),
              DropdownMenuItem(
                value: 'LowToHigh', 
                child: Text(
                  // 'Price: Low to High', 
                  AppLocalizations.translate('price_low_high', shopProvider.appLanguage),
                  style: TextStyle(color: AppTheme.backgroundWhite)
                )
              ),
              DropdownMenuItem(
                value: 'HighToLow', 
                
                child: Text(
                  // 'Price: High to Low',
                  AppLocalizations.translate('price_high_low', shopProvider.appLanguage),
                  style: TextStyle(color: AppTheme.backgroundWhite)
                )
              ),
            ],
          ),

          ?canFilterType
          ? DropdownButton<String>(
            value: shopProvider.selectedTypeFilter,
            icon: Icon(Icons.filter_alt_outlined, color: canFilterType ? AppTheme.backgroundWhite : Colors.grey),
            dropdownColor: AppTheme.brandViolet,
            underline: const SizedBox(),
            onChanged: canFilterType
            ? (String? newType) {
                shopProvider.updateFilters(
                  productType: newType ?? 'All', 
                  vendor: shopProvider.selectedVendorFilter,
                  sort: shopProvider.selectedSortOrder
                );
              }
            : null,
            items: shopProvider.uniqueProductTypes.map((String vendor) {
              // return DropdownMenuItem(value: vendor, child: Text(vendor.toUpperCase(), style: TextStyle(color: AppTheme.backgroundWhite)));
              final String displayTitle = vendor == 'All' 
                ? AppLocalizations.translate('all_products', shopProvider.appLanguage) 
                : vendor.toUpperCase();

              return DropdownMenuItem(
                value: vendor, 
                child: Text(
                    displayTitle, 
                    style: TextStyle(color: canFilterType ? AppTheme.backgroundWhite : Colors.grey
                  )
                ),
              );
            }).toList(),
          )
          : null,

          ?canFilterVendor
          ? DropdownButton<String>(
            value: shopProvider.selectedTypeFilter,
            icon: Icon(Icons.filter_alt_outlined, color: canFilterVendor ? AppTheme.backgroundWhite : Colors.grey),
            dropdownColor: AppTheme.brandViolet,
            underline: const SizedBox(),
            onChanged: canFilterVendor
            ? (String? newVendor) {
                shopProvider.updateFilters(
                  productType: shopProvider.selectedTypeFilter, 
                  vendor: newVendor ?? 'All',
                  sort: shopProvider.selectedSortOrder
                );
              }
            : null,
            items: shopProvider.uniqueVendors.map((String vendor) {
              // return DropdownMenuItem(value: vendor, child: Text(vendor.toUpperCase(), style: TextStyle(color: AppTheme.backgroundWhite)));
              final String displayTitle = vendor == 'All' 
                ? AppLocalizations.translate('all_vendors', shopProvider.appLanguage) 
                : vendor.toUpperCase();

              return DropdownMenuItem(
                value: vendor, 
                child: Text(
                    displayTitle, 
                    style: TextStyle(color: canFilterVendor ? AppTheme.backgroundWhite : Colors.grey
                  )
                ),
              );
            }).toList(),
          )
          : null,
        ],
      ),
    );
  }

}