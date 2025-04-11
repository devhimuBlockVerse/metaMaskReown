import 'package:flutter/material.dart';
import 'package:reown_appkit/appkit_modal.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:reown_appkit_wallet_flutter/model/wallet_model.dart';

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
    if (isConnected) {
      _fetchWalletInfo();
    }
    notifyListeners();
  }


  Future<void>selectNetwork()async{
    isNetworkSelecting = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 1));
    await _appKitModal.openNetworksView();
    isNetworkSelecting = false;
    notifyListeners();
   }

   // Future<void> toggleConnection() async {
   //  isLoading = true;
   //  notifyListeners();
   //  await Future.delayed(Duration(seconds: 1));
   //  if (isConnected) {
   //    await _appKitModal.disconnect();
   // }else{
   //    await _appKitModal.openModalView();
   //  }
   //  isConnected = _appKitModal.isConnected;
   //  if (isConnected) {
   //    _fetchWalletInfo();
   //  }
   //  isLoading = false;
   //  notifyListeners();
   //  }


    void _fetchWalletInfo() async {
    wallet = WalletModel(userName: 'Rashadul Islam Himu', walletId: '0asdas23das0');
  }


  Future<void> connectOrDisconnectWallet() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Optional loading delay
    if (_appKitModal.isConnected) {
      await _appKitModal.disconnect();
    } else {
      await _appKitModal.openModalView();
    }

    _isConnected = _appKitModal.isConnected;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> openNetworksView() async {
    await _appKitModal.openNetworksView();
  }

  void openWalletView() {
    _appKitModal.openModalView();
  }

  String? getWalletAddress() => _appKitModal.getAddress();

  String? getUserName() => _appKitModal.getUserName();

}