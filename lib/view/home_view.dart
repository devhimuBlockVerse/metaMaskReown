import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/buttonComponent.dart';
import '../viewmodel/wallet_viewmodel.dart';
import 'dashboard.dart';




class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final walletVM = Provider.of<WalletViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MYCOINPOLL'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade700,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: walletVM.isLoading
                    ? null
                    : () async {
                  await walletVM.connectOrDisconnectWallet();
                  if (walletVM.isConnected) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DashboardView(),
                      ),
                    );
                  }
                },
                icon: Icon(walletVM.isLoading
                    ? Icons.hourglass_empty
                    : walletVM.isConnected
                    ? Icons.link_off
                    : Icons.link),
                label: Text(walletVM.isLoading
                    ? 'Please Wait...'
                    : walletVM.isConnected
                    ? 'Disconnect Wallet'
                    : 'Connect Wallet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
