import 'package:flutter/material.dart';
import 'package:reown_appkit/modal/appkit_modal_impl.dart';
import 'package:flutter/material.dart';


class ReownAppKitButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback ?onPressed;
  final Color? color;

  const ReownAppKitButton({
    super.key,
    required this.label,
    required this.icon,
     this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: color != null
                ? [color!.withOpacity(0.9), color!]
                : isDark
                ? [const Color(0xFF1F1C2C), const Color(0xFF928DAB)]
                : [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.blueAccent.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
