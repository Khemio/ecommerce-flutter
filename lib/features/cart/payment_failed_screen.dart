import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/app_theme.dart';
import 'package:azkomoly_app/core/providers/shop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentFailedScreen extends StatelessWidget {
  const PaymentFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLanguage = context.read<ShopProvider>().appLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.translate('payment_fail_title', appLanguage)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded, 
                        color: AppTheme.errorColor, 
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.translate('payment_fail_subtitle', appLanguage),
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.translate('payment_fail_msg', appLanguage),
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.translate('payment_fail_back_to_main', appLanguage)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
