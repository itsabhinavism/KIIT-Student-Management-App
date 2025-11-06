import 'package:flutter/material.dart';

/// Reusable KIIT logo widget for AppBar actions
class KiitLogoWidget extends StatelessWidget {
  final double height;
  
  const KiitLogoWidget({
    super.key,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        'assets/KIIT.png',
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
