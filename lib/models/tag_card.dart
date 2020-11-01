import 'package:flutter/material.dart';

class TagCard extends StatefulWidget {
  final String value;
  final Function addTag;
  final Function removeTag;
  TagCard({this.addTag, this.removeTag, this.value});
  @override
  _TagCardState createState() => _TagCardState();
}

class _TagCardState extends State<TagCard> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _isPressed
            ? widget.removeTag(widget.value)
            : widget.addTag(widget.value);
        setState(() {
          _isPressed = !_isPressed;
        });
      },
      child: Container(
        color: _isPressed ? Colors.green : Colors.amber,
        child: Center(
          child: Text(widget.value),
        ),
      ),
    );
  }
}
