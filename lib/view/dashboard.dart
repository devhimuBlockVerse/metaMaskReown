import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 import '../viewmodel/wallet_viewmodel.dart';
import 'home_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final walletVM = Provider.of<WalletViewModel>(context);
    return WillPopScope(
      onWillPop: () async { return false;  },
      child: Scaffold(
        backgroundColor: Color(0xFA525AE8),
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text(
            'Wallet Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              color: Colors.white,
              onPressed: () async {
                await walletVM.disconnectWallet();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeView()),
                );
              },
            ),
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.refresh),
              onPressed: () => walletVM.fetchBalance(),
            ),
          ],
        ),
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_balance_wallet_rounded,
                        size: 60, color: Colors.white),
                    const SizedBox(height: 20),
                    Text(
                      walletVM.userName != null
                          ? 'Welcome, ${walletVM.userName}'
                          : 'Wallet Not Connected',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.white.withOpacity(0.3)),
                    const SizedBox(height: 10),
                    _buildInfoRow('Wallet ID', walletVM.walletId ?? 'Not Connected'),
                    const SizedBox(height: 10),
                    _buildInfoRow('Balance', '${walletVM.balanceInEth} ETH'),
                    const SizedBox(height: 20),
                    _buildInfoRow('Chain ID', '${walletVM.chainId ?? 'N/A'}'),
                    const SizedBox(height: 20),
                    _buildInfoRow('Network', '${walletVM.networkName ?? 'N/A'}'),
                    const SizedBox(height: 20),
                    _buildInfoRow('Blockchain Identity', '${walletVM.blockchainIdentity ?? 'N/A'}'),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: walletVM.isLoading
                          ? null
                          : () => walletVM.fetchBalance(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.refresh,color: Colors.white,),
                      label: Text(
                        walletVM.isLoading ? 'Refreshing...' : 'Refresh Balance',
                        style: const TextStyle(fontSize: 16,color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title:",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}