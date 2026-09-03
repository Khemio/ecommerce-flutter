import 'package:flutter/material.dart';

class RefetchWidget extends StatelessWidget {
  final Function(BuildContext) _onRefresh;
  
  const RefetchWidget({
    super.key, required this._onRefresh,
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
            //TODO: Add translations
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  // 'Nem sikerült betölteni a dobozokat.\nCould not load mystery boxes.',
                  'Could not load mystery boxes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  // 'Ellenőrizd, hogy fut-e a szerver.\nCheck if your local server is running.',
                  'Check if your local server is running.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 24),
                // 🟢 NATIVE RETRY ACTION BUTTON
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(160, 48),
                  ),
                  icon: const Icon(Icons.refresh),
                  // label: const Text('ÚJRA / RETRY'),
                  label: const Text('RETRY'),
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