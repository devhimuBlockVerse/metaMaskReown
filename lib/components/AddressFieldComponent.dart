import 'package:flutter/material.dart';




class CustomLabeledInputField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final bool isReadOnly;

  const CustomLabeledInputField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;
    final safePadding = MediaQuery.of(context).padding; // Safe area padding (handles notch)

    final baseFontSize = screenWidth < screenHeight ? screenWidth * 0.03 : screenHeight * 0.04;

    final fontSize = baseFontSize * textScale;

    return ClipPath(
      clipper: _CustomAddressPainter(safePadding),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.050,
          ),
          color: Colors.white12,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
                ).createShader(bounds),
                child: Text(
                  labelText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: TextFormField(
                  readOnly: isReadOnly,
                  controller: controller,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontSize: fontSize * 0.95,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                    ),
                  ),
                  cursorColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _CustomAddressPainter extends CustomClipper<Path> {
  final EdgeInsets safePadding;
  _CustomAddressPainter(this.safePadding);

  @override
  Path getClip(Size size) {
    final Path path = Path();
    const double notchWidth = 30;
    const double notchHeight = 6;
    const double cutSize = 20;

    // Offset amounts
    const double topNotchOffset = 50; // move right
    const double bottomNotchOffset = -50; // move left

    // Top-left angled start
    path.moveTo(cutSize, 0);

    // Top notch (slightly right of center)
    double topNotchCenter = (size.width / 2) + topNotchOffset;
    path.lineTo(topNotchCenter - (notchWidth / 2), 0);
    path.lineTo(topNotchCenter - (notchWidth / 2), notchHeight);
    path.lineTo(topNotchCenter + (notchWidth / 2), notchHeight);
    path.lineTo(topNotchCenter + (notchWidth / 2), 0);

    // Top-right corner (no cut)

    path.lineTo(size.width, 0);

    // Right side down
    path.lineTo(size.width, size.height - cutSize);

    // Bottom-right corner with cut
    path.lineTo(size.width - cutSize, size.height);

    // Bottom notch (slightly left of center)
    double bottomNotchCenter = (size.width / 2) + bottomNotchOffset;
    path.lineTo(bottomNotchCenter + (notchWidth / 2), size.height);
    path.lineTo(bottomNotchCenter + (notchWidth / 2), size.height - notchHeight);
    path.lineTo(bottomNotchCenter - (notchWidth / 2), size.height - notchHeight);
    path.lineTo(bottomNotchCenter - (notchWidth / 2), size.height);

    // Bottom-left corner (no cut)
    path.lineTo(0, size.height);

    // Left side up to top-left (cut)
    path.lineTo(0, cutSize);
    path.lineTo(cutSize, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
