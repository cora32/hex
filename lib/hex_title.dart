import 'package:Hex/strings.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class HexTitle extends StatelessWidget {
  const HexTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return DragToMoveArea(
      child: Container(
        decoration: const BoxDecoration(color: Colors.brown),
        height: 40,
        child: Stack(
          children: [
            const Center(
              child: Text(Strings.name),
            ),
            Positioned.fill(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: CloseButton(
                      onPressed: () {
                        WindowManager.instance.close();
                      },
                    )))
          ],
        ),
      ),
    );
  }
}
