import 'package:flutter/material.dart';
import 'package:hex/hex_controller.dart';

class ModeSelector extends StatefulWidget {
  final Modes modeSelected;
  final HexController controller;
  final Function(Modes) onTap;

  const ModeSelector(this.modeSelected, this.controller, this.onTap,
      {super.key});

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
            Expanded(
                child: Btn(
                    mode, widget.controller, widget.modeSelected, widget.onTap))
        ]);
  }
}

class Btn extends StatefulWidget {
  final HexController controller;
  final Modes mode;
  final Modes modeSelected;
  final Function(Modes) onTap;

  const Btn(this.mode, this.controller, this.modeSelected, this.onTap,
      {super.key});

  @override
  State<Btn> createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.mode == widget.modeSelected;

    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black))),
        child: Ink(
            color: isSelected ? Colors.orange : Colors.orange,
            child: Container(
              color: isSelected ? Colors.orange : Colors.deepOrangeAccent,
              child: ListTile(
                selectedColor: Colors.orange,
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
                contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                // tileColor: isSelected ? Colors.orange : Colors.black54,
                selected: isSelected,
                style: ListTileStyle.list,
                title: Text(widget.mode.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.black87 : Colors.black,
                    )),
                onTap: () {
                  widget.onTap(widget.mode);
                },
              ),
            )));
  }
}

class HexMap extends StatefulWidget {
  final TextStyle style;
  final String text;

  const HexMap(this.style, this.text, {super.key});

  @override
  State<HexMap> createState() => _HexMapState();
}

class _HexMapState extends State<HexMap> {
  final blockHeight = 21.0;

  @override
  Widget build(BuildContext context) {
    final len = widget.text.length;
    final height = (blockHeight + 8) * (len / 8).ceil();

    return SizedBox(
        height: height,
        child: CustomPaint(
            painter: HexMapPainter(widget.text, widget.style,
                blockHeight: blockHeight)));
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
  final topOffset = 8.0;
  final scrollbarWidth = 6.0;
  final double blockHeight;

  HexMapPainter(this.text, this.style, {required this.blockHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final blockWidth = size.width / 10.0;
    final startOffset = (size.width - blockWidth * 8) / 2.0 - blockWidth / 2.0;

    print("HexMapPainter: $size; text: $text");

    var xOffset = 0.0;
    var line = 0;
    var column = 0;
    // var encoded = utf8.encode(text.toString());
    // var decoded = utf8.decode(text.codeUnits, allowMalformed: true);
    // final units = text.codeUnits;

    // Padding text
    var newText = text;
    final paddingCount = 80 - text.length;
    if (paddingCount > 0)
      newText += Iterable.generate(paddingCount, (i) => ".").join();

    for (var i = 0; i < newText.length; i++) {
      final code = newText[i];

      if (i > 0 && i % 8 == 0) {
        column = 0;
        line++;
      }

      xOffset = column > 3 ? blockWidth : 0.0;

      drawSymbol(canvas, column, line, blockWidth, startOffset, xOffset, code);

      column++;
    }

    // Padding
    // final padCount = 80 - text.length;
    // if (padCount > 0) {
    //   for (var i = 0; i < padCount; i++) {
    //     if (i > 0 && i % 8 == 0) {
    //       column = 0;
    //       line++;
    //     }
    //
    //     xOffset = column > 3 ? blockWidth : 0.0;
    //
    //     drawSymbol(canvas, column, line, blockWidth, startOffset,
    //         xOffset,
    //         ".");
    //
    //     column++;
    //   }
    // }
  }

  @override
  bool shouldRepaint(covariant HexMapPainter oldDelegate) {
    return text != oldDelegate.text;
  }

  void drawSymbol(Canvas canvas, int column, int line, double blockWidth,
      double startOffset, double xOffset, String code) {
    final left = column * blockWidth + startOffset + xOffset - scrollbarWidth;
    final top = line * blockHeight + line * topOffset;
    // final rect = Rect.fromLTWH(left, top, blockWidth, blockHeight);
    // canvas.drawRect(rect, paintBorder);
    canvas.drawLine(Offset(left + 6, top + blockHeight),
        Offset(left + blockWidth - 6, top + blockHeight), paintBorder);

    // print('units: $units; text: $text');
    // print('encoded: $encoded;');
    // print('decoded: $decoded; code: $code');

    final textPainter = TextPainter(
        text: TextSpan(text: code, style: style),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: blockWidth, maxWidth: blockWidth);

    textPainter.paint(canvas, Offset(left, top));
  }
}
