import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helper/tag_helper.dart';

class TagDropDownMenu extends StatefulWidget {
  final void Function(String value) setTag;

  TagDropDownMenu(this.setTag);
  @override
  _TagDropDownMenuState createState() => _TagDropDownMenuState();
}

class _TagDropDownMenuState extends State<TagDropDownMenu> {
  List<String> _tag = TagHelper.tags;
  String dropdownValue = 'Technology';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          widget.setTag(newValue);
        });
      },
      items: _tag.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
