import 'package:flutter/material.dart';
import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/core/models/product.dart';
import 'package:azkomoly_app/core/utils/num_extentions.dart';
import 'package:azkomoly_app/core/widgets/quantity_selector.dart';

class DetailBody extends StatefulWidget {
  final String appLanguage;
  final Product product;
  final ValueChanged<int> onQuantityChanged;

  const DetailBody({
    super.key,
    required this.appLanguage,
    required this.product,
    required this.onQuantityChanged,
  });

  @override
  State<DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends State<DetailBody> {
  int _selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            widget.product.price.toPrice(currency: 'HUF'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),

          Text(
            AppLocalizations.translate('how_much', widget.appLanguage),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),

          QuantitySelector(
            value: _selectedQuantity,
            onChanged: (q) {
              setState(() => _selectedQuantity = q);
              widget.onQuantityChanged(q);
            },
          ),
          const SizedBox(height: 24),

          Text(
            AppLocalizations.translate('description', widget.appLanguage),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),

          Text(
            widget.product.description.isEmpty
                ? AppLocalizations.translate(
                    'default_description',
                    widget.appLanguage,
                  )
                : widget.product.description,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}
