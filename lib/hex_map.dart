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
            Btn(mode, widget.controller, widget.modeSelected, widget.onTap)
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
        height: 40,
        width: 69,
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black))),
        child: Ink(
            color: isSelected ? Colors.orange : Colors.orange,
            child: Container(
              color: isSelected ? Colors.amber : Colors.blueGrey,
              child: ListTile(
                selectedColor: Colors.orange,
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
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
  final TextStyle styleLine;
  final String text;
  final Modes selectedMode;
  final Function(int start, int length) onRegionSelected;

  const HexMap(this.style, this.styleLine, this.text, this.onRegionSelected,
      this.selectedMode,
      {super.key});

  @override
  State<HexMap> createState() => _HexMapState();
}

class _HexMapState extends State<HexMap> {
  final blockHeight = 21.0;

  @override
  Widget build(BuildContext context) {
    final len = widget.text.length;
    final height = (blockHeight + 8) * (len / 8).ceil();

    return IntrinsicHeight(
        child: Stack(
      fit: StackFit.expand,
      children: [
        SizedBox(
          height: height,
          child: RepaintBoundary(
            child: CustomPaint(
                painter: HexMapPainter(
                    widget.text, widget.style, widget.styleLine,
                    blockHeight: blockHeight)),
          ),
        ),
        SizedBox(
            height: height,
            child: HoveringOverlay(widget.text, blockHeight,
                widget.selectedMode, widget.onRegionSelected))
      ],
    ));
  }
}

class HexMapPainter extends CustomPainter {
  // final paint1 = Paint()..color = Colors.amber;
  // final paint2 = Paint()..color = Colors.black54;
  // final paintBorder = Paint()
  //   ..color = Colors.transparent
  //   ..strokeWidth = 0.4
  //   ..style = PaintingStyle.fill
  //   ..isAntiAlias = true
  //   ..strokeCap = StrokeCap.round;

  final String text;
  final TextStyle style;
  final TextStyle styleLine;
  final topOffset = 8.0;
  final scrollbarWidth = 4.0;
  final double blockHeight;

  HexMapPainter(this.text, this.style, this.styleLine,
      {required this.blockHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final blockWidth = size.width / 12.0;
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
    if (paddingCount > 0) {
      newText += Iterable.generate(paddingCount, (i) => ".").join();
    }

    var drawLine = true;
    for (var i = 0; i < newText.length; i++) {
      final code = newText[i];

      if (i > 0 && i % 8 == 0) {
        column = 0;
        line++;
        drawLine = true;
      }

      xOffset = column > 3 ? blockWidth : 0.0;

      if (drawLine) {
        drawLine = false;
        drawLineNumber(canvas, line, styleLine);
      }

      drawSymbol(canvas, column, line, blockWidth, startOffset, xOffset, code);

      column++;
    }
  }

  @override
  bool shouldRepaint(covariant HexMapPainter oldDelegate) {
    return text != oldDelegate.text;
  }

  void drawLineNumber(Canvas canvas, int line, TextStyle styleLine) {
    final textPainter = TextPainter(
        text: TextSpan(text: line.toString(), style: styleLine),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 20, maxWidth: 20);

    final top = line * blockHeight + line * topOffset;

    textPainter.paint(canvas, Offset(2, top));
  }

  void drawSymbol(Canvas canvas, int column, int line, double blockWidth,
      double startOffset, double xOffset, String code) {
    final left = column * blockWidth + startOffset + xOffset - scrollbarWidth;
    final top = line * blockHeight + line * topOffset;
    // final rect = Rect.fromLTWH(left, top, blockWidth, blockHeight);
    // canvas.drawRect(rect, paintBorder);
    // canvas.drawLine(Offset(left + 6, top + blockHeight),
    //     Offset(left + blockWidth - 6, top + blockHeight), paintBorder);

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

class HoveringOverlay extends StatefulWidget {
  final String text;
  final double blockHeight;
  final Modes selectedMode;
  final Function(int, int) onRegionSelected;

  const HoveringOverlay(
      this.text, this.blockHeight, this.selectedMode, this.onRegionSelected,
      {super.key});

  @override
  State<HoveringOverlay> createState() => _HoveringOverlayState();
}

class _HoveringOverlayState extends State<HoveringOverlay> {
  var x = 0.0;
  var y = 0.0;
  var tapX = 0.0;
  var tapY = 0.0;
  var isHovering = false;
  var isTap = false;
  var updaterValue = false;
  var oldLeft = -1.0;
  var oldTopTap = -1.0;

  onExit(PointerEvent details) {
    setState(() {
      isHovering = false;
    });
  }

  onHover(PointerEvent details) {
    setState(() {
      isTap = false;
      isHovering = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;
    });
  }

  onTap(TapDownDetails details) {
    setState(() {
      isTap = true;
      updaterValue = !updaterValue;
      tapX = details.localPosition.dx;
      tapY = details.localPosition.dy;
    });
  }

  onSavePreviousState(double left, double topTap) {
    oldLeft = left;
    oldTopTap = topTap;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: onTap,
        child: MouseRegion(
            onExit: onExit,
            onHover: onHover,
            child: RepaintBoundary(
                child: CustomPaint(
                    painter: OverlayPainter(widget.text, x, y, tapX, tapY,
                        isHovering,
                        isTap,
                        updaterValue,
                        oldLeft,
                        oldTopTap,
                        widget.selectedMode,
                        onSavePreviousState,
                        widget.onRegionSelected,
                        blockHeight: widget.blockHeight)))));
  }
}

class OverlayPainter extends CustomPainter {
  static final paintLine = Paint()
    ..color = const Color.fromARGB(85, 255, 66, 66)
    ..strokeWidth = 0.4
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round;
  static final paintBlock = Paint()
    ..color = const Color.fromARGB(127, 78, 255, 28)
    ..strokeWidth = 2.5
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round;
  final topOffset = 8.0;
  final scrollbarWidth = 6.0;
  final String text;
  final double blockHeight;
  final double x;
  final double y;
  final double tapX;
  final double tapY;
  final double oldLeft;
  final double oldTopTap;
  final Modes selectedMode;
  final bool isHovering;
  final bool isTap;
  final bool updaterValue;
  final Function(
    double,
    double,
  ) onSavePreviousState;
  final Function(
    int,
    int,
  ) onRegionSelected;

  OverlayPainter(
    this.text,
    this.x,
    this.y,
    this.tapX,
    this.tapY,
    this.isHovering,
    this.isTap,
    this.updaterValue,
    this.oldLeft,
    this.oldTopTap,
    this.selectedMode,
    this.onSavePreviousState,
    this.onRegionSelected, {
    required this.blockHeight,
  });

  var previousTapRect = Rect.zero;

  @override
  void paint(Canvas canvas, Size size) {
    final blockWidth = size.width / 12.0;

    if (isHovering) {
      drawLine(canvas, size.width);
    }

    if (isTap) {
      drawBlock(canvas, blockWidth, size.width, selectedMode);
    } else if (oldLeft > 0.0 && oldTopTap >= 0.0) {
      canvas.drawRect(
          Rect.fromLTWH(oldLeft, oldTopTap, blockWidth * selectedMode.byteCount,
              blockHeight),
          paintBlock);
    }
  }

  void drawLine(Canvas canvas, double width) {
    var line = (y / (blockHeight + topOffset)).toInt();
    final top = line * blockHeight + line * topOffset;

    canvas.drawRect(Rect.fromLTWH(0, top, width, blockHeight), paintLine);
  }

  @override
  bool shouldRepaint(covariant OverlayPainter oldDelegate) {
    return y != oldDelegate.y ||
        tapY != oldDelegate.tapY ||
        updaterValue != oldDelegate.updaterValue;
  }

  void drawBlock(
      Canvas canvas, double blockWidth, double width, Modes selectedMode) {
    final lineTap = (tapY / (blockHeight + topOffset)).toInt();
    final topTap = lineTap * blockHeight + lineTap * topOffset;
    final startOffset = (width - blockWidth * 8) / 2.0 - blockWidth / 2.0;
    final moreThenHalf = tapX > width / 2.0;
    var column =
        ((tapX + (moreThenHalf ? -blockWidth * 2 : -blockWidth)) / blockWidth)
            .toInt();

    if (column % selectedMode.byteCount == 1) column--;

    final xOffset = column > 3 ? blockWidth : 0.0;
    final left = column * blockWidth + startOffset + xOffset - scrollbarWidth;

    if (left == oldLeft && topTap == oldTopTap) {
      onSavePreviousState(-1.0, -1.0);
      onRegionSelected(-1, -1);
    } else if (left > 0.0 && topTap >= 0.0 && column < 8) {
      final textPosition = (lineTap) * 8 + column;
      print("textPosition: $textPosition");
      onRegionSelected(
          textPosition ~/ selectedMode.byteCount, selectedMode.byteCount);
      canvas.drawRect(
          Rect.fromLTWH(
              left, topTap, blockWidth * selectedMode.byteCount, blockHeight),
          paintBlock);

      onSavePreviousState(left, topTap);
    }
  }
}
