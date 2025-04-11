import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/wallet_viewmodel.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    final userName = walletVM.getUserName() ?? 'Unknown User';
    final walletId = walletVM.getWalletAddress() ?? 'No Wallet ID';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Card(
          elevation: 10,
          margin: const EdgeInsets.all(30),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('👤 User: $userName'),
                const SizedBox(height: 12),
                Text('💼 Wallet ID: $walletId'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
