import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 import '../viewmodel/wallet_viewmodel.dart';
import 'home_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final walletVM = Provider.of<WalletViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await walletVM.disconnectWallet();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeView()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => walletVM.fetchBalance(),
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('User: ${walletVM.userName ?? 'Not Connected'}'),
                const SizedBox(height: 20),
                Text('Wallet ID: ${walletVM.walletId ?? 'Not Connected'}'),
                const SizedBox(height: 20),
                Text('Balance: ${walletVM.balanceInEth} ETH'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
