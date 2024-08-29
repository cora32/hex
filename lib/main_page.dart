import 'package:flutter/material.dart';

import 'hex_controller.dart';
import 'hex_map.dart';
import 'selector.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = HexController();
  final ctrl1 = TextEditingController();
  final ctrl2 = TextEditingController();
  final ctrl3 = TextEditingController();
  final ctrl4 = TextEditingController();

  @override
  void dispose() {
    ctrl1.dispose();
    ctrl2.dispose();
    ctrl3.dispose();
    ctrl4.dispose();

    super.dispose();
  }

  void encode(String val) {
    ctrl2.text = controller.encode(val);
  }

  void decode(String val) {
    ctrl1.text = controller.decode(val);
  }

  Widget getSelector() => SizedBox(
      width: 200,
      child: Selector(
          items: controller.encoders,
          onTap: (Encoders val) {
            print('Selected encoder: $val');
            controller.selectedEncoder = val;
            decode(ctrl2.text);
          }));

  Widget getFields() => Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white10),
              child: HexTextField(ctrl1, encode),
            ),
          ),
          const Divider(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: HexTextField(ctrl2, decode)),
                  ModeBlock(controller)
                ],
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          getSelector(),
          const VerticalDivider(),
          Expanded(child: getFields())
        ],
      ),
    );
  }
}

class HexTextField extends StatefulWidget {
  final TextEditingController ctrl;
  final void Function(String val) onChanged;

  const HexTextField(this.ctrl, this.onChanged, {super.key});

  @override
  State<HexTextField> createState() => _HexTextFieldState();
}

class _HexTextFieldState extends State<HexTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.ctrl,
      onChanged: widget.onChanged,
      maxLines: 999,
      decoration: const InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white12,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16)),
    );
  }
}

class ModeBlock extends StatefulWidget {
  final HexController controller;

  const ModeBlock(this.controller, {super.key});

  @override
  State<ModeBlock> createState() => _ModeBlockState();
}

class _ModeBlockState extends State<ModeBlock> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ModeSelector(widget.controller),
        Container(
          height: 8,
          color: Colors.black54,
        ),
        Expanded(
          child: Container(
            width: 300,
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: SizedBox(
                  width: 300,
                  child: HexMap(
                      const TextStyle(
                        color: Colors.orangeAccent,
                        // decoration: TextDecoration.underline,
                      ),
                      widget.controller),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
