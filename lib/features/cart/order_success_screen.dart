import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/app_theme.dart';
import 'package:azkomoly_app/core/providers/shop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderNumber;
  final String confirmationNumber;

  const OrderSuccessScreen({
    super.key,
    required this.orderNumber,
    required this.confirmationNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLanguage = context.read<ShopProvider>().appLanguage;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // "Sikeres vásárlás!", // "Successful Purchase!"
                AppLocalizations.translate(
                  'order_success',
                  appLanguage,
                ).toUpperCase(),
                style: theme.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppTheme.successColor,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        // "RENDELÉSSZÁM: #$orderNumber",
                        AppLocalizations.translate(
                              'order_number',
                              appLanguage,
                            ) +
                            orderNumber,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        // "Megerősítő kód: $confirmationNumber",
                        AppLocalizations.translate(
                              'confirmation_number',
                              appLanguage,
                            ) +
                            confirmationNumber,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.deepBlack.withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(
                          color: AppTheme.deepBlack,
                          thickness: 1.5,
                        ),
                      ),
                      Text(
                        // "A tranzakciót sikeresen rögzítettük! A számlát a tax platform automatikusan kiállítja.",
                        AppLocalizations.translate(
                          'email_confirmation',
                          appLanguage,
                        ),
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                // child: const Text("VISSZA A FŐOLDALRA"),
                child: Text(
                  AppLocalizations.translate('back_to_main', appLanguage),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
