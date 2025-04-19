import 'package:flutter/material.dart';
import 'package:reown_appkit_wallet_flutter/components/customInputField.dart';
import 'package:reown_appkit_wallet_flutter/components/custonButton.dart';

import '../components/AddressFieldComponent.dart';
import '../components/buy_ecm_button.dart';
import '../components/disconnectButton.dart';
import '../components/loader.dart';



class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final usdtController = TextEditingController();
  final ecmController = TextEditingController();
  final readingMoreController = TextEditingController();

  bool isETHActive = true;
  bool isUSDTActive = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor:Color(0xFF0A1C2F),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Demo UI',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children:[ Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Color(0x4d03080e),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              // end: Alignment.bottomRight,
              //   begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              colors: [
                Color(0xFF0A1C2F),
                Color(0xFF060D13),
              ],
            ),

          ),
        
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipPath(
                    clipper: _DemoPainter(),
                    child: Container(
                      width: screenWidth * 0.92,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                         color: const Color(0x4D03080E), // semi-transparent
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                const SizedBox(height: 1),

                                ECMProgressIndicator(currentECM: 82287.4990, maxECM: 200000.0),

                                const Divider(
                                  color: Colors.white12,
                                  thickness: 2,
                                  height: 20,
                                ),
                                const SizedBox(height: 1),

                                CustomLabeledInputField(
                                  labelText: 'Your Address:',
                                  hintText: 'Show Address ...',
                                  controller: readingMoreController,
                                  isReadOnly: true, // or false
                                ),
                                const SizedBox(height: 1),

                                CustomLabeledInputField(
                                  labelText: 'Referred By:',
                                  hintText: 'Show and Enter Referred id..',
                                  controller: readingMoreController,
                                  isReadOnly: false, // or false
                                ),


                                const SizedBox(height: 3),

                                const Divider(
                                  color: Colors.white12,
                                  thickness: 2,
                                  height: 20,
                                ),
                                const SizedBox(height: 3),

                                Text(
                                  'ICO is Live',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Oxanium',
                                    height: 1.07,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomButton(
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
                                    ),
                                    const SizedBox(width: 10), // Space between the buttons
                                    Expanded(
                                      child: CustomButton(
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
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  isETHActive ? "1 ECM = 0.00073 ETH" : "1 ECM = 1.2 USDT",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,

                                  ),
                                ),
                                const SizedBox(height: 20),

                                CustomInputField(
                                  hintText: 'ECM Amount',
                                  iconAssetPath: 'assets/icons/ecm.png',
                                  controller: ecmController,
                                ),
                                const SizedBox(height: 10),
                                CustomInputField(
                                  hintText: isETHActive ? 'ETH Payable' : 'USDT Payable',
                                  iconAssetPath:
                                  isETHActive ? 'assets/icons/eth.png' : 'assets/icons/usdt.png',
                                  controller: usdtController,
                                ),

                                const SizedBox(height: 14),
                                CustomGradientButton(
                                  label: 'Buy ECM',
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: 40,
                                  onTap: () {
                                    print("ECM Purchase triggered");
                                  },
                                  gradientColors: [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
                                ),
                                const SizedBox(height: 14),
                                DisconnectButton(
                                  label: 'Disconnect',
                                  color: Colors.redAccent,
                                  icon: Icons.visibility_off_rounded,
                                  onPressed: () {
                                    print('Disconnect Button Clicked ');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),]
      ),
    );
  }
}



// class _DemoPainter extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final Path path = Path();
//     const double notchWidth = 30;
//     const double notchHeight = 6;
//     const double cutSize = 20;
//
//     const double topNotchOffset = 50;
//     const double bottomNotchOffset = -50;
//
//     // Start at top-left (no cut here)
//     path.moveTo(-1, -1);
//
//     // Move to just before the top-right cut corner
//     path.lineTo(size.width - cutSize, 0);
//
//     // Top-right corner cut
//     path.lineTo(size.width, cutSize);
//
//     // Right edge down
//     path.lineTo(size.width, size.height);
//
//     // Bottom-right (no cut here)
//     path.lineTo(size.width, size.height);
//
//     // Bottom notch (slightly left of center)
//     double bottomNotchCenter = (size.width / 2) + bottomNotchOffset;
//     path.lineTo(bottomNotchCenter + (notchWidth / 2), size.height);
//     path.lineTo(bottomNotchCenter + (notchWidth / 2), size.height - notchHeight);
//     path.lineTo(bottomNotchCenter - (notchWidth / 2), size.height - notchHeight);
//     path.lineTo(bottomNotchCenter - (notchWidth / 2), size.height);
//
//     // Move to bottom-left cut corner
//     path.lineTo(cutSize, size.height);
//     path.lineTo(0, size.height - cutSize);
//
//     // Left edge up
//     path.lineTo(0, 0);
//
//     // Top notch (slightly right of center)
//     double topNotchCenter = (size.width / 2) + topNotchOffset;
//     path.moveTo(topNotchCenter - (notchWidth / 2), 0);
//     path.lineTo(topNotchCenter - (notchWidth / 2), notchHeight);
//     path.lineTo(topNotchCenter + (notchWidth / 2), notchHeight);
//     path.lineTo(topNotchCenter + (notchWidth / 2), 0);
//
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
class _DemoPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    const double notchWidth = 30;
    const double notchHeight = 10;
    const double cutSize = 20;

    const double topNotchOffset = 20;
    const double bottomNotchOffset = 120;

    // Start at top-left (sharp corner, no rounded cut)
    path.moveTo(0, 0);

    // Move to just before the top-right cut corner
    path.lineTo(size.width - cutSize, 0);

    // Top-right corner cu-
    path.lineTo(size.width, cutSize);

    // Right edge down
    path.lineTo(size.width, size.height, );

    // Bottom-right (sharp corner)
    path.lineTo(size.width, size.height);

    // Bottom notch (slightly left of center)
    double bottomNotchCenter = (size.width / 2) + bottomNotchOffset;
    path.lineTo(bottomNotchCenter + (notchWidth / 2), size.height);
    path.lineTo(bottomNotchCenter + (notchWidth / 2), size.height - notchHeight);
    path.lineTo(bottomNotchCenter - (notchWidth / 2), size.height - notchHeight);
    path.lineTo(bottomNotchCenter - (notchWidth / 2), size.height);

    // Move to bottom-left cut corner
    path.lineTo(cutSize, size.height);
    path.lineTo(0, size.height - cutSize);

    // Left edge up (sharp corner)
    path.lineTo(0, 0);

    // Top notch (slightly right of center)
    double topNotchCenter = (size.width / 2) + topNotchOffset;
    path.moveTo(topNotchCenter - (notchWidth / 2), 0);
    path.lineTo(topNotchCenter - (notchWidth / 2), notchHeight);
    path.lineTo(topNotchCenter + (notchWidth / 2), notchHeight);
    path.lineTo(topNotchCenter + (notchWidth / 2), 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
