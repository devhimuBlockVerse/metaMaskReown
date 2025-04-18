import 'package:flutter/material.dart';
import 'package:reown_appkit_wallet_flutter/components/customInputField.dart';
import 'package:reown_appkit_wallet_flutter/components/custonButton.dart';

import '../components/buy_ecm_button.dart';
import '../components/disconnectButton.dart';


class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {

  final usdtController = TextEditingController();
  final ecmController = TextEditingController();

  bool isETHActive = true;
  bool isUSDTActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Demo UI',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),

        child: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [

                    CustomInputField(
                      hintText: 'ECM Amount',
                      iconAssetPath: 'assets/icons/ecm.png',
                      controller: ecmController,
                    ),

                    const SizedBox(height: 10),

                    CustomInputField(
                      hintText: 'USDT Payable',
                      iconAssetPath: 'assets/icons/usdt.png',
                      controller: usdtController,
                    ),

                    CustomButton(
                      text: 'Buy with ETH',
                      icon: 'assets/icons/eth.png',
                      isActive: isETHActive,

                      onPressed: () {
                        setState(() {
                          isETHActive = true;
                          isUSDTActive = false;
                        });
                       },
                    ),

                    const SizedBox(height: 10),

                    CustomButton(

                      text: 'Buy with USDT',
                      icon: 'assets/icons/usdt.png',
                      isActive: isUSDTActive,
                      onPressed: () {
                        setState(() {
                          isETHActive = false;
                          isUSDTActive = true;
                        });
                      },
                    ),


                    BuyEcmButton(),
                    const SizedBox(height: 10),

                    DisconnectButton(),
                  ],
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}
