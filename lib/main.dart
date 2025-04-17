import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:reown_appkit_wallet_flutter/view/dashboard.dart';
 import 'package:reown_walletkit/reown_walletkit.dart';
// import 'package:reown_appkit_wallet_flutter/viewmodel/wallet_viewmodel.dart';
import 'dart:ui';
import '../viewmodel/wallet_view_model2.dart';


import 'components/buttonComponent.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletViewModel(),)
      ],

      child: MaterialApp(
        title: 'Reown AppKit Wallet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: const DashboardView(),
       ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() =>
      _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final ReownAppKitModal _appKitModal;
  bool isLoading = false;
  bool isNetworkSelecting = false;
  String? selectedNetworkLogo;
  bool isNetworkUpdated = false;
  String? currentBalance;

  @override
  void initState() {
    super.initState();

    _appKitModal = ReownAppKitModal(
      context: context,
      projectId:
          'f3d7c5a3be3446568bcc6bcc1fcc6389',
      metadata: const PairingMetadata(
        name: "Example App",
        description: "Example Description",
        url: 'https://example.com/',
        icons: ['https://example.com/logo.png'],
        redirect: Redirect(
          native: 'exampleapp',
          universal:
              'https://reown.com/exampleapp',
          linkMode: true,
        ),
      ),
      logLevel: LogLevel.info,
      enableAnalytics: true,
      featuresConfig: FeaturesConfig(
        email: true,
        socials: [
          AppKitSocialOption.Google,
          AppKitSocialOption.Discord,
          AppKitSocialOption.Facebook,
          AppKitSocialOption.GitHub,
          AppKitSocialOption.X,
          AppKitSocialOption.Apple,
          AppKitSocialOption.Twitch,
          AppKitSocialOption.Farcaster,

        ],
        showMainWallets: true,
      ),
    );
    _appKitModal
        .init()
        .then((value) => setState(() {

    }));
  }

  void _updateNetwork() {
    setState(() {
      isNetworkUpdated = true;
    });
  }


  Future<DeployedContract> loadContract(String contractAddress) async {
    String abiCode = await rootBundle.loadString("assets/abi/MyContract.json");
    final contract = DeployedContract(
      ContractAbi.fromJson(abiCode, "MyContract"),
      EthereumAddress.fromHex(contractAddress),
    );
    return contract;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade700,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Card(
            elevation: 8,
            shadowColor: Colors.blueAccent.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(19.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  ReownAppKitButton(

                    label: isNetworkSelecting
                        ? 'Selecting Network...' // Show during selection
                        : selectedNetworkLogo != null
                        ? (isNetworkUpdated ? 'Network Updated' : 'Network Connected') : 'Select Network',
                    icon: isNetworkSelecting ? Icons.hourglass_empty : Icons.network_wifi,
                     onPressed: () async {
                      setState(() {isNetworkSelecting = true;});
                      await Future.delayed(Duration(seconds: 1));
                      await _appKitModal.openNetworksView();
                      setState(() => isNetworkSelecting = false);
                      _updateNetwork();
                    },
                  ),

                  const SizedBox(height: 16),
                  ReownAppKitButton(
                    label: isLoading ? 'Please Wait...' : _appKitModal.isConnected
                        ? 'Disconnect' : 'Connect Wallet',
                    icon: isLoading ? Icons.hourglass_empty : _appKitModal.isConnected
                        ? Icons.link_off : Icons.link,
                    onPressed: () async {
                      setState(() => isLoading = true);
                      await Future.delayed(Duration(seconds: 1));
                      _appKitModal.isConnected ? await _appKitModal.disconnect() : await _appKitModal.openModalView();
                      setState(() => isLoading = false);
                    },
                  ),

                  const SizedBox(height: 16),
                  if (_appKitModal.isConnected) ...[
                    // Text('Current Balance: ${currentBalance ?? 'Loading...'}'), // Display balance

                    _buildCardItem(
                      context,
                      ReownAppKitButton(
                        label: 'Account',
                        icon: Icons.account_circle,
                        onPressed: () => _appKitModal.openModalView(),
                      ),
                    ),
                    _buildCardItem(
                      context,
                      ReownAppKitButton(
                        label: 'Balance',
                        icon: Icons.account_balance_wallet,
                        onPressed: () => _appKitModal.openModalView(),
                      ),
                    ),
                    // _buildCardItem(
                    //   context,
                    //   ReownAppKitButton(
                    //     label: 'Address',
                    //     icon: Icons.location_on,
                    //     onPressed: () => _appKitModal.openModalView(),
                    //   ),
                    // ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: child,
      ),
    );
  }

}
