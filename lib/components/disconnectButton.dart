import 'package:flutter/material.dart';

class DisconnectButton extends StatelessWidget {
  const DisconnectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: Border.all(color: const Color(0xFFEF5350), width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Disconnect',
            style: TextStyle(
              color: Color(0xFFEF5350),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Image.asset(
            'assets/disconnect_icon.png', // Replace with your actual asset path
            width: 20,
            height: 20,
            color: const Color(0xFFEF5350),
          ),
        ],
      ),
    );
  }
}
