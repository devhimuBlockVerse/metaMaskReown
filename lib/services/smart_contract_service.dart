//
//
// import 'package:flutter/services.dart';
// // import 'package:reown_appkit_wallet_flutter/viewmodel/wallet_viewmodel.dart';
// import 'package:web3dart/web3dart.dart';
//
// import '../viewmodel/wallet_view_model2.dart';
//
// class SmartContractService {
//   final Web3Client? web3client;
//   late DeployedContract _contract;
//   late ContractAbi _abiCode;
//   late EthereumAddress _contractAddress;
//    bool _isInitialized = false;
//    // final String contractAddress;
//    final WalletViewModel _walletViewModel;
//
//   SmartContractService(this.web3client, this._walletViewModel);
//
//
//   Future<void> init() async {
//     if (_isInitialized) return;
//
//     try {
//       await getUserContractAddress();
//
//       String abiString = await rootBundle.loadString("assets/abi/MyContract.json");
//       _abiCode = ContractAbi.fromJson(abiString, "MyContract");
//
//       //_contractAddress = EthereumAddress.fromHex(contractAddress);
//
//       _contract = DeployedContract(_abiCode, _contractAddress);
//
//       _isInitialized = true;
//       print("SmartContractService initialized successfully!");
//     } catch (e) {
//       print("Error initializing SmartContractService: $e");
//     }
//   }
//
//   Future<dynamic> callContractMethod(String functionName, List<dynamic> args, EthereumAddress from) async {
//     if (web3client == null || !_isInitialized) {
//       throw Exception("Web3 client not initialized or contract not loaded.");
//     }
//
//     try {
//       await init();
//
//       final function = _contract.function(functionName);
//       final result = await web3client!.call(
//         contract: _contract,
//         function: function,
//         params: args,
//       );
//       return result;
//     } catch (e) {
//       print("Error calling contract method $functionName: $e");
//       rethrow;
//     }
//   }
//
//
//   Future<String> sendTransaction(String functionName, List<dynamic> args, EthereumAddress from, String privateKey) async {
//     if (web3client == null || !_isInitialized) {
//       throw Exception("Web3 client not initialized or contract not loaded.");
//     }
//
//     try {
//       await init(); // Ensure initialization
//
//       final function = _contract.function(functionName);
//       final credentials = EthPrivateKey.fromHex(privateKey);
//
//       final transactionHash = await web3client!.sendTransaction(
//         credentials,
//         Transaction.callContract(
//           contract: _contract,
//           function: function,
//           parameters: args,
//           from: from,
//         ),
//         chainId: 80001, // ID 80001 for Mumbai)
//       );
//
//       return transactionHash;
//     } catch (e) {
//       print("Error sending transaction for method $functionName: $e");
//       rethrow;
//     }
//   }
//
//
//   Future<void> getUserContractAddress() async {
//     final String factoryAbi = await rootBundle.loadString("assets/abi/FactoryContract.json");
//
//     // final EthereumAddress factoryAddress = EthereumAddress.fromHex('0x298f3EF46F26625e709c11ca2e84a7f34489C71d');
//     final EthereumAddress factoryAddress = EthereumAddress.fromHex('0x1234567890ABCDEF1234567890abcdef12345678');
//     final ContractAbi factoryAbiCode = ContractAbi.fromJson(factoryAbi, "FactoryContract");
//
//     final DeployedContract factoryContract = DeployedContract(factoryAbiCode, factoryAddress);
//
//     final getContractFunction = factoryContract.function("getContractForUser");
//
//     final userWallet = EthereumAddress.fromHex(EthereumAddress.fromHex(_walletViewModel.walletId!).hexEip55);
//     // final userWallet = EthereumAddress.fromHex(_walletViewModel.walletId!.toLowerCase());
//     // final lowerCaseAddress = "0xc57ca95b47569778a828d19178114f4db188b89b";
//     // final userWallet = EthereumAddress.fromHex(lowerCaseAddress);
//
//     final response = await web3client!.call(
//       contract: factoryContract,
//       function: getContractFunction,
//       params: [userWallet],
//     );
//
//     final userContractAddress = response.first as EthereumAddress;
//     _contractAddress = userContractAddress;
//
//     print("User's smart contract address: $_contractAddress");
//   }
//
// }