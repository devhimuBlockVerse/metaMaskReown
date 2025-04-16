import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:reown_appkit_wallet_flutter/services/smart_contract_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class WalletData {
  final String? balance;
  final String? decimals;
  final String? totalSupply;

  WalletData({this.balance, this.decimals, this.totalSupply});
}

class WalletViewModel extends ChangeNotifier {

  late ReownAppKitModal _appKitModal;

  EthereumAddress? _publicAddress;


  final StreamController<WalletData> _walletDataController =
  StreamController<WalletData>.broadcast();
  Stream<WalletData> get walletDataStream => _walletDataController.stream;


  bool _isConnected = false;
  String? _userName;
  String? _walletId;
  bool _isLoading = false;
  String? _chainId;
  String? _userData;

  String? _name;
  String? _symbol;
  BigInt? _balanace;
   int? _decimals;
   BigInt? _totalSupply;
  bool _isFetchingDetails = false;
  bool get isFetchingDetails => _isFetchingDetails;

  String? get walletId => _walletId;
  bool get isConnected => _isConnected;
  String? get userName => _userName;

  bool get isLoading => _isLoading;
   String? get chainId => _chainId;
   String? get userData => _userData;


  String? get name => _name;
  String? get symbol => _symbol;
  BigInt? get balance => _balanace;
  EthereumAddress? get publicAddress => _publicAddress;
   int? get decimals => _decimals;
   BigInt? get totalSupply => _totalSupply;


