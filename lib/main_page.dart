import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final ctrl3 = TextEditingController();
  final ctrl4 = TextEditingController();

  @override
  void dispose() {
    ctrlEncoded.dispose();
    ctrlDecoded.dispose();
    ctrl3.dispose();
    ctrl4.dispose();

    super.dispose();
  }

  void onChangedEncoded(String val) {
    print("onChangeEnc");
    controller.decode(val);
    ctrlDecoded.text = controller.textDecoded.value;
  }

  void onChangedDecoded(String val) {
    print("onChangeDec");
    controller.encode(val);
    ctrlEncoded.text = controller.textEncoded.value;
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
          const Divider(),
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
