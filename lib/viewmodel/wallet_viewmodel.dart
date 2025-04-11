import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class WalletViewModel extends ChangeNotifier {

  // WalletViewModel(BuildContext context) {
  //   _appKitModal = ReownAppKitModal(
  //     context: context,
  //     projectId: 'f3d7c5a3be3446568bcc6bcc1fcc6389',
  //     metadata: const PairingMetadata(
  //       name: "Example App",
  //       description: "Example Description",
  //       url: 'https://example.com/',
  //       icons: ['https://example.com/logo.png'],
  //       redirect: Redirect(
  //         native: 'exampleapp',
  //         universal: 'https://reown.com/exampleapp',
  //         linkMode: true,
  //       ),
  //     ),
  //     logLevel: LogLevel.info,
  //     enableAnalytics: true,
  //     featuresConfig: FeaturesConfig(
  //       email: true,
  //       socials: [
  //         AppKitSocialOption.Google,
  //         AppKitSocialOption.Discord,
  //         AppKitSocialOption.Facebook,
  //         AppKitSocialOption.GitHub,
  //         AppKitSocialOption.X,
  //         AppKitSocialOption.Apple,
  //         AppKitSocialOption.Twitch,
  //         AppKitSocialOption.Farcaster,
  //       ],
  //       showMainWallets: true,
  //     ),
  //   );
  //   _init();
  // }


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
      ? _walletBalance!.getValueInUnit(EtherUnit.ether).toStringAsFixed(5)
      : '0';

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  String? _networkName;
  String? get networkName => _networkName;

  String? _chainId;
  String? get chainId => _chainId;


  String? _blockchainIdentity;
  String? get  blockchainIdentity => _blockchainIdentity;

  Future<void> init(BuildContext context) async {
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
    const rpcUrl = "https://polygon-rpc.com"; // target chain.
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


}
