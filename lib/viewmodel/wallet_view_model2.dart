import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:reown_appkit_wallet_flutter/services/smart_contract_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class WalletViewModel extends ChangeNotifier {
  // final String _rpcUrl ="https://sepolia.infura.io/v3/b6521574dded4cc4b16f0975d484da49";
  //  final String _rpcUrl = 'https://mainnet.infura.io/v3/b6521574dded4cc4b16f0975d484da49';
   final String _rpcUrl = 'https://sepolia.io/v3/b6521574dded4cc4b16f0975d484da49';

  // From my Meta mask Account
  final String _privateKey = '4c9d31834be536e8ef62d3e1ab8997775825de42fdeb76fae2efbfbc9a2db159';

 // From Etherscan Website
 //  final String _contractAddress = '0x30C8E35377208ebe1b04f78B3008AAc408F00D1d';
   final String _contractAddress = '0x298f3EF46F26625e709c11ca2e84a7f34489C71d';

  late ReownAppKitModal _appKitModal;
  late Web3Client? _web3client;
  DeployedContract? _contract;
  EthereumAddress? _publicAddress;
  Credentials? _credentials;


  bool _isConnected = false;
  String? _userName;
  String? _walletId;
  EtherAmount? _walletBalance;
  bool _isLoading = false;
  String? _networkName;
  String? _chainId;
  String? _blockchainIdentity;
  String? _userData;

  String? _name;
  String? _symbol;
  BigInt? _balanace;
   int? _decimals;
   BigInt? _totalSupply;

  String? get walletId => _walletId;
  bool get isConnected => _isConnected;
  String? get userName => _userName;
  String get balanceInEth => _walletBalance != null
      ? _walletBalance!.getValueInUnit(EtherUnit.ether).toStringAsFixed(5)
      : '0';
  bool get isLoading => _isLoading;
  String? get networkName => _networkName;
  String? get chainId => _chainId;
  String? get  blockchainIdentity => _blockchainIdentity;
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
    // if(wasConnected){
    //   _isConnected = true;
    //   _setWalletInfo();
    //   // _setupWeb3();
    //   await initWallet();
    //   await fetchBalance();
    // }else{
    //   _isConnected = _appKitModal.isConnected;
    //   if (_isConnected) {
    //     _setWalletInfo();
    //     if (_walletId != null) {
    //       // _setupWeb3();
    //       await initWallet();
    //       await fetchBalance();
    //
    //     }
    //   }
    // }

    if (wasConnected) {
      _isConnected = true;
      _setWalletInfo();
      await _setupWeb3();
      await _loadContract();
      await _fetchDetails();
     } else {
      _isConnected = _appKitModal.isConnected;
      if (_isConnected) {
        _setWalletInfo();
        await _setupWeb3();
        await _loadContract();
        await _fetchDetails();
         prefs.setBool('isConnected', true);
      }
    }

    notifyListeners();
  }




  /// Connect the wallet using the ReownAppKitModal UI.
  // Future<void> connectWallet() async {
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   if (!_appKitModal.isConnected) {
  //     /// This will show the MetaMask permission dialog.
  //     await _appKitModal.openModalView();
  //     _isConnected = _appKitModal.isConnected;
  //     if (_isConnected) {
  //       _setWalletInfo();
  //       if (_walletId != null) {
  //         _setupWeb3();
  //         await fetchBalance();
  //
  //         final prefs = await SharedPreferences.getInstance();
  //         prefs.setBool('isConnected', true);
  //       }
  //     }
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  // }
   Future<void> connectWallet() async {
     _isLoading = true;
     notifyListeners();

     if (!_appKitModal.isConnected) {
       await _appKitModal.openModalView();
       _isConnected = _appKitModal.isConnected;
       if (_isConnected) {
         _setWalletInfo();
         await _setupWeb3();
         await _loadContract();
         await _fetchDetails();
          final prefs = await SharedPreferences.getInstance();
         prefs.setBool('isConnected', true);
         notifyListeners();
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
    _userName = wallet?.listing.name;
    _walletId = wallet?.listing.id;
    _networkName = _appKitModal.selectedChain?.name;
    _chainId = _appKitModal.selectedChain!.chainId;
    _blockchainIdentity = _appKitModal.blockchainIdentity?.name;

  }

  /// Clear wallet info on disconnect.
  void _clearWalletInfo() {
    _isConnected = false;
    _userName = null;
    _walletId = null;
    _walletBalance = null;
    _name = null;
    _symbol = null;
    _decimals = null ;
    _totalSupply = null;
    _balanace = null;
  }

  /// Set up the web3 client with the desired RPC URL.
  // void _setupWeb3() {
  //   const rpcUrl = "https://polygon-rpc.com"; // target chain.
  //    _web3client = Web3Client(rpcUrl, http.Client());
  //   _smartContractService = SmartContractService(_web3client,this);
  // }
 Future<void> _setupWeb3() async{
    // final httpClient = Client();
    // _web3client = Web3Client(_rpcUrl, httpClient);
    //
    _web3client = Web3Client(_rpcUrl, Client());
    _credentials = EthPrivateKey.fromHex(_privateKey);
   }

  /// Fetch the native balance for the connected wallet. EthereumAddress
  Future<void> fetchBalance() async {
    if (_web3client != null && _walletId != null) {
      try {
        final address = EthereumAddress.fromHex(EthereumAddress.fromHex(_walletId!).hexEip55);
        // final address = EthereumAddress.fromHex(_walletId!.toLowerCase());
        // final lowerCaseAddress = "0xc57ca95b47569778a828d19178114f4db188b89b";
        // final address = EthereumAddress.fromHex(lowerCaseAddress);
        _walletBalance = await _web3client!.getBalance(address);
      } catch (e) {
        debugPrint("Error fetching balance: $e");
      }
      notifyListeners();
    }
  }

  /// FutureWork : Start a timer to refresh the balance periodically.
  void startBalanceRefreshTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 15));
      if (_isConnected) {
        await fetchBalance();
        return true;
      }
      return false;
    });
  }

  /// Service Wallet COdes
  Future<void>initWallet()async{
    // _web3client = Web3Client(_rpcUrl, Client());

    _credentials = EthPrivateKey.fromHex(_privateKey);
    _publicAddress = await _credentials!.extractAddress();
    // _publicAddress = await _credentials!.address;

    await _loadContract();
    await _fetchDetails();
    _isConnected = true;
    notifyListeners();
  }

  // Future<void>_loadContract()async{
  //   final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
  //   // final abiJson = jsonDecode(abiString)as List<dynamic>;
  //   // final contractAbi = ContractAbi.fromJson(jsonEncode(abiJson), "MyContract");
  //   // final contractAbi = ContractAbi.fromJson(abiString, "MyContract");
  //
  //
  //
  //   final contractAbi = ContractAbi.fromJson(jsonEncode(abiString), "MyContract");
  //
  //   _contract = DeployedContract(
  //     contractAbi,
  //     EthereumAddress.fromHex(_contractAddress),
  //   );
  //
  // }
   Future<void> _loadContract() async {
     try {
       final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
       // final abiJson = jsonDecode(abiString) as List<dynamic>;
       //
       // // final contractAbi = ContractAbi.fromJson(jsonEncode(abiJson), "MyContract");
       //   final contractAbi = ContractAbi.fromJson(jsonEncode(abiString), "Token"); ///


       // // If MyContract.json is a pure array (most likely):
       //  final contractAbi = ContractAbi.fromJson(abiString, "Token");
        final contractAbi = ContractAbi.fromJson(abiString, "Tether USD");

       _contract = DeployedContract(
         contractAbi,
         EthereumAddress.fromHex(_contractAddress),
       );
       print('Contract loaded successfully');
     } catch (e) {
       print('Error loading contract: $e');
       rethrow;
     }
   }

  //  Future<void>_fetchDetails()async{
  //   print('[DEBUG] Starting contract calls...');
  //   print('Contract address: $_contractAddress');
  //   print('Wallet ID: $_walletId');
  //   final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId!);
  //
  //   if (_contract == null || _web3client == null || walletId == null){
  //     print("Contract, client, or wallet ID not initialized");
  //     return;
  //   }
  //
  //   try{
  //     final nameFunction = _contract!.function("name");
  //     final symbolFunction = _contract!.function("symbol");
  //     final balanceFunction = _contract!.function("balanceOf");
  //
  //     print('[DEBUG] Calling "name" function...');
  //
  //     final nameResult = await _web3client!.call(
  //       contract: _contract!,
  //       function: nameFunction,
  //       params: [],
  //     );
  //     _name = nameResult.first as String;
  //     print('Name: $_name');
  //     print('[DEBUG] Name result: $nameResult');
  //
  //     print('[DEBUG] Calling "symbol" function...');
  //     final symbolResult = await _web3client!.call(
  //       contract: _contract!,
  //       function: symbolFunction,
  //       params: [],
  //     );
  //     _symbol = symbolResult.first as String;
  //     print('Symbol: $_symbol');
  //     print('[DEBUG] Symbol result: $symbolResult');
  //
  //     print('[DEBUG] Calling "balanceOf" function...');
  //     final balanceResult = await _web3client!.call(
  //       contract: _contract!,
  //       function: balanceFunction,
  //       params: [_publicAddress!],
  //       // params: [EthereumAddress.fromHex(walletId!)]
  //     );
  //     _balanace = balanceResult.first as BigInt;
  //     print('Balance: $_balanace');
  //     print('[DEBUG] Balance result: $balanceResult');
  //
  //
  //     // _name = nameResult[0] as String;
  //     // _symbol = symbolResult[0] as String;
  //     // _balanace = balanceResult[0] as BigInt;
  //     // notifyListeners();
  //
  //   }catch (e, stacktrace){
  //     print("Error fetching details: $e");
  //     print('[STACKTRACE] $stacktrace');
  //
  //   }
  //   notifyListeners();
  //
  // }


   Future<void>_fetchDetails()async{
     print('[DEBUG] Starting contract calls...');
     print('Contract address: $_contractAddress');
     print('Wallet ID: $_walletId');
     final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId!);

     if (_contract == null || _web3client == null || walletId == null){
       print("Contract, client, or wallet ID not initialized");
       return;
     }

     try{

       print('[DEBUG] Calling "name" function...');
       final decimals = await _appKitModal.requestReadContract(
         topic: _appKitModal.session!.topic,
         chainId: chainId!,
         deployedContract: _contract!,
         functionName: 'decimals',
       );

       final balanceOf = await _appKitModal.requestReadContract(
         deployedContract: _contract!,
         topic: _appKitModal.session!.topic,
         chainId: chainId!,
         functionName: 'balanceOf',
         parameters: [
           EthereumAddress.fromHex(_appKitModal.session!.getAddress(namespace)!),

         ],
       );
       print("Address: ${_appKitModal.session!.getAddress(namespace)}");

       final totalSupply = await _appKitModal.requestReadContract(
         deployedContract: _contract!,
         topic: _appKitModal.session!.topic,
         chainId: _appKitModal.selectedChain!.chainId,
         functionName: 'totalSupply',
       );

       print("Decimals: $decimals");
       _decimals = decimals.first.toInt();
       print("Balance: $balanceOf");
       _balanace = balanceOf.first as BigInt;
       print("Total Supply: $totalSupply");
       _totalSupply = totalSupply.first as BigInt;

       notifyListeners();

     }catch (e, stacktrace){
       print("Error fetching details: $e");
       print('[STACKTRACE] $stacktrace');

     }
     notifyListeners();

   }



  Future<String> transfer(String toAddress, BigInt amount)async{
    if(_contract == null || _credentials == null){
      throw Exception("Contract,credentials or Wallet not initialized");
    }

    final transferFunction = _contract!.function("transfer");

    final txHash = await _web3client!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: transferFunction,
        parameters: [EthereumAddress.fromHex(toAddress),amount],
      ),

      // chainId: 11155111, // Sepolia chain ID
      chainId: _appKitModal.selectedChain!.chainId.toInt(), // Sepolia chain ID
    );

    //reFetch balance after transfer
    await _fetchDetails();
    notifyListeners();

    return txHash;


  }


}