   Future<void> init(BuildContext context) async {

    final prefs = await SharedPreferences.getInstance();
    final wasConnected = prefs.getBool('isConnected') ?? false;

    _appKitModal = ReownAppKitModal(
      context: context,
      projectId: 'f3d7c5a3be3446568bcc6bcc1fcc6389',
      metadata: const PairingMetadata(
        name: "Example App",
        description: "Example Description",
        url: 'https://example.com/',
        icons: ['https://example.com/logo.png'],
        redirect: Redirect(
          native: 'exampleapp',
          universal: 'https://reown.com/exampleapp',
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
    await _appKitModal.init();

    ///Saving User Connected Session in Shared Preferences


    if (wasConnected && _appKitModal.isConnected) {

      _isConnected = true;
      await waitForSession();
      if(_appKitModal.session != null && _walletId != null ){
        await _fetchDetails();
        _setWalletInfo();
        notifyListeners();

      }else {
        debugPrint('[ERROR] Session or wallet ID not immediately available after init.');
      }

    } else {
      _isConnected = _appKitModal.isConnected;
      if (_isConnected) {
        await _fetchDetails();
        _setWalletInfo();
        prefs.setBool('isConnected', true);
        notifyListeners();

      }
    }

    notifyListeners();
  }

  /// Connect the wallet using the ReownAppKitModal UI.
   Future<void> connectWallet() async {
     _isLoading = true;
     notifyListeners();

     if (!_appKitModal.isConnected) {
       await _appKitModal.openModalView();
       _isConnected = _appKitModal.isConnected;
       await waitForSession();

       if (_isConnected && _appKitModal.session != null && _walletId != null) {
         await _fetchDetails();
         _setWalletInfo();

          final prefs = await SharedPreferences.getInstance();
         prefs.setBool('isConnected', true);
         notifyListeners();
       }else {
         debugPrint('[ERROR] Session or wallet ID not immediately available after connect.');
        }
     }
     _isLoading = false;
     notifyListeners();
   }
  /// Disconnect from the wallet and clear stored wallet info.
  Future<void> disconnectWallet() async {
    _isLoading = true;
    notifyListeners();

    if (_appKitModal.isConnected) {
      await _appKitModal.disconnect();
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isConnected', false);

    _clearWalletInfo();
    _isLoading = false;
    notifyListeners();
  }

  /// Helper to extract wallet info from the modal.
  void _setWalletInfo() {
    final wallet = _appKitModal.selectedWallet;
    final chain = _appKitModal.selectedChain;

    if(wallet == null || wallet.listing == null){
      debugPrint('[ERROR] Wallet or wallet listing is null!');
      return;
    }

    _userName = wallet.listing.name;
    _walletId = wallet.listing.id;
    if (chain != null) {
      _chainId = chain.chainId;
    } else {
      debugPrint('[ERROR] Selected chain is null!');
      _chainId = null;
    }
  }

  /// Clear wallet info on disconnect.
  void _clearWalletInfo() {
    _isConnected = false;
    _userName = null;
    _walletId = null;

    _decimals = null ;
    _totalSupply = null;
    _balanace = null;
  }

  /// Service Wallet COdes
  Future<void>initWallet()async{
     await _fetchDetails();
     _setWalletInfo();
    _isConnected = true;
    notifyListeners();
  }

   Future<void>_fetchDetails()async{

     _isFetchingDetails = true;
     notifyListeners();
     try{
       print('[DEBUG] Starting contract calls...');
       print('Wallet ID: $_walletId');
       // final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
       // final abiJson = jsonDecode(abiString);
       //
       // final myContract = DeployedContract(
       //   ContractAbi.fromJson(jsonEncode(abiJson), "MyContract"),
       //   EthereumAddress.fromHex("0x298f3EF46F26625e709c11ca2e84a7f34489C71d"),
       // );


       if (_appKitModal.session == null || _walletId == null) {
         throw Exception('Session or wallet ID is null');
       }


       final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
       final abiJson = jsonDecode(abiString) as List<dynamic>;
       // final abiJson = jsonDecode(abiString);

       final myContract = DeployedContract(
           ContractAbi.fromJson(
             jsonEncode(abiJson), 'MyContract',),
             EthereumAddress.fromHex('0x298f3EF46F26625e709c11ca2e84a7f34489C71d'),
       );

        final chainId = _appKitModal.selectedChain!.chainId;
       print("Chain ID: $chainId");

       final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
       // final userAddress = EthereumAddress.fromHex(
       //   _appKitModal.session!.getAddress(namespace)!,
       //   // _appKitModal.session!.getAddress(namespace).toString(),
       // );
       final addressHex = _appKitModal.session?.getAddress(namespace);
       if (addressHex == null || addressHex.length < 42) {
         debugPrint('[ERROR] Invalid user address: $addressHex');
         return;
       }
       // final userAddress = EthereumAddress.fromHex(addressHex);

       EthereumAddress? userAddress;
       try {
         userAddress = EthereumAddress.fromHex(addressHex);
       } catch (e) {
         debugPrint('[ERROR] Failed to parse user address: $e, Raw address: $addressHex');
         return;
       }
       print("User Address: $userAddress");


       // final decimals = await _appKitModal.requestReadContract(
       //   deployedContract: myContract,
       //   topic: _appKitModal.session!.topic,
       //   chainId: chainId,
       //   functionName: 'decimals',
       // );
       // int? fetchedDecimals;
       //
       // print('[DEBUG] Decimals Result: $decimals (${decimals.runtimeType})');
       //
       // if (decimals.isNotEmpty && decimals.first != null) {
       //   fetchedDecimals = decimals.first is BigInt
       //       ? (decimals.first as BigInt).toInt()
       //       : decimals.first as int?;
       //   print('[DEBUG] Parsed Decimals: $_decimals');
       // } else {
       //   print('[ERROR] Decimals returned empty list');
       //   _decimals = null;
       // }
       //
       //
       //
       //
       // final balanceOf = await _appKitModal.requestReadContract(
       //   deployedContract: myContract,
       //   topic: _appKitModal.session!.topic,
       //   chainId: chainId,
       //   functionName: 'balanceOf',
       //   parameters: [userAddress],
       //
       // );
       // BigInt? fetchedBalance;
       //
       // print('[DEBUG] BalanceOf Result: $balanceOf (${balanceOf.runtimeType})');
       // if (balanceOf.isNotEmpty && balanceOf.first != null) {
       //   fetchedBalance = balanceOf.first as BigInt?;
       //   print('[DEBUG] Parsed Balance: $_balanace');
       // } else {
       //   print('[ERROR] BalanceOf returned empty list');
       //   _balanace = null;
       // }
       //
       //
       //
       // final totalSupply = await _appKitModal.requestReadContract(
       //     topic: _appKitModal.session!.topic,
       //     chainId: chainId,
       //     deployedContract: myContract,
       //     functionName: 'totalSupply'
       // );
       // BigInt? fetchedTotalSupply;
       //
       // print('[DEBUG] TotalSupply Result: $totalSupply (${totalSupply.runtimeType})');
       // if (totalSupply.isNotEmpty && totalSupply.first != null) {
       //   fetchedTotalSupply = totalSupply.first as BigInt?;
       //   print('[DEBUG] Parsed Total Supply: $_totalSupply');
       // } else {
       //   print('[ERROR] TotalSupply returned empty list');
       //   _totalSupply = null;
       // }

       // Fetch contract details
       final results = await Future.wait([
         _appKitModal.requestReadContract(
           deployedContract: myContract,
           topic: _appKitModal.session!.topic,
            chainId: chainId,
           functionName: 'decimals',

         ),
         _appKitModal.requestReadContract(
           deployedContract: myContract,
           topic: _appKitModal.session!.topic,
           chainId: chainId,
           functionName: 'balanceOf',
           parameters: [userAddress],
           // parameters: [EthereumAddress.fromHex(_appKitModal.session!.getAddress(namespace).toString()),],
         ),
         _appKitModal.requestReadContract(
           deployedContract: myContract,
           topic: _appKitModal.session!.topic,
           chainId: chainId,
           functionName: 'totalSupply',


         ),
       ]);



       _decimals = (results[0].isNotEmpty && results[0].first != null)
           ? (results[0].first is BigInt
           ? (results[0].first as BigInt).toInt()
           : results[0].first as int)
           : null;

       _balanace = (results[1].isNotEmpty && results[1].first != null) ? results[1].first as BigInt : null;

       _totalSupply = (results[2].isNotEmpty && results[2].first != null) ? results[2].first as BigInt : null;
      /**  **/

        _walletDataController.add(WalletData(
                 balance: _formatBalance(_balanace, _decimals),
             decimals: _decimals.toString(),
                totalSupply: _formatBalance(_totalSupply, _decimals),
             ));





       notifyListeners();

     }catch (e){
       _walletDataController.addError(e);
       print("[ERROR] fetching contract details failed:  $e");


     }finally{
       // _walletDataController.add(WalletData(
       //   balance: _formatBalance(_balanace, _decimals),
       //   decimals: _decimals.toString(),
       //
       //   totalSupply: _formatBalance(_totalSupply, _decimals),
       // ));
       _isFetchingDetails = false;
       notifyListeners();
     }



   }

  Future<void> waitForSession({Duration timeout = const Duration(seconds: 5)}) async {
    DateTime startTime = DateTime.now();
    while (DateTime.now().difference(startTime) < timeout) {
      if (_appKitModal.session != null && _walletId != null) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }
    debugPrint('[WARNING] Timeout waiting for session and wallet ID.');
  }

  String _formatBalance(BigInt? raw, int? decimals) {
    if (raw == null || decimals == null) return 'N/A';
    final divisor = BigInt.from(10).pow(decimals);
    final balance = raw / divisor;
    return balance.toString();
  }
  // String _formatBalance(BigInt? raw, int? decimals) {
  //   if (raw == null || decimals == null) return 'N/A';
  //
  //   try {
  //     // Convert to double for proper division
  //     final rawDouble = raw.toDouble();
  //     final divisor = pow(10, decimals).toDouble();
  //     final result = rawDouble / divisor;
  //
  //     // Format to show up to 6 decimal places
  //     return result.toStringAsFixed(6).replaceAll(RegExp(r'\.?0*$'), '');
  //   } catch (e) {
  //     debugPrint('Error formatting balance: $e');
  //     return 'N/A';
  //   }
  // }

  @override
  void dispose() {
    _walletDataController.close();
    super.dispose();
  }

}


// Future<String> transfer(String toAddress, BigInt amount)async{
//   if(_contract == null || _credentials == null){
//     throw Exception("Contract,credentials or Wallet not initialized");
//   }
//
//   final transferFunction = _contract!.function("transfer");
//
//   final txHash = await _web3client!.sendTransaction(
//     _credentials!,
//     Transaction.callContract(
//       contract: _contract!,
//       function: transferFunction,
//       parameters: [EthereumAddress.fromHex(toAddress),amount],
//     ),
//
//     // chainId: 11155111, // Sepolia chain ID
//     chainId: _appKitModal.selectedChain!.chainId.toInt(), // Sepolia chain ID
//   );
//
//   //reFetch balance after transfer
//   // await _fetchDetails();
//   notifyListeners();
//
//   return txHash;
//
//
// }