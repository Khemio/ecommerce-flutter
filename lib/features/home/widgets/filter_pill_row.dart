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
    
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            value: shopProvider.selectedSortOrder,
            icon: const Icon(Icons.sort, color: Color(0xFFFFFFFF),),
            dropdownColor: AppTheme.brandViolet,
            underline: const SizedBox(),
            onChanged: (String? newSort) {
              shopProvider.updateFilters(vendor: shopProvider.selectedVendorFilter, sort: newSort ?? 'None');
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

          DropdownButton<String>(
            value: shopProvider.selectedVendorFilter,
            icon: const Icon(Icons.filter_alt_outlined, color: AppTheme.backgroundWhite),
            dropdownColor: AppTheme.brandViolet,
            underline: const SizedBox(),
            onChanged: (String? newVendor) {
              shopProvider.updateFilters(vendor: newVendor ?? 'All', sort: shopProvider.selectedSortOrder);
            },
            items: shopProvider.uniqueVendors.map((String vendor) {
              // return DropdownMenuItem(value: vendor, child: Text(vendor.toUpperCase(), style: TextStyle(color: AppTheme.backgroundWhite)));
              final String displayTitle = vendor == 'All' 
                ? AppLocalizations.translate('all_vendors', shopProvider.appLanguage) 
                : vendor.toUpperCase();

              return DropdownMenuItem(
                value: vendor, 
                child: Text(displayTitle, style: const TextStyle(color: AppTheme.backgroundWhite)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

}