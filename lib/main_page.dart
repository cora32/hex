import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hex/strings.dart';

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
  final ctrlEncoded = TextEditingController();
  final ctrlDecoded = TextEditingController();
  final ctrlUpperMap = TextEditingController();
  final ctrlLowerMap = TextEditingController();

  @override
  void dispose() {
    ctrlEncoded.dispose();
    ctrlDecoded.dispose();
    ctrlUpperMap.dispose();
    ctrlLowerMap.dispose();

    super.dispose();
  }

  Future<void> onChangedEncoded(String val) async {
    ctrlDecoded.text = val;
  }

  Future<void> onChangedDecoded(String val) async {
    ctrlEncoded.text = await controller.encode(val);
  }

  void onCopyUp() async {
    ctrlEncoded.text = ctrlDecoded.text;
    onDecodePressed();
  }

  void onDecodePressed() async {
    ctrlDecoded.text = await controller.decode(ctrlEncoded.text);
  }

  void onEncodePressed() async {
    ctrlDecoded.text = await controller.encode(ctrlEncoded.text);
  }

  Widget getSelector() => SizedBox(
      width: 200,
      child: Selector(
          items: controller.encoders,
          onTap: (Encoders val) {
            print('Selected encoder: $val');
            controller.setEncoder(val);

            ctrlDecoded.text = controller.textDecoded.value;
          }));

  Widget getFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: HexTextField(ctrlEncoded, onChangedEncoded),
                  ),
                  Obx(() => ModeBlock(
                      controller,
                      controller.setUpperMode,
                      controller.encodedMap.value,
                      controller.modeSelectedEncoded.value))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: MiddleDivider(onEncodePressed, onDecodePressed, onCopyUp),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: HexTextField(ctrlDecoded, onChangedDecoded)),
                  Obx(() => ModeBlock(
                      controller,
                      controller.setLowerMode,
                      controller.decodedMap.value,
                      controller.modeSelectedDecoded.value))
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
      onEditingComplete: () {
        widget.onChanged(widget.ctrl.text);
      },
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
  final Function(Modes) onTap;
  final String text;
  final Modes selectedMode;

  const ModeBlock(this.controller, this.onTap, this.text, this.selectedMode,
      {super.key});

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
    return Container(
        width: 300,
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ModeSelector(widget.selectedMode, widget.controller, widget.onTap),
            Container(
              height: 8,
              color: Colors.black54,
            ),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
                    color: Colors.black,
                    child: HexMap(
                      const TextStyle(
                        color: Colors.orangeAccent,
                        // decoration: TextDecoration.underline,
                      ),
                      widget.text,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class MiddleDivider extends StatefulWidget {
  final VoidCallback onEncode;
  final VoidCallback onDecode;
  final VoidCallback onCopyUp;

  const MiddleDivider(this.onEncode, this.onDecode, this.onCopyUp, {super.key});

  @override
  State<MiddleDivider> createState() => _MiddleDividerState();
}

class _MiddleDividerState extends State<MiddleDivider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
            onPressed: widget.onCopyUp,
            style: TextButton.styleFrom(
                backgroundColor: Colors.amber,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                overlayColor: Colors.red,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.amber))),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(
                Icons.keyboard_double_arrow_up,
                color: Colors.black,
                size: 32,
              ),
            )),
        const SizedBox(
          width: 64,
        ),
        TextButton(
          onPressed: widget.onEncode,
          style: TextButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              overlayColor: Colors.red,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Colors.amber))),
          child: const Text(
            Strings.encodeStr,
            style: TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 64.0),
          child: Icon(Icons.arrow_downward_rounded),
        ),
        TextButton(
          onPressed: widget.onDecode,
          style: TextButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              overlayColor: Colors.red,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Colors.amber))),
          child: const Text(
            Strings.decodeStr,
            style: TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
