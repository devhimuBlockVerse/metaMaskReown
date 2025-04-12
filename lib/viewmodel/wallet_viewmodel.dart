// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:reown_appkit/reown_appkit.dart';
// import 'package:reown_appkit_wallet_flutter/services/smart_contract_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:web3dart/web3dart.dart';
// import 'package:http/http.dart' as http;
//
// class WalletViewModel extends ChangeNotifier {
//
//   late ReownAppKitModal _appKitModal;
//   Web3Client? _web3client;
//   late SmartContractService _smartContractService;
//
//   bool _isConnected = false;
//   bool get isConnected => _isConnected;
//
//   String? _userName;
//   String? get userName => _userName;
//
//   String? _walletId;
//   String? get walletId => _walletId;
//
//   EtherAmount? _walletBalance;
//   String get balanceInEth => _walletBalance != null
//       ? _walletBalance!.getValueInUnit(EtherUnit.ether).toStringAsFixed(5)
//       : '0';
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//
//   String? _networkName;
//   String? get networkName => _networkName;
//
//   String? _chainId;
//   String? get chainId => _chainId;
//
//
//   String? _blockchainIdentity;
//   String? get  blockchainIdentity => _blockchainIdentity;
//
//   String? _userData;
//   String? get userData => _userData;
//
//   Future<void> init(BuildContext context) async {
//
//     final prefs = await SharedPreferences.getInstance();
//     final wasConnected = prefs.getBool('isConnected') ?? false;
//
//     _appKitModal = ReownAppKitModal(
//       context: context,
//       projectId: 'f3d7c5a3be3446568bcc6bcc1fcc6389',
//       metadata: const PairingMetadata(
//         name: "Example App",
//         description: "Example Description",
//         url: 'https://example.com/',
//         icons: ['https://example.com/logo.png'],
//         redirect: Redirect(
//           native: 'exampleapp',
//           universal: 'https://reown.com/exampleapp',
//           linkMode: true,
//         ),
//
//       ),
//       logLevel: LogLevel.error,
//       enableAnalytics: true,
//
//       featuresConfig: FeaturesConfig(
//         email: true,
//         socials: [
//           AppKitSocialOption.Google,
//           AppKitSocialOption.Discord,
//           AppKitSocialOption.Facebook,
//           AppKitSocialOption.GitHub,
//           AppKitSocialOption.X,
//           AppKitSocialOption.Apple,
//           AppKitSocialOption.Twitch,
//           AppKitSocialOption.Farcaster,
//         ],
//         showMainWallets: true,
//       ),
//     );
//
//
//
//     await _appKitModal.init();
//
//
//
//     ///Saving User Connected Session in Shared Preferences
//     if(wasConnected){
//       _isConnected = true;
//       _setWalletInfo();
//       _setupWeb3();
//       await _smartContractService.init();
//
//       await fetchBalance();
//     }else{
//       _isConnected = _appKitModal.isConnected;
//       if (_isConnected) {
//         _setWalletInfo();
//         if (_walletId != null) {
//           _setupWeb3();
//           await _smartContractService.init();
//           await fetchBalance();
//         }
//       }
//     }
//
//     notifyListeners();
//   }
//
//
//   Future<void> interactWithContract(String methodName, List<dynamic> parameters)async{
//     if(!_isConnected || _web3client == null || _walletId == null){
//       print("Wallet not connected or web3 client not initialized");
//       // throw Exception("Wallet not connected or web3 client not initialized.");
//       return;
//     }
//     try{
//       // final lowerCaseAddress = "0xc57ca95b47569778a828d19178114f4db188b89b";
//
//       final result = await _smartContractService.callContractMethod(
//         methodName, parameters, EthereumAddress.fromHex(EthereumAddress.fromHex(_walletId!).hexEip55)
//
//         // methodName, parameters, EthereumAddress.fromHex(_walletId!.toLowerCase())
//         // methodName, parameters, EthereumAddress.fromHex(lowerCaseAddress)
//       );
//       debugPrint("Contract call result: $result");
//     }catch (e){
//       debugPrint("Error calling contract method: $e");
//
//     }
//     notifyListeners();
//   }
//
//   Future<void> getUserDataFromContract()async{
//     if(!_isConnected || _web3client == null || _walletId == null) return;
//
//     try{
//       await _smartContractService.init();
//
//       // final lowerCaseAddress1 = "0xc57ca95b47569778a828d19178114f4db188b89b";
//
//       final result = await _smartContractService.callContractMethod(
//         // "getUserData", [], EthereumAddress.fromHex(_walletId!.toLowerCase())
//         "getUserData", [], EthereumAddress.fromHex(EthereumAddress.fromHex(_walletId!).hexEip55)
//
//       );
//       if(result != null && result is List && result.length ==2){
//         final name = result[0] as String;
//         final value = result[1];
//         _userData = "Name: $name, Value: $value";
//       }else{
//         _userData = "Unexpected result format.";
//       }
//       debugPrint("Contract call result: $result");
//
//     }catch (e){
//       _userData = "Error calling contract method: $e";
//       print("Contract Data : $_userData");
//     }
//     notifyListeners();
//   }
//
//   /// Connect the wallet using the ReownAppKitModal UI.
//   Future<void> connectWallet() async {
//     _isLoading = true;
//     notifyListeners();
//
//     if (!_appKitModal.isConnected) {
//       /// This will show the MetaMask permission dialog.
//       await _appKitModal.openModalView();
//       _isConnected = _appKitModal.isConnected;
//       if (_isConnected) {
//         _setWalletInfo();
//         if (_walletId != null) {
//           _setupWeb3();
//           await fetchBalance();
//
//           final prefs = await SharedPreferences.getInstance();
//           prefs.setBool('isConnected', true);
//         }
//       }
//     }
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   /// Disconnect from the wallet and clear stored wallet info.
//   Future<void> disconnectWallet() async {
//     _isLoading = true;
//     notifyListeners();
//
//     if (_appKitModal.isConnected) {
//       await _appKitModal.disconnect();
//     }
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setBool('isConnected', false);
//
//     _clearWalletInfo();
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   /// Helper to extract wallet info from the modal.
//   void _setWalletInfo() {
//     final wallet = _appKitModal.selectedWallet;
//     _userName = wallet?.listing.name;
//     _walletId = wallet?.listing.id;
//     _networkName = _appKitModal.selectedChain?.name;
//     _chainId = _appKitModal.selectedChain?.chainId;
//     _blockchainIdentity = _appKitModal.blockchainIdentity?.name;
//
//   }
//
//   /// Clear wallet info on disconnect.
//   void _clearWalletInfo() {
//     _isConnected = false;
//     _userName = null;
//     _walletId = null;
//     _walletBalance = null;
//   }
//
//   /// Set up the web3 client with the desired RPC URL.
//   // void _setupWeb3() {
//   //   const rpcUrl = "https://polygon-rpc.com"; // target chain.
//   //    _web3client = Web3Client(rpcUrl, http.Client());
//   //   _smartContractService = SmartContractService(_web3client,this);
//   // }
//   void _setupWeb3() {
//     final httpClient = Client();
//     _web3client = Web3Client('https://polygon-rpc.com', httpClient);
//     _smartContractService = SmartContractService(_web3client, this);
//   }
//
//   /// Fetch the native balance for the connected wallet. EthereumAddress
//   Future<void> fetchBalance() async {
//     if (_web3client != null && _walletId != null) {
//       try {
//         final address = EthereumAddress.fromHex(EthereumAddress.fromHex(_walletId!).hexEip55);
//         // final address = EthereumAddress.fromHex(_walletId!.toLowerCase());
//         // final lowerCaseAddress = "0xc57ca95b47569778a828d19178114f4db188b89b";
//         // final address = EthereumAddress.fromHex(lowerCaseAddress);
//         _walletBalance = await _web3client!.getBalance(address);
//       } catch (e) {
//         debugPrint("Error fetching balance: $e");
//       }
//       notifyListeners();
//     }
//   }
//
//   /// FutureWork : Start a timer to refresh the balance periodically.
//   void startBalanceRefreshTimer() {
//     Future.doWhile(() async {
//       await Future.delayed(const Duration(seconds: 15));
//       if (_isConnected) {
//         await fetchBalance();
//         return true;
//       }
//       return false;
//     });
//   }
//
//
// }
