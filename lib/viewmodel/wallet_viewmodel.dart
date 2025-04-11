//import 'package:flutter/material.dart';
// import 'package:reown_appkit/appkit_modal.dart';
// import 'package:reown_appkit/reown_appkit.dart';
//
// import 'package:http/http.dart' as http;
// import 'package:web3dart/web3dart.dart';
/**
class WalletViewModel extends ChangeNotifier{


  late final ReownAppKitModal _appKitModal;

  // bool isLoading = false ;
  // bool isConnected = false;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool isNetworkSelecting = false;
  String? selectedNetworkLogo;
  WalletModel ? wallet;

  Web3Client? _web3client;

  String? _walletAddress;
  String? get walletAddress => _walletAddress;

  EtherAmount? _walletBalance;
  String get balanceInEth =>
      _walletBalance != null ? _walletBalance!.getValueInUnit(EtherUnit.ether).toStringAsFixed(4) : '0';

  WalletViewModel(BuildContext context){

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
        // socials: [
        //   AppKitSocialOption.Google,
        //   AppKitSocialOption.Discord,
        //   AppKitSocialOption.Facebook,
        //   AppKitSocialOption.GitHub,
        //   AppKitSocialOption.X,
        //   AppKitSocialOption.Apple,
        //   AppKitSocialOption.Twitch,
        //   AppKitSocialOption.Farcaster,
        //
        // ],
        socials: AppKitSocialOption.values,
        showMainWallets: true,
      ),
    );


    _init();

  }

  Future<void> _init() async {

    await _appKitModal.init();
    _isConnected = _appKitModal.isConnected;

    // When connected, assume the wallet details are available via the wallet property.
    if (_isConnected && _appKitModal.wallet != null) {
      _walletAddress = _appKitModal.wallet!.address;
      _setupWeb3();
      await fetchBalance();
    }

    notifyListeners();
  }
  void _setupWeb3() {
    const rpcUrl = "https://polygon-rpc.com"; // Polygon RPC Endpoint.
    _web3client = Web3Client(rpcUrl, Client());
  }

  Future<void>selectNetwork()async{
    isNetworkSelecting = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 1));
    await _appKitModal.openNetworksView();
    isNetworkSelecting = false;
    notifyListeners();
   }

  void _fetchWalletInfo() async {
    wallet = WalletModel(userName: 'Rashadul Islam Himu', walletId: '0asdas23das0');
  }


  // Future<void> connectOrDisconnectWallet() async {
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   await Future.delayed(const Duration(seconds: 1));
  //   if (_appKitModal.isConnected) {
  //     await _appKitModal.disconnect();
  //   } else {
  //     await _appKitModal.openModalView();
  //   }
  //
  //   _isConnected = _appKitModal.isConnected;
  //   _walletAddress = _appKitModal.getAddress();
  //
  //   if (_walletAddress != null) {
  //     _setupWeb3();
  //     await fetchBalance();
  //   }
  //
  //   _isLoading = false;
  //   notifyListeners();
  // }

  Future<void> connectOrDisconnectWallet() async {
    _isLoading = true;
    notifyListeners();

    // If already connected, call disconnect
    if (_appKitModal.isConnected) {
      await _appKitModal.disconnect();
      _walletAddress = null;
      _isConnected = false;
      _walletBalance = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Otherwise open the connect modal.
    await _appKitModal.openModalView();

    // After the modal completes, update connection status.
    _isConnected = _appKitModal.isConnected;
    if (_isConnected && _appKitModal.wallet != null) {
      // Assuming the SDK now exposes the wallet details in a wallet property.
      _walletAddress = _appKitModal.wallet!.address;
      _setupWeb3();
      await fetchBalance();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> openNetworksView() async {
    await _appKitModal.openNetworksView();
  }

  void openWalletView() {
    _appKitModal.openModalView();
  }
  //
  // String? getWalletAddress() => _appKitModal.getAddress();
  //
  // String? getUserName() => _appKitModal.getUserName();

  Future<void> fetchBalance() async {
    if (_web3client != null && _walletAddress != null) {
      final address = EthereumAddress.fromHex(_walletAddress!);
      _walletBalance = await _web3client!.getBalance(address);
      notifyListeners();
    }
  }
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
}
 **/



import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class WalletViewModel extends ChangeNotifier {
  late ReownAppKitModal _appKitModal;
  Web3Client? _web3client;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  String? _userName;
  String? get userName => _userName;

  String? _walletId;
  String? get walletId => _walletId;

  EtherAmount? _walletBalance;
  String get balanceInEth => _walletBalance != null
      ? _walletBalance!.getValueInUnit(EtherUnit.ether).toStringAsFixed(4)
      : '0';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  WalletViewModel(BuildContext context) {
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
    _init();
  }

  /// Initialize the modal; if already connected, set wallet info and fetch balance.
  Future<void> _init() async {
    await _appKitModal.init();
    _isConnected = _appKitModal.isConnected;
    if (_isConnected) {
      _setWalletInfo();
      if (_walletId != null) {
        _setupWeb3();
        await fetchBalance();
      }
    }
    notifyListeners();
  }

  /// Connect the wallet using the ReownAppKitModal UI.
  Future<void> connectWallet() async {
    _isLoading = true;
    notifyListeners();
    if (!_appKitModal.isConnected) {
      // This will show the MetaMask permission dialog.
      await _appKitModal.openModalView();
      _isConnected = _appKitModal.isConnected;
      if (_isConnected) {
        _setWalletInfo();
        if (_walletId != null) {
          _setupWeb3();
          await fetchBalance();
        }
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
    _clearWalletInfo();
    _isLoading = false;
    notifyListeners();
  }

  /// Helper to extract wallet info from the modal.
  void _setWalletInfo() {
    // Assume that the connected wallet information is stored in selectedWallet.
    // 'listing.name' is used as the user name, and 'listing.id' as the wallet id.
    _userName = _appKitModal.selectedWallet?.listing.name;
    _walletId = _appKitModal.selectedWallet?.listing.id;
  }

  /// Clear wallet info on disconnect.
  void _clearWalletInfo() {
    _isConnected = false;
    _userName = null;
    _walletId = null;
    _walletBalance = null;
  }

  /// Set up the web3 client with the desired RPC URL.
  void _setupWeb3() {
    const rpcUrl = "https://polygon-rpc.com"; // Adjust for your target chain.
    _web3client = Web3Client(rpcUrl, http.Client());
  }

  /// Fetch the native balance for the connected wallet.
  Future<void> fetchBalance() async {
    if (_web3client != null && _walletId != null) {
      try {
        final address = EthereumAddress.fromHex(_walletId!);
        _walletBalance = await _web3client!.getBalance(address);
      } catch (e) {
        debugPrint("Error fetching balance: $e");
      }
      notifyListeners();
    }
  }

  /// Optional: Start a timer to refresh the balance periodically.
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
}
