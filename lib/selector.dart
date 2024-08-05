import 'package:flutter/material.dart';

import 'hex_controller.dart';

class Selector extends StatefulWidget {
  final List<Encoders> items;
  final Function(Encoders) onTap;

  const Selector({Key? key, required this.items, required this.onTap})
      : super(key: key);

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index) {
        final encoder = widget.items[index];
        final isSelected = _selectedIndex == index;

        return Ink(
            color: isSelected ? Colors.amber : Colors.transparent,
            child: ListTile(
              tileColor: isSelected ? Colors.orange : null,
              selected: isSelected,
              title: Text(encoder.name.toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? Colors.black87 : Colors.white,
                  )),
              onTap: () {
                setState(() {
              _selectedIndex = index;
            });
            widget.onTap(encoder);
          },
            ));
      },
    );
  }
}
