import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 // import '../viewmodel/wallet_viewmodel.dart';
import 'home_view.dart';
import '../viewmodel/wallet_view_model2.dart';



class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final walletVM = Provider.of<WalletViewModel>(context, listen: false);
  //     if (walletVM.isConnected) {
  //       walletVM.initWallet();
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      if (walletVM.isConnected) {
        // Ensure session is ready before calling initWallet
        await walletVM.waitForSession();
        walletVM.initWallet();

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<WalletViewModel>(
        builder: (context, walletVM, child) {
          return Scaffold(
            backgroundColor: const Color(0xFA525AE8),
            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              title: const Text(
                'Wallet Dashboard',
                style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
              ],
            ),
            body: walletVM.isConnected
                ? StreamBuilder<WalletData>(
              stream: walletVM.walletDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final walletData = snapshot.data ?? WalletData();

                return Center(
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
                            const Icon(
                                Icons.account_balance_wallet_rounded,
                                size: 60,
                                color: Colors.white),
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
                            _buildInfoRow('Wallet ID',
                                walletVM.walletId ?? 'Not Connected'),
                            const SizedBox(height: 10),
                            _buildInfoRow(
                                'User Balance',
                                walletData.balance ?? 'Loading...'),
                            const SizedBox(height: 10),
                            _buildInfoRow('Token Decimals',
                                walletData.decimals ?? 'Loading...'),
                            const SizedBox(height: 10),
                            _buildInfoRow('Total Supply',
                                walletData.totalSupply ?? 'Loading...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : Center(
              child: ElevatedButton(
                onPressed: () async {
                  final walletVM =
                  Provider.of<WalletViewModel>(context, listen: false);
                  await walletVM.connectWallet();
                },
                child: const Text('Connect Wallet'),
              ),
            ),
          );
        },
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