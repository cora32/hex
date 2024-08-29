import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hex/hex_controller.dart';

class ModeSelector extends StatefulWidget {
  final HexController controller;

  const ModeSelector(this.controller, {super.key});

  @override
  State<ModeSelector> createState() => _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          for (var mode in Modes.values)
            Expanded(child: Btn(mode, widget.controller))
        ]);
  }
}

class Btn extends StatefulWidget {
  final HexController controller;
  final Modes mode;

  const Btn(this.mode, this.controller, {super.key});

  @override
  State<Btn> createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black))),
      child: Obx(() {
        final isSelected =
            widget.mode == widget.controller.modeSelectedLower.value;

        return Ink(
            color: isSelected ? Colors.amber : Colors.transparent,
            child: ListTile(
              tileColor: isSelected ? Colors.orange : Colors.black54,
              selected: isSelected,
              title: Text(widget.mode.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected ? Colors.black87 : Colors.white,
                  )),
              onTap: () {
                // setState(() {
                //   widget.controller.modeSelectedLower.value = widget.mode;
                // });
                // widget.onTap(encoder);
                widget.controller.setLowerMode(widget.mode);
              },
            ));
      }),
    );
  }
}

class HexMap extends StatefulWidget {
  final TextStyle style;
  final HexController controller;

  const HexMap(this.style, this.controller, {super.key});

  @override
  State<HexMap> createState() => _HexMapState();
}

class _HexMapState extends State<HexMap> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 600,
          color: Colors.black54,
          child: Obx(() => CustomPaint(
                  painter: HexMapPainter(
                widget.controller.textLower.value,
                widget.style,
              ))),
        ),
      ],
    );
  }
}

class HexMapPainter extends CustomPainter {
  final paint1 = Paint()..color = Colors.amber;
  final paint2 = Paint()..color = Colors.black54;
  final paintBorder = Paint()
    ..color = Colors.greenAccent
    ..strokeWidth = 0.4
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round;

  final String text;
  final TextStyle style;
  final blockHeight = 21.0;
  final topOffset = 8.0;
  final scrollbarWidth = 6.0;

  HexMapPainter(this.text, this.style);

  @override
  void paint(Canvas canvas, Size size) {
    final blockWidth = size.width / 10.0;
    final startOffset = (size.width - blockWidth * 8) / 2.0 - blockWidth / 2.0;

    print("HexMapPainter: $size; startOffset: $startOffset");

    var xOffset = 0.0;
    var line = 0;
    var column = 0;
    final units = text.characters;

    for (var i = 0; i < text.length; i++) {
      final code = units.elementAt(i);

      if (i > 0 && i % 8 == 0) {
        column = 0;
        line++;
      }

      xOffset = column > 3 ? blockWidth : 0.0;

      final left = column * blockWidth + startOffset + xOffset - scrollbarWidth;
      final top = line * blockHeight + line * topOffset;
      // final rect = Rect.fromLTWH(left, top, blockWidth, blockHeight);
      // canvas.drawRect(rect, paintBorder);
      canvas.drawLine(Offset(left + 6, top + blockHeight),
          Offset(left + blockWidth - 6, top + blockHeight), paintBorder);

      final textPainter = TextPainter(
          text: TextSpan(text: code.toString(), style: style),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr)
        ..layout(minWidth: blockWidth, maxWidth: blockWidth);

      textPainter.paint(canvas, Offset(left, top));

      column++;
    }
  }

  @override
  bool shouldRepaint(covariant HexMapPainter oldDelegate) {
    return false;
  }
}
