import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/buttonComponent.dart';
import '../viewmodel/wallet_viewmodel.dart';
import 'dashboard.dart';




class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WalletViewModel>(context, listen: false).init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final walletVM = Provider.of<WalletViewModel>(context,listen: false);

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
              Consumer<WalletViewModel>(
                builder: (context, walletVM, _){
                 return Column(
                   children: [
                     ReownAppKitButton(
                       label: walletVM.isLoading
                           ? 'Please Wait...'
                           : walletVM.isConnected
                           ? 'Disconnect Wallet'
                           : 'Connect Wallet',
                       icon: walletVM.isLoading
                           ? Icons.hourglass_empty
                           : walletVM.isConnected
                           ? Icons.link_off
                           : Icons.link,
                       onPressed: () async {
                         await walletVM.connectWallet();

                         if (walletVM.isConnected) {
                           // Navigate to dashboard on successful wallet connect
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => const DashboardView()),
                           );
                         } else {
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(
                               content: Text("Wallet connection failed."),
                             ),
                           );
                         }
                       },
                     ),
                     // ElevatedButton.icon(
                     //    // onPressed: walletVM.isLoading
                     //    //     ? null : () async {
                     //    //
                     //    //
                     //    //   await walletVM.connectWallet();
                     //    //   await Future.delayed(Duration(milliseconds: 100));
                     //    //
                     //    //   if (walletVM.isConnected) {
                     //    //     Navigator.pushReplacement(
                     //    //       context,
                     //    //       MaterialPageRoute(
                     //    //         builder: (_) => const DashboardView(),
                     //    //       ),
                     //    //     );
                     //    //   }
                     //    // },
                     //   onPressed: () async {
                     //     await walletVM.connectWallet();
                     //
                     //     if (walletVM.isConnected) {
                     //       // Navigate to dashboard on successful wallet connect
                     //       Navigator.push(
                     //         context,
                     //         MaterialPageRoute(builder: (context) => const DashboardView()),
                     //       );
                     //     } else {
                     //       ScaffoldMessenger.of(context).showSnackBar(
                     //         const SnackBar(
                     //           content: Text("Wallet connection failed."),
                     //         ),
                     //       );
                     //     }
                     //   },
                     //    icon: Icon(walletVM.isLoading
                     //        ? Icons.hourglass_empty
                     //        : walletVM.isConnected
                     //        ? Icons.link_off
                     //        : Icons.link),
                     //    label: Text(walletVM.isLoading
                     //        ? 'Please Wait...'
                     //        : walletVM.isConnected
                     //        ? 'Disconnect Wallet'
                     //        : 'Connect Wallet'),
                     //  ),
                   ],
                 );
                },
                // child:
              ),
            ],
          ),
        ),
      ),
    );
  }
}
