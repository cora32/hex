import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'strings.dart';

class HexTitle extends StatelessWidget {
  const HexTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return DragToMoveArea(
      child: Container(
        decoration: const BoxDecoration(color: Colors.amber),
        height: 40,
        child: Stack(
          children: [
            const Center(
              child: Text(
                Strings.name,
                style: TextStyle(color: Colors.black87),
              ),
            ),
            Positioned.fill(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: CloseButton(
                      color: Colors.black87,
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
