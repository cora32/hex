import 'package:flutter/material.dart';
import 'package:hex/selector.dart';

import 'hex_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = HexController();
  final ctrl1 = TextEditingController();
  final ctrl2 = TextEditingController();

  @override
  void dispose() {
    ctrl1.dispose();
    ctrl2.dispose();

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
            child: TextField(
              controller: ctrl1,
              onChanged: encode,
              decoration: const InputDecoration(
                  border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
            ),
          ),
          const Divider(),
          Expanded(
            child: TextField(
              controller: ctrl2,
              onChanged: decode,
              decoration: const InputDecoration(
                  border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        getSelector(),
        const VerticalDivider(),
        Expanded(child: getFields())
      ],
    );
  }
}
