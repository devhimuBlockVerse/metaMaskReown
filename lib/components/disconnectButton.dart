import 'package:flutter/material.dart';

class DisconnectButton extends StatelessWidget {
  const DisconnectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: DisconnectButtonClipper(),
      child: Container(
        width: 320,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.redAccent, width: 1.8),
        ),
        child: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Disconnect',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.volume_off, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class DisconnectButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double notch = 10;
    const double edge = 15;

    final path = Path();

    // Start top-left
    path.moveTo(edge, 0);
    path.lineTo(size.width - edge, 0);
    path.lineTo(size.width, notch);
    path.lineTo(size.width, size.height - notch);
    path.lineTo(size.width - edge, size.height);

    // Center notch
    path.lineTo(size.width * 0.55, size.height);
    path.lineTo(size.width * 0.53, size.height - notch);
    path.lineTo(size.width * 0.47, size.height - notch);
    path.lineTo(size.width * 0.45, size.height);

    path.lineTo(edge, size.height);
    path.lineTo(0, size.height - notch);
    path.lineTo(0, notch);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
