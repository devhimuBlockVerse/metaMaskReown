import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final String iconAssetPath;
  final TextEditingController controller;

  const CustomInputField(
      {super.key,
      required this.iconAssetPath,
      required this.hintText,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CustomBorderPainter(),
      child: Padding(
        padding: const EdgeInsets.all(1.5), // to match the border thickness
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.asset(
                iconAssetPath,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  cursorColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),    );
  }
}

class _CustomBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.tealAccent
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path = Path();

    const double notch = 5.0;
    const double inset = 38.0;
    const double edge = 6.0;




    path.moveTo(12, 0);
    path.lineTo(size.width - 18, 0);
    path.lineTo(size.width - 0,  0);
    path.lineTo(size.width, 10);
    path.lineTo(size.width, size.height - 10);
    path.lineTo(size.width - 15, size.height);
    path.lineTo(18, size.height);
    path.lineTo(0, size.height);

    path.lineTo(0, size.height - 10);
    path.lineTo(0, 12);
    path.lineTo(12, 0);
    path.close();


    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
