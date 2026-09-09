import 'package:flutter/material.dart';

import 'package:azkomoly_app/app_localizations.dart';

class RefetchWidget extends StatelessWidget {
  final String appLanguage;
  final Function(BuildContext) _onRefresh;
  
  const RefetchWidget({
    super.key, 
    required this.appLanguage,
    required this._onRefresh, 
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.translate('network_error_title', appLanguage),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.translate('network_error_body', appLanguage),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(160, 48),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: Text(AppLocalizations.translate('retry_btn', appLanguage)),
                  onPressed: () => _onRefresh(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}