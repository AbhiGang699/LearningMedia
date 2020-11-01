import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helper/tag_helper.dart';
import 'package:flutter_complete_guide/models/tag_card.dart';

class SelectTags extends StatefulWidget {
  final Function addTag;
  final Function removeTag;
  SelectTags(this.addTag, this.removeTag);
  @override
  _SelectTagsState createState() => _SelectTagsState();
}

class _SelectTagsState extends State<SelectTags> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView.builder(
      itemCount: TagHelper.tags.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
      itemBuilder: (BuildContext context, int index) {
        return TagCard(
          addTag: widget.addTag,
          value: TagHelper.tags[index],
          removeTag: widget.removeTag,
        );
      },
    ));
  }
}
