import 'package:azkomoly_app/app_localizations.dart';
import 'package:azkomoly_app/app_theme.dart';
import 'package:azkomoly_app/core/providers/shop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderProcessingTimeoutScreen extends StatefulWidget {
  final String sessionId;

  const OrderProcessingTimeoutScreen({super.key, required this.sessionId});

  @override
  State<OrderProcessingTimeoutScreen> createState() =>
      _OrderProcessingTimeoutScreenState();
}

class _OrderProcessingTimeoutScreenState
    extends State<OrderProcessingTimeoutScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLanguage = context.read<ShopProvider>().appLanguage;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // "CHECKING...",
                // "ELLENŐRZÉS...",
                AppLocalizations.translate('timeout_title', appLanguage),
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 48,
                        width: 48,
                        child: CircularProgressIndicator(
                          color: AppTheme.brandViolet,
                          strokeWidth: 4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        // 'PAYMENT WAS SUCCESSFUL?',
                        // "A FIZETÉS SIKERES VOLT?",
                        AppLocalizations.translate(
                          'timeout_subtitle',
                          appLanguage,
                        ),
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        // 'The payment may have been successful, but Order confirmation is delayed.\nPlease don’t restart your purchase!',
                        // 'Lehet, hogy a fizetés sikeres volt, de a rendelés visszaigazolása késik.\nKérjük, ne indítsa újra a vásárlást!',
                        AppLocalizations.translate('timeout_msg', appLanguage),
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: Text(
                  // "Back to main page, I'll check later",
                  // "Vissza a főoldalra, később ellenőrzöm",
                  AppLocalizations.translate(
                    'timeout_back_to_main',
                    appLanguage,
                  ),
                  style: TextStyle(
                    color: AppTheme.backgroundWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
