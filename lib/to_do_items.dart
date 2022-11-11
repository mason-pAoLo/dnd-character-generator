import 'package:flutter/material.dart';

class Item {
  const Item({required this.name});

  final String name;

  String abbrev() {
    return name.substring(0, 1);
  }
}

typedef ToDoListChangedCallback = Function(
    Item item, bool completed, bool favorited, String action);
typedef ToDoListRemovedCallback = Function(Item item);

class ToDoListItem extends StatelessWidget {
  ToDoListItem(
      {required this.item,
      required this.completed,
      required this.onListChanged,
      required this.onDeleteItem,
      required this.favorited})
      : super(key: ObjectKey(item));

  final Item item;
  final bool completed;
  final bool favorited;
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.
    return completed //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!completed) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onListChanged(item, completed, favorited, "completed");
        },
        onLongPress: completed
            ? () {
                onDeleteItem(item);
              }
            : null,
        leading: CircleAvatar(
          backgroundColor: _getColor(context),
          child: Text(item.abbrev()),
        ),
        title: Text(
          item.name,
          style: _getTextStyle(context),
        ),
        trailing: IconButton(
            key: Key('favButton'),
            icon: Icon(Icons.favorite),
            onPressed: () {
              onListChanged(item, completed, favorited, "favorited");
            },
            iconSize: 24,
            color: favorited ? Colors.red[900] : Colors.grey[500]));
  }
}
