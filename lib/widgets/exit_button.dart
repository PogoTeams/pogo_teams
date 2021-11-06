import 'package:flutter/material.dart';
import '../configs/size_config.dart';

class ExitButton extends StatelessWidget {
  const ExitButton({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Block size from MediaQuery
    final double blockSize = SizeConfig.blockSizeHorizontal;
    return Container(
      height: blockSize * 10.0,
      width: blockSize * 10.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: blockSize * .7,
        ),
        shape: BoxShape.circle,
      ),
      child: FloatingActionButton(
        child: Icon(
          Icons.close,
          size: SizeConfig.blockSizeHorizontal * 7.5,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,

        // Callback
        onPressed: onPressed,
      ),
    );
  }
}
