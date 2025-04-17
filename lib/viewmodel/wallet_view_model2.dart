import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

class WalletData {
  final String? balance;
  final String? decimals;
  final String? totalSupply;

  WalletData(
      {this.balance,
      this.decimals,
      this.totalSupply});
}

class WalletViewModel extends ChangeNotifier {
  late ReownAppKitModal appKitModal;
  String _walletAddress = '';
  bool _isLoading = false;
  bool _isConnected = false;



  String get walletAddress => _walletAddress;
  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;

  Future<void> init(BuildContext context) async {
    _isLoading = true;
    notifyListeners();


    appKitModal = ReownAppKitModal(
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
      logLevel: LogLevel.error,
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

    ///Saving User Connected Session
    appKitModal!.onModalConnect.subscribe((session) {
      _isConnected = true;
      if (appKitModal!.session != null && appKitModal!.selectedChain != null) {
        final chainId = appKitModal!.selectedChain!.chainId;
        print("Chain ID: $chainId");
        final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
        _walletAddress = appKitModal!.session!.getAddress(namespace)!;
      }
      notifyListeners();
    });

    appKitModal!.onModalDisconnect.subscribe((_) {
      _isConnected = false;
      _walletAddress = '';
      notifyListeners();
    });

    await appKitModal.init();


    _isLoading = false;
    notifyListeners();
  }

  /// Connect the wallet using the ReownAppKitModal UI.
  Future<bool> connectWallet(
      BuildContext context) async {
    if (appKitModal == null) {
      await init(context);
    }
    _isLoading = true;
    notifyListeners();


    try {
      await appKitModal.openModalView();

      return _isConnected;
     } catch (e) {
      print('Error connecting to wallet: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Disconnect from the wallet and clear stored wallet info.
  Future<void> disconnectWallet() async {
    if (appKitModal == null || !_isConnected) {
      return;
    }
    _isLoading = true;
    notifyListeners();

    try {
      await appKitModal!.disconnect();
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isConnected', false);
    } catch (e) {
      print('Error disconnecting wallet: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> getBalance() async {
    if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
      throw Exception("Wallet not Connected");
    }

    try {
      _isLoading = true;
      notifyListeners();

      final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
      final abiData = jsonDecode(abiString);

      final tetherContract = DeployedContract(
        ContractAbi.fromJson(
          // abiData,
          jsonEncode(abiData),
          'eCommerce Coin',
        ),
        EthereumAddress.fromHex(
            '0x30C8E35377208ebe1b04f78B3008AAc408F00D1d'),
      );

      final chainID = appKitModal!.selectedChain!.chainId;
      print("Chain ID : $chainID");

      final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);

      final decimals = await appKitModal!.requestReadContract(
              topic: appKitModal!.session!.topic,
              chainId: chainID,
              deployedContract: tetherContract,
              functionName: 'decimals');


      // print("Addresses: $addresses (${addresses.runtimeType})");
      print("Wallet address used: $walletAddress");

      final balanceOf = await appKitModal!.requestReadContract(
              topic: appKitModal!.session!.topic,
              chainId: chainID,
              deployedContract: tetherContract,
              functionName: 'balanceOf',
              parameters: [ EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!)]
              // parameters: [ EthereumAddress.fromHex(walletAddress)]

    );


      final tokenDecimals = (decimals[0] as BigInt).toInt();
      final balance = balanceOf[0] as BigInt;

      final divisor = BigInt.from(10).pow(tokenDecimals);
      final formatBalance = balance / divisor;


      print('balanceOf: ${balanceOf[0]}');
      print('runtimeType: ${balanceOf[0].runtimeType}');

      return  '$formatBalance'  ;

    } catch (e) {
      print('Error getting balance: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<String> getTotalSupply() async {
    if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
      throw Exception("Wallet not Connected");
    }
    try {
      _isLoading = true;
      notifyListeners();

      final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
      final abiData = jsonDecode(abiString);

      final tetherContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'eCommerce Coin',
        ),
        EthereumAddress.fromHex(
            '0x30C8E35377208ebe1b04f78B3008AAc408F00D1d'),
      );

      final totalSupplyResult = await appKitModal.requestReadContract(
        deployedContract: tetherContract,
        topic: appKitModal.session!.topic,
        chainId: appKitModal.selectedChain!.chainId,
        functionName: 'totalSupply',
      );

      final decimals = await appKitModal!.requestReadContract(
          topic: appKitModal!.session!.topic,
          chainId: appKitModal.selectedChain!.chainId,
          deployedContract: tetherContract,
          functionName: 'decimals');
      final tokenDecimals = (decimals[0] as BigInt).toInt();
      final totalSupply = totalSupplyResult[0] as BigInt;
      final divisor = BigInt.from(10).pow(tokenDecimals);
      final formattedTotalSupply = totalSupply / divisor;

      print('totalSupply: ${totalSupplyResult[0]}');
      print('runtimeType: ${totalSupplyResult[0].runtimeType}');

      return '$formattedTotalSupply';
    } catch (e) {
      print('Error getting total supply: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
