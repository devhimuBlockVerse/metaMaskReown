import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final String? icon;
  final bool isActive;
  final double? width;
  final VoidCallback? onPressed;

  const CustomButton({super.key, required this.text, this.icon, required this.isActive, this.onPressed, this.width});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenWidth * 0.024,
        ),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
            colors: [Color(0xFF277BF5), Color(0xFF1CD691)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
              : const LinearGradient(
            colors: [Color(0xFF1B212B), Color(0xFF1B212B)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
          border: isActive
              ? null
              : Border.all(color: const Color(0xFF1FB9B1C9), width: 1),
        ),
        child: Row(
           mainAxisSize: width == null ? MainAxisSize.min : MainAxisSize.max,
          children: [
            if (icon != null) ...[
              Image.asset(
                icon!,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style:  TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.045, // responsive font
                fontWeight: FontWeight.w600,
              ),
            ),
             const Spacer(flex: 1,),
             if (isActive) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 22,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
